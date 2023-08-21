// the purpose of this file is to fetch books from the database to be displayed in the app

import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:openapi/openapi.dart';
import 'dart:convert';
import 'package:built_collection/built_collection.dart';

// database imports
import 'package:jellybook/models/entry.dart';
import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
import 'package:jellybook/variables.dart';

// get comics
Future<List<Entry>> getComics(String comicsId, String etag) async {
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
  // '$url/Users/$userId/Items?StartIndex=0&Fields=PrimaryImageAspectRatio,SortName,Path,SongCount,ChildCount,MediaSourceCount,Tags,Overview,ParentId&ImageTypeLimit=1&ParentId=$comicsId&Recursive=true&SortBy=SortName&SortOrder=Ascending'),
  var headers = {
    'Accept': 'application/json',
    'Connection': 'keep-alive',
    'Accept-Language': 'en-US,en;q=0.5',
    'Accept-Encoding': 'gzip, deflate',
    'X-Emby-Authorization':
        'MediaBrowser Client="$client", Device="$device", DeviceId="$deviceId", Version="$version", Token="$token"',
  };
  // make a built list of the fields

  BuiltList<ItemFields> fieldsList = BuiltList<ItemFields>([
    ItemFields.sortName,
    ItemFields.path,
    ItemFields.childCount,
    ItemFields.mediaSourceCount,
    ItemFields.tags,
    ItemFields.overview,
    ItemFields.parentId,
  ]);

  // turn into built list
  final api = Openapi(basePathOverride: url).getItemsApi();
  var response;
  try {
    response = await api.getItemsByUserId(
      userId: userId!,
      headers: headers,
      startIndex: 0,
      fields: fieldsList,
      imageTypeLimit: 1,
      parentId: comicsId,
      recursive: true,
      sortBy: BuiltList<String>(["IsFolder", "SortName"]),
      sortOrder: BuiltList<SortOrder>([SortOrder.ascending]),
    );
    // logger.d(response.data);
  } catch (e) {
    logger.e(e);
  }
  var responseData;
  // await response.then((value) {
  responseData = response.data.items;
  //   logger.d(value.body);
  //   responseData = jsonDecode(value.body);
  // });

  logger.d("Now saving comics to database");

  final isar = Isar.getInstance();
  Entry entry;
  // get entries from the database
  try {
    final entries = await isar!.entrys.where().idEqualTo(comicsId).findAll();
    logger.d("entries: $entries");
    logger.d("entries length: ${entries.length}");
  } catch (e) {
    logger.e(e.toString());
  }

  logger.d("got box");
  final entries = await isar!.entrys.where().findAll();
  logger.d("got entries");

  List<Map<String, dynamic>> comics = [];
  responseData.forEach((element) {
    if (element.type.toString() == "book") {
      // logger.d("element: $element");
      comics.add({
        'id': element.id ?? '',
        'name': element.name ?? '',
        // 'imagePath':
        //     '$url/Items/${element.id}/Images/Primary?&quality=90&Tag=${element.imageTags!['Primary']}',
        // // if the imageTags!['Primary'] is null then we use 'Asset' instead
        'imagePath': element.imageTags!['Primary'] != null
            ? '$url/Items/${element.id}/Images/Primary?&quality=90&Tag=${element.imageTags!['Primary']}'
            : 'Asset',
        'releaseDate': element.productionYear.toString(),
        'path': element.path ?? '',
        'description': element.overview ?? '',
        'url': url ?? '',
        if (element.communityRating != null)
          'rating': element.communityRating.toDouble(),
        // if (element.type.toString().toLowerCase() == 'folder') 'type': 'folder',
        if (element.type.toString() == 'Book')
          'type': element.path.toString().split('.').last.toLowerCase(),
        if (element.isFolder != null && element.isFolder != false)
          'type': 'folder',
        //  elmeent.tags convert to List<String> from _BuiltList<String>
        if (element.tags != null) 'tags': element.tags!.toList() ?? [],
        // 'tags': element.tags ?? [],
        'parentId': element.parentId ?? '',
        'isFavorited': element.userData?.isFavorite ?? false,
        'downloaded': false,
      });
    }
  });

  // add the entry to the database
  logger.d("attempting to add book to database");
  await responseData.forEach((element) async {
    // for (var i = 0; i < responseData['Items'].length; i++) {
    try {
      List<String> bookFileTypes = ['pdf', 'epub', 'mobi', 'azw3', 'kpf'];
      List<String> comicFileTypes = ['cbz', 'cbr', 'zip', 'rar'];
      List<String> audioFileTypes = ['mp3', 'm4a', 'm4b', 'flac'];
      String id = element.id ?? '0';
      String title = element.name ?? '';
      // String imagePath =
      //     "$url/Items/${responseData['Items'][i]['Id']}/Images/Primary?&quality=90&Tag=${responseData['Items'][i]['ImageTags']['Primary']}";
      String imagePath =
          '$url/Items/${element.id}/Images/Primary?&quality=90&Tag=${element.imageTags!['Primary']}';
      if (element.imageTags!['Primary'] == null) imagePath = 'Asset';
      String releaseDate = element.productionYear.toString() != null
          ? element.productionYear.toString()
          : '';
      String path = element.path ?? '';
      String description = element.overview ?? '';
      String url1 = url ?? '';
      double rating = -1;
      if (element.communityRating != null) {
        rating = element.communityRating.toDouble();
      }
      List<dynamic> tags1 = element.tags.toList() ?? [];
      String parentId = element.parentId ?? '';
      EntryType type = EntryType.book;
      bool isFavorited = element.userData?.isFavorite != null
          ? element.userData!.isFavorite
          : false;
      if (element.type.toString().toLowerCase() == 'folder') {
        type = EntryType.folder;
      } else if (bookFileTypes
          .contains(element.path.toString().split('.').last.toLowerCase())) {
        type = EntryType.book;
      } else if (comicFileTypes
          .contains(element.path.toString().split('.').last.toLowerCase())) {
        type = EntryType.comic;
      } else if (audioFileTypes
          .contains(element.path.toString().split('.').last.toLowerCase())) {
        type = EntryType.audiobook;
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
        logger.d("updating entry due to entryExists1");
        entry.downloaded = entryExists.downloaded;
        // change the downloaded value if it is already in the database (in comics List)
        comics.indexWhere((comic) {
          if (comic['id'] == entry.id) {
            comic['downloaded'] = entry.downloaded;
            comic['tags'] += entry.tags;
            return true;
          } else {
            return false;
          }
        });
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
  });

  final List<Entry> entrys =
      await isar.entrys.filter().not().typeEqualTo(EntryType.folder).findAll();
  return entrys;
}

Map<String, String> getHeaders(String url, String client, String device,
    String deviceId, String version, String token) {
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
