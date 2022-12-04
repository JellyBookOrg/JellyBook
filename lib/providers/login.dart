// This files purpose is to attempt to login to the server
// this is not the screen, it is just the request and response

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:isar/isar.dart';
import 'package:jellybook/models/login.dart';

class LoginProvider {
  final String url;
  final String username;
  final String password;

  LoginProvider({
    required this.url,
    required this.username,
    required this.password,
  });

  // a curl request to the server would look like this:
  /*
     curl 'http://[REDACTED]/Users/authenticatebyname' -X POST -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:107.0) Gecko/20100101 Firefox/107.0' -H 'Accept: application/json' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate' -H 'X-Emby-Authorization: MediaBrowser Client="Jellyfin Web", Device="Firefox", DeviceId="[REDACTED]", Version="10.8.5"' -H 'Content-Type: application/json' -H 'Origin: [REDACTED]' -H 'Connection: keep-alive' --data-raw '{"Username":"example","Pw":""}' > output
     */

  // make a static version of the above class
  static Future<String> loginStatic(String url, String username,
      [String password = ""]) async {
    debugPrint("LoginStatic called");
    final storage = FlutterSecureStorage();
    String _url = "$url/Users/authenticatebyname";
    const _client = "JellyBook";
    const _device = "Unknown Device";
    const _deviceId = "Unknown Device id";
    late String _version;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _version = packageInfo.version;

    if ((!url.contains("http://") || !url.contains("https://")) == false) {
      debugPrint("URL does not contain http:// or https://");
      return "Plase add http:// or https:// to the url";
    }

    // make a request with different headers depending on if http or https

    final Map<String, String> headers =
        getHeaders(url, _client, _device, _deviceId, _version);
    debugPrint("Headers: $headers");

    final Map<String, String> body = {
      "Username": username,
      "Pw": password,
    };

    debugPrint("Attempting to login to $url");
    if (!_url.contains("http")) {
      _url = "http://$_url";
    }
    // check if the last character is a /
    if (_url.endsWith("/")) {
      _url = _url.substring(0, _url.length - 1);
    }
    // check if url is valid using regex (allow other languages and emojis)
    final RegExp urlTest = RegExp(
        r"^(http|https)://[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+([a-zA-Z0-9-._~:/?#[\]@!$&'()*+,;=]*)?$");
    if (!urlTest.hasMatch(_url)) {
      debugPrint("URL is not valid");
      // tell why it is not valid
      if (!_url.contains("http")) {
        return "URL does not contain http:// or https://";
      }
      if (!_url.contains(".")) {
        return "URL does not contain a .";
      }
      if (!_url.contains("/")) {
        return "URL does not contain a /";
      }
      if (_url.endsWith("/")) {
        return "URL ends with a /";
      }
      if (_url.contains(" ")) {
        return "URL contains a space";
      }
      return "URL is not valid";
    }

    var response = await Dio().post(
      _url,
      data: body,
      options: Options(
        headers: headers,
      ),
    );
    debugPrint("Response: ${response.statusCode}");
    debugPrint("Response: ${response.data}");

    if (response.statusCode == 200) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      debugPrint("saving data to cache");
      prefs.setString("server", url);
      prefs.setString("accessToken", response.data["AccessToken"]);
      prefs.setString("ServerId", response.data["ServerId"]);
      prefs.setString("UserId", response.data["SessionInfo"]["UserId"]);

      // now for the stuff that is not needed for all sessions
      debugPrint("saving data part 2");
      prefs.setString("client", _client);
      prefs.setString("device", _device);
      prefs.setString("deviceId", _deviceId);
      prefs.setString("version", _version);

      // now save the username and password to the secure storage
      debugPrint("saving data part 3");
      await storage.write(key: "server", value: url);
      await storage.write(key: "username", value: username);
      await storage.write(key: "password", value: password);
      await storage.write(
          key: "AccessToken", value: response.data["AccessToken"]);
      await storage.write(key: "ServerId", value: response.data["ServerId"]);
      await storage.write(
          key: "UserId", value: response.data["SessionInfo"]["UserId"]);
      await storage.write(key: "client", value: _client);
      await storage.write(key: "device", value: _device);
      await storage.write(key: "deviceId", value: _deviceId);
      await storage.write(key: "version", value: _version);
      debugPrint("saved data");

      // now save the data to the isar database
      debugPrint("saving data to isar");
      final isar = Isar.getInstance();
      // check if the user already exists
      final entry =
          await isar!.logins.where().serverUrlEqualTo(url).findFirst();
      if (entry == null) {
        // if the user does not exist, create a new one
        Login login = Login(
          serverUrl: url,
          username: username,
          password: password,
        );
        // save the login to the database
        await isar.writeTxn(() async {
          await isar.logins.put(login);
        });
      }

      return "true";
    } else {
      if (response.statusCode == 401) {
        debugPrint("401");
        return "Incorrect username or password";
      } else if (response.statusCode == 404) {
        debugPrint("404");
        return "Server not found";
      } else {
        debugPrint("other");
        return "Error: ${response.statusCode}";
      }
    }
  }
}

// getHeaders returns the headers depending on if the url is http or https
Map<String, String> getHeaders(
    String url, String client, String device, String deviceId, String version) {
  if (url.contains("https://")) {
    return {
      "Accept": "application/json",
      "Accept-Language": "en-US,en;q=0.5",
      "Accept-Encoding": "gzip, deflate",
      "Content-Type": "application/json",
      "Sec-Fetch-Dest": "empty",
      "Sec-Fetch-Mode": "cors",
      "Sec-Fetch-Site": "same-origin",
      "Origin": url,
      "Connection": "keep-alive",
      "TE": "Trailers",
      "X-Emby-Authorization":
          "MediaBrowser Client=\"$client\", Device=\"$device\", DeviceId=\"$deviceId\", Version=\"$version\"",
    };
  }
  return {
    "Accept": "application/json",
    "Accept-Language": "en-US,en;q=0.5",
    "Accept-Encoding": "gzip, deflate",
    "X-Emby-Authorization":
        "MediaBrowser Client=\"$client\", Device=\"$device\", DeviceId=\"$deviceId\", Version=\"$version\"",
    "Content-Type": "application/json",
    "Origin": url,
    "Connection": "keep-alive",
  };
}
