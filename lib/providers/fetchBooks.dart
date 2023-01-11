// the purpose of this file is to fetch books from the database to be displayed in the app

import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as Http;
import 'dart:convert';

// database imports
import 'package:jellybook/models/entry.dart';
import 'package:isar/isar.dart';

// get comics
Future<List<Map<String, dynamic>>> getComics(String comicsId, String etag) async {
  var logger = Logger();
  logger.d('getting comics');
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
    Uri.parse(
        '$url/Users/$userId/Items?StartIndex=0&Fields=PrimaryImageAspectRatio,SortName,Path,SongCount,ChildCount,MediaSourceCount,Tags,Overview,ParentId&ImageTypeLimit=1&ParentId=$comicsId&Recursive=true&SortBy=SortName&SortOrder=Ascending'),
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
    logger.d(value.body);
    responseData = jsonDecode(value.body);
  });

  logger.d("Now saving comics to database");

  final isar = Isar.getInstance();
  // get entries from the database
  try {
    final entries = await isar!.entrys.where().idEqualTo(comicsId).findAll();
    logger.d("entries: $entries");
    logger.d("entries length: ${entries.length}");
  } catch (e) {
    logger.e(e.toString());
  }

  logger.d("got box");
  var entries = await isar!.entrys.where().findAll();
  logger.d("got entries");

  List<Map<String, dynamic>> comics = [];
  for (var i = 0; i < responseData['Items'].length; i++) {
    if (responseData['Items'][i]['Type'] == 'Book') {
      comics.add({
        'id': responseData['Items'][i]['Id'] ?? '',
        'name': responseData['Items'][i]['Name'] ?? '',
        'imagePath':
            "$url/Items/${responseData['Items'][i]['Id']}/Images/Primary?&quality=90&Tag=${responseData['Items'][i]['ImageTags']['Primary']}",
        if (responseData['Items'][i]['ImageTags']['Primary'] == null) 'imagePath': 'Asset',
        'releaseDate': responseData['Items'][i]['ProductionYear'].toString(),
        'path': responseData['Items'][i]['Path'] ?? '',
        'description': responseData['Items'][i]['Overview'] ?? '',
        'url': url ?? '',
        if (responseData['Items'][i]['CommunityRating'] != null)
          'rating': responseData['Items'][i]['CommunityRating'].toDouble(),
        // type
        if (responseData['Items'][i]['Type'] == 'Folder') 'type': 'folder',
        if (responseData['Items'][i]['Type'] == 'Book')
          'type': responseData['Items'][i]['Path'].toString().split('.').last.toLowerCase(),

        "tags": responseData['Items'][i]['Tags'] ?? [],
        'parentId': responseData['Items'][i]['ParentId'] ?? '',
        'isFavorited': responseData['Items'][i]['UserData']['IsFavorite'] ?? false,
      });
      logger.d(responseData['Items'][i]['Name']);
    }
  }

  // add the entry to the database
  logger.d("attempting to add book to database");
  for (var i = 0; i < responseData['Items'].length; i++) {
    try {
      List<String> bookFileTypes = ['pdf', 'epub', 'mobi', 'azw3', 'kpf'];
      List<String> comicFileTypes = ['cbz', 'cbr'];
      String id = responseData['Items'][i]['Id'] ?? '0';
      String title = responseData['Items'][i]['Name'] ?? '';
      String imagePath =
          "$url/Items/${responseData['Items'][i]['Id']}/Images/Primary?&quality=90&Tag=${responseData['Items'][i]['ImageTags']['Primary']}";
      if (responseData['Items'][i]['ImageTags']['Primary'] == null) {
        imagePath = 'Asset';
      }
      String releaseDate = responseData['Items'][i]['ProductionYear'].toString();
      String path = responseData['Items'][i]['Path'] ?? '';
      String description = responseData['Items'][i]['Overview'] ?? '';
      String url1 = url ?? '';
      double rating = -1;
      if (responseData['Items'][i]['CommunityRating'] != null) {
        rating = responseData['Items'][i]['CommunityRating'].toDouble();
      }
      List<dynamic> tags1 = responseData['Items'][i]['Tags'] ?? [];
      String parentId = responseData['Items'][i]['ParentId'] ?? '';
      String type = "Book";
      bool isFavorited = responseData['Items'][i]['UserData']['IsFavorite'] ?? false;
      if (responseData['Items'][i]['Type'] == 'Folder') {
        type = 'Folder';
      } else if (responseData['Items'][i]['Type'] == 'Book') {
        if (bookFileTypes.contains(responseData['Items'][i]['Path'].toString().split('.').last.toLowerCase())) {
          type = "Book";
        } else if (comicFileTypes.contains(responseData['Items'][i]['Path'].toString().split('.').last.toLowerCase())) {
          type = "Comic";
        }
      }
      if (responseData['Items'][i]['Type'] == 'Book') {
        if (bookFileTypes.contains(responseData['Items'][i]['Type'])) {
          type = "Book";
        } else if (comicFileTypes.contains(responseData['Items'][i]['Type'])) {
          type = "Comic";
        }
      }
      var entryExists = await isar.entrys.where().idEqualTo(id).findFirst();
      bool entryExists1 = entryExists != null;
      Entry entry = Entry(
        id: id,
        title: title,
        description: description,
        imagePath: imagePath,
        releaseDate: releaseDate,
        path: path,
        url: url1,
        rating: rating,
        tags: tags1.map((e) => e.toString()).toList(),
        downloaded: false,
        progress: 0.0,
        type: type,
        parentId: parentId,
        isFavorited: isFavorited,
      );
      if (entryExists1) {
        entry.isarId = entryExists.isarId;
        entry.downloaded = entryExists.downloaded;
        entry.progress = entryExists.progress;
        entry.folderPath = entryExists.folderPath;
        entry.filePath = entryExists.filePath;
        entry.epubCfi = entryExists.epubCfi;
        entry.pageNum = entryExists.pageNum;
      }

      await isar.writeTxn(() async {
        await isar.entrys.put(entry);
      });
    } catch (e) {
      logger.e(e.toString());
    }
  }

  return comics;
}

Map<String, String> getHeaders(
    String url, String client, String device, String deviceId, String version, String token) {
  var logger = Logger();
  logger.d("getting headers");
  logger.d(url);
  logger.d(client);
  logger.d(device);
  logger.d(deviceId);
  logger.d(version);
  logger.d(token);
  var uri = Uri.parse(url);
  var headers = {
    'Accept': 'application/json',
    'Accept-Language': 'en-US,en;q=0.5',
    'Accept-Encoding': 'gzip, deflate',
    'X-Emby-Authorization':
        'MediaBrowser Client="$client", Device="$device", DeviceId="$deviceId", Version="$version", Token="$token"',
    'Connection': 'keep-alive',
  };

  if (uri.scheme == "https") {
    headers.addAll({
      'Host': uri.host,
      'Sec-Fetch-Dest': 'empty',
      'Sec-Fetch-Mode': 'cors',
      'Sec-Fetch-Site': 'same-origin',
    });
  }

  return headers;
}
