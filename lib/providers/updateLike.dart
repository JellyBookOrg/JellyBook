// The purpose of this file is to update the like status of a book/comic entry in the database

import 'package:isar/isar.dart';
import 'package:jellybook/models/entry.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart';

Future<void> updateLike(String id) async {
  final isar = Isar.getInstance();
  final entries = await isar!.entrys.where().idEqualTo(id).findFirst();
  entries!.isFavorited = !entries.isFavorited;
  // save the entry to the database
  await isar.writeTxn(() async {
    await isar.entrys.put(entries);
  });
  // update the entry on the server
  // example of curl for making it favorite
  // curl 'http://99.253.1.162:8096/Users/a92cd45eddf843d096a6be47433a7ac4/FavoriteItems/d02d230713ce7a65c6aba68b354fd520' -X POST -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/109.0' -H 'Accept: application/json' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate' -H 'X-Emby-Authorization: MediaBrowser Client="Jellyfin Web", Device="Firefox", DeviceId="TW96aWxsYS81LjAgKFgxMTsgTGludXggeDg2XzY0OyBydjoxMDcuMCkgR2Vja28vMjAxMDAxMDEgRmlyZWZveC8xMDcuMHwxNjY2NDkwMTI4NTky", Version="10.8.8", Token="0018719ef0094827b15802e4953d02da"' -H 'Origin: http://99.253.1.162:8096' -H 'Connection: keep-alive' -H 'Content-Length: 0'

  final dio = Dio();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  final prefs = await SharedPreferences.getInstance();
  final storage = new FlutterSecureStorage();
  final server = prefs.getString('server')!;
  final userId = prefs.getString('UserId')!;
  final token = prefs.getString('accessToken')!;
  final version = packageInfo.version;
  const _client = "JellyBook";
  const _device = "Unknown Device";
  const _deviceId = "Unknown Device id";

  final url = server + '/Users/' + userId + '/FavoriteItems/' + id;
  final headers = {
    'Accept': 'application/json',
    'Accept-Language': 'en-US,en;q=0.5',
    'Accept-Encoding': 'gzip, deflate',
    'Content-Type': 'application/json',
    "X-Emby-Authorization":
        "MediaBrowser Client=\"$_client\", Device=\"$_device\", DeviceId=\"$_deviceId\", Version=\"$version\", Token=\"$token\"",
    'Connection': 'keep-alive',
    'Origin': server,
    'Host': // should be server minus the http://
        server.substring(server.indexOf("//") + 2, server.length),
    'Content-Length': '0',
  };
  final data = {};
  debugPrint(url);
  if (entries.isFavorited) {
    try {
      final response =
          await dio.post(url, data: data, options: Options(headers: headers));
      debugPrint(response.data.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  } else {
    try {
      final response =
          await dio.delete(url, data: data, options: Options(headers: headers));
      debugPrint(response.data.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
