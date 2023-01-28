// The purpose of this file is to update the like status of a book/comic entry in the database

import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
import 'package:jellybook/models/entry.dart';
import 'package:openapi/openapi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart' as p_info;
import 'package:logger/logger.dart';

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
  // curl 'http://[REDACTED]/Users/[REDACTED]/FavoriteItems/[REDACTED]' -X POST -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/109.0' -H 'Accept: application/json' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate' -H 'X-Emby-Authorization: MediaBrowser Client="Jellyfin Web", Device="Firefox", DeviceId="[REDACTED]", Version="10.8.8", Token="[REDACTED]"' -H 'Origin: http://99.253.1.162:8096' -H 'Connection: keep-alive' -H 'Content-Length: 0'

  var logger = Logger();
  p_info.PackageInfo packageInfo = await p_info.PackageInfo.fromPlatform();
  final prefs = await SharedPreferences.getInstance();
  final storage = FlutterSecureStorage();
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
    'Host': server.substring(server.indexOf("//") + 2, server.length),
    'Content-Length': '0',
  };
  final api = Openapi(basePathOverride: server).getUserLibraryApi();
  logger.d(url);
  if (entries.isFavorited == false) {
    try {
      final response = await api.unmarkFavoriteItem(
          userId: userId, itemId: id, headers: headers, url: server);
      logger.d(response.data.toString());
    } catch (e) {
      logger.e(e.toString());
    }
  } else {
    try {
      final response = await api.markFavoriteItem(
          userId: userId, itemId: id, headers: headers, url: server);
      logger.d(response.data.toString());
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
