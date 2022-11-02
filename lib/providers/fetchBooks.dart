// the purpose of this file is to fetch books from the database to be displayed in the app

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as Http;
import 'dart:convert';

// get comics
Future<List<Map<String, dynamic>>> getComics(
    String comicsId, String etag) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('accessToken');
  final url = prefs.getString('server');
  final userId = prefs.getString('UserId');
  final client = prefs.getString('client');
  final device = prefs.getString('device');
  final deviceId = prefs.getString('deviceId');
  final version = prefs.getString('version');
  prefs.setString('comicsId', comicsId);
  final response = Http.get(
    Uri.parse('$url/Users/$userId/Items' +
        '?StartIndex=0' +
        '&Fields=PrimaryImageAspectRatio,SortName,Path,SongCount,ChildCount,MediaSourceCount,Tags,Overview' +
        '&Filters=IsNotFolder' +
        '&ImageTypeLimit=1' +
        '&ParentId=$comicsId' +
        '&Recursive=true' +
        '&SortBy=SortName' +
        '&SortOrder=Ascending'),
    headers: {
      'Accept': 'application/json',
      'Connection': 'keep-alive',
      'Accept-Language': 'en-US,en;q=0.5',
      'Accept-Encoding': 'gzip, deflate',
      'X-Emby-Authorization':
          'MediaBrowser Client="$client", Device="$device", DeviceId="$deviceId", Version="$version", Token="$token"',
    },
  );
  var responseData;
  await response.then((value) {
    debugPrint(value.body);
    responseData = json.decode(value.body);
  });

  List<Map<String, dynamic>> comics = [];
  for (var i = 0; i < responseData['Items'].length; i++) {
    if (responseData['Items'][i]['Type'] == 'Book') {
      comics.add({
        'id': responseData['Items'][i]['Id'] ?? '',
        'name': responseData['Items'][i]['Name'] ?? '',
        'imagePath':
            "$url/Items/${responseData['Items'][i]['Id']}/Images/Primary?fillHeight=316&fillWidth=200&quality=90&Tag=${responseData['Items'][i]['ImageTags']['Primary']}",
        if (responseData['Items'][i]['ImageTags']['Primary'] == null)
          'imagePath': "https://via.placeholder.com/200x316?text=No+Cover+Art",
        'releaseDate': responseData['Items'][i]['ProductionYear'].toString(),
        'path': responseData['Items'][i]['Path'] ?? '',
        'description': responseData['Items'][i]['Overview'] ?? '',
        'url': url ?? '',
        if (responseData['Items'][i]['CommunityRating'] != null)
          'rating': responseData['Items'][i]['CommunityRating'].toDouble(),
        'tags': responseData['Items'][i]['Tags'] ?? [],
      });
      debugPrint(responseData['Items'][i]['Name']);
    }
  }
  return comics;
}

Map<String, String> getHeaders(String url, String client, String device,
    String deviceId, String version, String token) {
  debugPrint("getting headers");
  debugPrint(url);
  debugPrint(client);
  debugPrint(device);
  debugPrint(deviceId);
  debugPrint(version);
  debugPrint(token);
  if (url.contains("https://")) {
    return {
      'Host': url.replaceAll("https://", ""),
      'Accept': 'application/json',
      'Accept-Language': 'en-US,en;q=0.5',
      'Accept-Encoding': 'gzip, deflate',
      'X-Emby-Authorization':
          'MediaBrowser Client="$client", Device="$device", DeviceId="$deviceId", Version="$version", Token="$token"',
      'Connection': 'keep-alive',
      'Sec-Fetch-Dest': 'empty',
      'Sec-Fetch-Mode': 'cors',
      'Sec-Fetch-Site': 'same-origin',
    };
  }
  return {
    'Accept': 'application/json',
    'Accept-Language': 'en-US,en;q=0.5',
    'Accept-Encoding': 'gzip, deflate',
    'X-Emby-Authorization':
        'MediaBrowser Client="$client", Device="$device", DeviceId="$deviceId", Version="$version", Token="$token"',
    'Connection': 'keep-alive',
  };
}
