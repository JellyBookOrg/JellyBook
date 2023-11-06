// This files purpose is to attempt to login to the server
// this is not the screen, it is just the request and response

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart' as package_info;
import 'package:isar/isar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jellybook/models/login.dart';
import 'package:openapi/openapi.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:jellybook/variables.dart';

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
  static Future<String> loginStatic(
      String url, String username, BuildContext context,
      [String password = ""]) async {
    logger.d("LoginStatic called");
    final storage = FlutterSecureStorage();
    // String _url = "$url/Users/authenticatebyname";
    String _url = url;
    final BuildContext _context = context;
    const _client = "JellyBook";
    String _device;
    String _deviceId;
    late String _version;

    logger.d("getDeviceInfo called");
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    _device = "Unknown Device";
    _deviceId = "Unknown Device id";
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      _device = androidInfo.model;
      _deviceId = "Android ${androidInfo.version.release}";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      _device = iosInfo.name;
      _device = iosInfo.identifierForVendor ?? "Unknown Device id";
    }

    package_info.PackageInfo packageInfo =
        await package_info.PackageInfo.fromPlatform();

    _version = packageInfo.version;

    logger.d("Attempting to login to $url");

    // check if the last character is a /
    if (_url.endsWith("/")) {
      _url = _url.substring(0, _url.length - 1);
    }
    // check if url is valid using regex (allow other languages and emojis)
    final RegExp urlTest = RegExp(r"^(http|https)://+.+");
    if (!urlTest.hasMatch(_url)) {
      logger.e("URL is not valid");
      // tell why it is not valid
      if (!_url.startsWith("http")) {
        return AppLocalizations.of(_context)?.noHttp ??
            "URL does not start with http:// or https://";
      }
      if (!_url.contains(".")) {
        return AppLocalizations.of(_context)?.noDot ??
            "URL does not contain a .";
      }
      if (!_url.contains("/")) {
        return AppLocalizations.of(_context)?.noSlash ??
            "URL does not contain a /";
      }
      return AppLocalizations.of(_context)?.invalidUrl ??
          "URL is not valid. Please check the URL and try again.";
    }

    final api = Openapi(basePathOverride: _url);
    final apiInstance = api.getUserApi();
    var response;

    try {
      // use the authenticateUserByNameRequest from openapi/lib/src/model/authenticate_user_by_name_request.g.dart
      var authenticateUserByNameRequest = AuthenticateUserByNameRequest((b) => b
        ..username = username
        ..pw = password);
      // set the headers
      final headers = getHeaders(url, _client, _device, _deviceId, _version);
      response = await apiInstance.authenticateUserByName(
          authenticateUserByNameRequest: authenticateUserByNameRequest,
          headers: headers);
      logger.d("Status Code: ${response.statusCode}");
    } catch (e) {
      logger.e("Error:\n$e");
      return e.toString();
      // logger.e('Exception when calling UserApi->authenticateUserByName: $e\n');
    }

    logger.d("Response: ${response.statusCode}");
    // logger.d("Response: ${response.data}");

    if (response.statusCode == 200) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      logger.d("saving data to cache");
      prefs.setString("server", url);
      prefs.setString("accessToken", response.data.accessToken);
      prefs.setString("UserId", response.data.user.id);
      prefs.setString("ServerId", response.data.serverId);

      // now for the stuff that is not needed for all sessions
      logger.d("saving data part 2");
      prefs.setString("client", _client);
      prefs.setString("device", _device);
      prefs.setString("deviceId", _deviceId);
      prefs.setString("version", _version);

      // now save the username and password to the secure storage
      logger.d("saving data part 3");
      await storage.write(key: "server", value: url);
      await storage.write(key: "username", value: username);
      await storage.write(key: "password", value: password);
      await storage.write(key: "accessToken", value: response.data.accessToken);
      await storage.write(key: "ServerId", value: response.data.serverId);
      await storage.write(
          key: "UserId", value: response.data.sessionInfo.userId);
      await storage.write(key: "client", value: _client);
      await storage.write(key: "device", value: _device);
      await storage.write(key: "deviceId", value: _deviceId);
      await storage.write(key: "version", value: _version);
      logger.d("saved data");

      // now save the data to the isar database
      logger.d("saving data to isar");
      final isar = Isar.getInstance();
      // check if the user already exists
      final entry =
          await isar!.logins.where().serverUrlEqualTo(url).findFirst();
      if (entry == null) {
        // if the user does not exist but a different user does, delete the different user
        List<Login> entry2 = await isar.logins.where().findAll();
        List<int> entry2Ids = [];
        for (var i = 0; i < entry2.length; i++) {
          if (entry2[i].serverUrl != url) {
            entry2Ids.add(entry2[i].isarId);
          }
        }

        await isar.writeTxn(() async {
          isar.logins.deleteAll(entry2Ids);
        });

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
        logger.e("401");
        return AppLocalizations.of(_context)?.invalidCredentials ??
            "Incorrect username or password";
      } else if (response.statusCode == 404) {
        logger.e("404");
        return AppLocalizations.of(_context)?.serverNotFound ??
            "Server not found\nPlease check the URL";
      } else if (response.statusCode == 407) {
        logger.e("407");
        return AppLocalizations.of(_context)?.proxyAuthRequired ??
            "Proxy authentication required\nPlease check the server logs";
      } else if (response.statusCode == 408) {
        logger.e("408");
        return AppLocalizations.of(_context)?.requestTimeout ??
            "Request timeout\nPlease check the server logs";
      } else if (response.statusCode == 418) {
        logger.e("418");
        return AppLocalizations.of(_context)?.dontBrewCoffee ??
            "Do not brew coffee with me. I am a teapot";
      } else if (response.statusCode == 500) {
        logger.e("500");
        return AppLocalizations.of(_context)?.serverError ??
            "Server error\nPlease check the server logs";
      } else if (response.statusCode == 502) {
        logger.e("502");
        return AppLocalizations.of(_context)?.badGateway ??
            "Bad gateway\nPlease check the server logs";
      } else {
        logger.e("Unknown error");
        return (AppLocalizations.of(_context)?.error ?? "Error:") +
            " ${response.statusCode}";
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
