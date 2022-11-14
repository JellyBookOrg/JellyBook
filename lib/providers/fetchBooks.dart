// the purpose of this file is to fetch books from the database to be displayed in the app

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as Http;
import 'dart:convert';

// database imports
import 'package:jellybook/models/entry.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// get comics
Future<List<Map<String, dynamic>>> getComics(
    String comicsId, String etag) async {
  debugPrint("getting comics");
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

  debugPrint("Now saving comics to database");

  // get entries from the database
  try {
    var box = Hive.box<Entry>('bookShelf');
    // list contents of the box
    box.values.forEach((element) {
      debugPrint(element.title);
    });
    debugPrint("got entries");
  } catch (e) {
    debugPrint(e.toString());
  }

  var box = Hive.box<Entry>('bookShelf');
  debugPrint("got box");
  var entries = box.get('entries');
  debugPrint("got entries");
  debugPrint(entries.toString());

  List<Map<String, dynamic>> comics = [];
  for (var i = 0; i < responseData['Items'].length; i++) {
    if (responseData['Items'][i]['Type'] == 'Book') {
      comics.add({
        'id': responseData['Items'][i]['Id'] ?? '',
        'name': responseData['Items'][i]['Name'] ?? '',
        'imagePath':
            // "$url/Items/${responseData['Items'][i]['Id']}/Images/Primary?fillHeight=316&fillWidth=200&quality=90&Tag=${responseData['Items'][i]['ImageTags']['Primary']}",
            "$url/Items/${responseData['Items'][i]['Id']}/Images/Primary?&quality=90&Tag=${responseData['Items'][i]['ImageTags']['Primary']}",
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

  // add the entry to the database
  debugPrint("attempting to add book to database");
  for (var i = 0; i < responseData['Items'].length; i++) {
    // save the key-value pair to the database
    // add the key-pair to the database
    try {
      List<String> bookFileTypes = ['pdf', 'epub', 'mobi', 'azw3', 'kpf'];
      List<String> comicFileTypes = ['cbz', 'cbr'];
      Entry entry = Entry(
        id: responseData['Items'][i]['Id'] ?? 0,
        title: responseData['Items'][i]['Name'] ?? "",
        description: responseData['Items'][i]['Overview'] ?? '',
        imagePath: responseData['Items'][i]['ImageTags'] == null
            ? 'https://via.placeholder.com/200x316'
            : "$url/Items/${responseData['Items'][i]['Id']}/Images/Primary?fillHeight=316&fillWidth=200&quality=90&Tag=${responseData['Items'][i]['ImageTags']['Primary']}",
        releaseDate: responseData['Items'][i]['ProductionYear'].toString(),
        path: responseData['Items'][i]['Path'] ?? '',
        url: url ?? '',
        rating: responseData['Items'][i]['CommunityRating'] == null
            ? -1
            : responseData['Items'][i]['CommunityRating'].toDouble(),
        tags: responseData['Items'][i]['Tags'] ?? [],
        downloaded: false,
        progress: 0.0,
        type: comicFileTypes.contains(
                responseData['Items'][i]['Path'].split('.').last.toLowerCase())
            ? 'comic'
            : 'book',
      );

      // add the entry to the database (with the name being the id)
      // check that the entry doesn't already exist
      bool exists = false;
      box.values.forEach((element) {
        if (element.id == entry.id) {
          exists = true;
        }
      });
      if (!exists) {
        box.add(entry);
        debugPrint("book added");
      } else {
        debugPrint("book already exists");
      }
    } catch (e) {
      debugPrint(e.toString());
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
