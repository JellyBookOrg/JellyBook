// the purpose of this file is to update the play count and lastPlayedDate on jellyfin
import 'package:tentacle/tentacle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart' as p_info;
import 'package:jellybook/variables.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> updateLastPlayInfo(String id, int playCount, String lastPlayedDate) async {
  // update the entry on the server

  p_info.PackageInfo packageInfo = await p_info.PackageInfo.fromPlatform();
  final prefs = await SharedPreferences.getInstance();
  final server = prefs.getString('server')!;
  final userId = prefs.getString('UserId')!;
  final token = prefs.getString('accessToken')!;
  final version = packageInfo.version;
  const _client = "JellyBook";
  const _device = "Unknown Device";
  const _deviceId = "Unknown Device id";

  final UpdateUserItemDataDto updatedData = UpdateUserItemDataDto((UpdateUserItemDataDtoBuilder builder) {
    builder.playCount = playCount;
    builder.lastPlayedDate = DateTime.tryParse(lastPlayedDate)?.toUtc();
  });

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
  final api = Tentacle(basePathOverride: server).getItemsApi();
  try {
    final response = await api.updateItemUserData(
      userId: userId,
      itemId: id,
      headers: headers,
      updateUserItemDataDto: updatedData,
    );
    logger.d(response.statusCode);
    logger.d(response.realUri);
  } catch (e, s) {
    logger.e(e.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool useSentry = prefs.getBool('useSentry') ?? false;
    if (useSentry) await Sentry.captureException(e, stackTrace: s);
  }
}
