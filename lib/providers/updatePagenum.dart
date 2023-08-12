// the purpose of this file is to update the page number of the current page on jellyfin
import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
import 'package:jellybook/models/entry.dart';
import 'package:openapi/openapi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart' as p_info;
import 'package:jellybook/variables.dart';

Future<void> updatePagenum(String id, int pagenum) async {
  final isar = Isar.getInstance();
  final entries = await isar!.entrys.where().idEqualTo(id).findFirst();
  pagenum *= 1000;
  // update the entry on the server

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
  final api = Openapi(basePathOverride: server).getPlaystateApi();
  try {
    final response = await api.onPlaybackProgress(
      userId: userId,
      itemId: id,
      headers: headers,
      positionTicks: pagenum,
    );
    logger.d(response.statusCode);
    logger.d(response.realUri);
  } catch (e) {
    logger.e(e.toString());
  }
}
