// the purpose of this file is to fetch books from the database to be displayed in the app

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tentacle/tentacle.dart';
import 'package:built_collection/built_collection.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// database imports
import 'package:jellybook/models/entry.dart';
import 'package:jellybook/models/folder.dart';
import 'package:isar/isar.dart';
import 'package:jellybook/variables.dart';

// get comics
Future<void> getComics(String comicsId) async {
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
  final api = Tentacle(basePathOverride: url).getItemsApi();
  Response<BaseItemDtoQueryResult>? response;
  bool useSentry = prefs.getBool('useSentry') ?? false;
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
  } catch (e, s) {
    if (useSentry) await Sentry.captureException(e, stackTrace: s);
    logger.e(e);
  }
  BuiltList<BaseItemDto> responseData = response?.data?.items ?? BuiltList();

  logger.d("Now saving comics to database");

  final isar = Isar.getInstance();
  // get entries from the database
  try {
    final entries = await isar!.entrys.where().idEqualTo(comicsId).findAll();
    logger.d("entries: $entries");
    logger.d("entries length: ${entries.length}");
  } catch (e, s) {
    if (useSentry) await Sentry.captureException(e, stackTrace: s);
    logger.e(e.toString());
  }

  logger.d("got box");
  final entries = await isar!.entrys.where().findAll();
  logger.d("got entries");

  // List<Map<String, dynamic>> comics = [];
  responseData.forEach((element) {
    Entry entry = Entry(
      id: element.id ?? '',
      title: element.name ?? '',
      imagePath: element.imageTags!['Primary'] != null
          ? '$url/Items/${element.id}/Images/Primary?&quality=90&Tag=${element.imageTags!['Primary']}'
          : 'Asset',
      releaseDate: element.productionYear.toString(),
      path: element.path ?? '',
      description: element.overview ?? '',
      url: url ?? '',
      rating: element.communityRating ?? -1,
      type: element.isFolder != null && element.isFolder != false
          ? EntryType.folder
          : EntryType.book,
      tags: element.tags != null ? element.tags!.toList() : [],
      parentId: element.parentId ?? '',
      isFavorited: element.userData?.isFavorite ?? false,
      downloaded: false,
    );
    List<String> bookFileTypes = ['pdf', 'epub', 'mobi', 'azw3', 'kpf'];
    List<String> comicFileTypes = ['cbz', 'cbr', 'zip', 'rar'];
    List<String> audioFileTypes = [
      'flac',
      'mpga',
      'mp3',
      'm3u',
      'm3u8',
      'm4a',
      'm4b',
      'wav',
    ];

    String entryPath = element.path.toString().toLowerCase();
    // check if its a book, comic, or audiobook
    if (element.type.toString().toLowerCase() == 'folder') {
      entry.type = EntryType.folder;
    } else if (bookFileTypes.contains(entryPath)) {
      entry.type = EntryType.book;
    } else if (comicFileTypes.contains(entryPath)) {
      entry.type = EntryType.comic;
    } else if (audioFileTypes.contains(entryPath)) {
      entry.type = EntryType.audiobook;
    }

    entries.indexWhere((element1) {
      if (element1.id == entry.id) {
        entry.isarId = element1.isarId;
        entry.downloaded = element1.downloaded;
        entry.progress = element1.progress;
        entry.folderPath = element1.folderPath;
        entry.filePath = element1.filePath;
        entry.epubCfi = element1.epubCfi;
        entry.pageNum = element1.pageNum;

        return true;
      } else {
        return false;
      }
    });
    entries.add(entry);
  });
  await isar.writeTxn(() async {
    await isar.entrys.putAll(entries);
  });

  // update folders
  await updateFolders();
}

Future<void> updateFolders() async {
  final isar = Isar.getInstance();
  List<Entry> entryFolders =
      await isar!.entrys.filter().typeEqualTo(EntryType.folder).findAll();
  List<Entry> entrys = await isar.entrys.where().findAll();
  List<Folder> folders = [];
  folders = await isar.folders.where().findAll();
  // check if any folders are missing
  for (Entry e in entryFolders) {
    if (folders.indexWhere((element) => element.id == e.id) == -1) {
      // add folder
      Folder folder = Folder(
        id: e.id,
        name: e.title,
        image: e.imagePath,
      );
      folders.add(folder);
    }
  }
  // add entrys to folders
  for (Entry e in entrys) {
    folders.indexWhere((element) {
      if (element.id == e.parentId) {
        // make sure its not already in the list
        List<String> updatedBookIds = List.from(element.bookIds);
        if (updatedBookIds.indexWhere((element) => element == e.id) == -1) {
          updatedBookIds.add(e.id);
        }
        element.bookIds = updatedBookIds;

        return true;
      } else {
        return false;
      }
    });
  }

  await isar.writeTxn(() async {
    await isar.folders.putAll(folders);
  });
}

Map<String, String> getHeaders(
  String url,
  String client,
  String device,
  String deviceId,
  String version,
  String token,
) {
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
