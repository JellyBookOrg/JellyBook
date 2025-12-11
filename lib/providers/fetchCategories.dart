// The purpose of this file is to fetch the categories from the database

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tentacle/tentacle.dart';
import 'package:jellybook/providers/fetchBooks.dart';
import 'package:jellybook/providers/folderProvider.dart';
import 'package:jellybook/models/entry.dart';
import 'package:jellybook/models/folder.dart';
import 'package:isar/isar.dart';
import 'package:package_info_plus/package_info_plus.dart' as p_info;
import 'package:jellybook/variables.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// have optional perameter to have the function return the list of folders
Future<(List<Entry>, List<Folder>)> getServerCategories({
  force = false,
}) async {
  logger.d("getting server categories");
  final p_info.PackageInfo packageInfo =
      await p_info.PackageInfo.fromPlatform();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('accessToken') ?? "";
  final url = prefs.getString('server') ?? "";
  final userId = prefs.getString('UserId') ?? "";
  final client = prefs.getString('client') ?? "JellyBook";
  final device = prefs.getString('device') ?? "";
  final deviceId = prefs.getString('deviceId') ?? "";
  final version = prefs.getString('version') ?? packageInfo.version;

  // check if already has books and folders
  final isar = Isar.getInstance();
  final List<Folder> foldersTemp = await isar!.folders.where().findAll();
  QueryBuilder<Entry, Entry, QAfterFilterCondition> typeNotBook =
      await isar.entrys.filter().not().typeEqualTo(EntryType.folder);
  List<Entry> booksTemp =
      await typeNotBook.and().isFavoritedEqualTo(true).sortByTitle().findAll();
  booksTemp.addAll(await typeNotBook
      .and()
      .isFavoritedEqualTo(false)
      .sortByTitle()
      .findAll());
  if (foldersTemp.length > 0 && booksTemp.length > 0 && !force) {
    return (booksTemp, foldersTemp);
  }

  // turn all the previous logger.d's into a single logger.d with multiple lines
  logger.i(
      "accessToken: $token\nserver: $url\nUserId: $userId\nclient: $client\ndevice: $device\ndeviceId: $deviceId\nversion: $version");

  logger.d("got prefs");
  Map<String, String> headers =
      getHeaders(url, client, device, deviceId, version, token);
  final api = Tentacle(basePathOverride: url).getUserViewsApi();
  var response;
  try {
    response = await api.getUserViews(
      userId: userId,
      headers: headers,
      includeHidden: true,
    );
    // logger.d(response);
  } catch (e, s) {
    bool useSentry = prefs.getBool('useSentry') ?? false;
    if (useSentry) await Sentry.captureException(e, stackTrace: s);
    logger.e(e);
  }

  logger.d("got response");
  logger.d(response?.statusCode.toString());
  final data = response.data.items
      .where((element) => element.collectionType == CollectionType.books)
      .toList();

  bool hasComics = true;
  if (hasComics) {
    String comicsId = '';
    String etag = '';
    List<String> categories = [];
    // add all data['Items'] to categories
    data.forEach((element) {
      categories.add(element.name);
    });

    List<Entry> comics = [];
    List<String> comicsIds = [];
    logger.d("selected: " + categories.toString());
    data.forEach((element) {
      comicsId = element.id;
      comicsIds.add(comicsId);
      etag = element.etag;
      // comicsArray.add(getComics(comicsId, etag));
    });
    for (int i = 0; i < comicsIds.length; i++) {
      // turn List<Entry> into Iterable<Entry>
      await getComics(comicsIds[i]);
      // comics.addAll(comicsTemp);
    }
    comics = await typeNotBook.sortByTitle().findAll();
    comics.sort((a, b) => a.title.compareTo(b.title));

    prefs.setStringList('comicsIds', comicsIds);

    List<Entry> likedComics = [];
    List<Entry> unlikedComics = [];
    logger.d(comics.length.toString());
    for (int i = 0; i < comics.length; i++) {
      if (comics[i].isFavorited) {
        likedComics.add(comics[i]);
      } else {
        unlikedComics.add(comics[i]);
      }
    }

    likedComics.sort((a, b) => a.title.compareTo(b.title));
    unlikedComics.sort((a, b) => a.title.compareTo(b.title));

    logger.d("likedComics: " + likedComics.length.toString());
    logger.d("unlikedComics: " + unlikedComics.length.toString());
    comics = likedComics + unlikedComics;
    logger.d("comics: " + comics.length.toString());

    // final isar = Isar.getInstance();
    List<String> categoriesList = [];
    for (int i = 0; i < data.length; i++) {
      categoriesList.add(data[i].name);
    }
    logger.i("categoriesList: $categoriesList");
    prefs.setStringList('categories', categoriesList);
    // List<Entry> entries = await isar!.entrys.where().findAll();

    await CreateFolders.getFolders(categoriesList);
    List<Folder> folders = await isar.folders.where().findAll();

    // for (int i = 0; i < comics.length; i++) {
    //   logger.d("${comics[i].title} : ${comics[i].isarId}");
    // }

    // first 50 comics
    comics = comics.take(50).toList();

    return (comics, folders);
  }
}

Future<(int, List<Entry>)> fetchEntries(int offset, int limit) async {
  final isar = Isar.getInstance();
  // group the favorites and list them first
  QueryBuilder<Entry, Entry, QAfterFilterCondition> typeNotBook =
      isar!.entrys.filter().not().typeEqualTo(EntryType.folder);
  List<Entry> entries =
      await typeNotBook.and().isFavoritedEqualTo(true).sortByTitle().findAll();
  entries.addAll(await typeNotBook
      .and()
      .isFavoritedEqualTo(false)
      .sortByTitle()
      .findAll());
  entries = entries.skip(offset).take(limit).toList();
  int length = entries.length;
  logger.f("entries: " + entries.length.toString());
  return (length, entries);
}

// check to see if a folder isn't a subfolder of another folder
Future<List<Map<String, dynamic>>> compareFolders(
  List<Map<String, dynamic>> folders,
) async {
  logger.d("comparing folders");
  List<Map<String, dynamic>> newFolders = [];
  logger.d("folders: " + folders.length.toString());
  for (int i = 0; i < folders.length; i++) {
    logger.d("folder: " + folders[i]['name']);
    bool isSubfolder = false;
    for (int j = 0; j < folders.length; j++) {
      if (i != j) {
        if (folders[j]['entries'].contains(folders[i]['id'])) {
          isSubfolder = true;
        }
      }
    }
    if (!isSubfolder) {
      newFolders.add(folders[i]);
    }
  }
  logger.d("newFolders: " + newFolders.length.toString());
  return newFolders;
}

// function to remove entries from the database that are not in the server
Future<void> removeEntriesFromDatabase(
    List<Future<List<Map<String, dynamic>>>> comicsArray) async {
  // now see if the database has any entries that are not in the server
  // if it does, remove those from the database

  // get all the entries from the database

  final isar = Isar.getInstance();
  final entries = await isar!.entrys.where().findAll();
  final folders = await isar.folders.where().findAll();
  List<String> entryIds = entries.map((entry) => entry.id).toList();
  List<String> folderIds = folders.map((folder) => folder.id).toList();
  List<String> serverIds = [];
  List<int> entriesToRemove = [];
  List<int> foldersToRemove = [];

  // get all the ids from the server
  for (int i = 0; i < comicsArray.length; i++) {
    List<Map<String, dynamic>> comics = await comicsArray[i];
    for (int j = 0; j < comics.length; j++) {
      serverIds.add(comics[j]['id']);
    }
  }

  // check if the database has any ids that are not in the server
  for (int i = 0; i < entryIds.length; i++) {
    if (!serverIds.contains(entryIds[i])) {
      entriesToRemove.add(i);
    }
  }

  // check if the database has any ids that are not in the server
  for (int i = 0; i < folderIds.length; i++) {
    if (!serverIds.contains(folderIds[i])) {
      foldersToRemove.add(i);
    }
  }

  // remove the entries from the database
  await isar.writeTxn(() async {
    await isar.entrys.deleteAll(entriesToRemove);
    await isar.folders.deleteAll(foldersToRemove);
  });
}

Future<(List<Entry>, List<Folder>)> getServerCategoriesOffline() async {
  logger.d("getting server categories");

  bool hasComics = true;
  if (hasComics) {
    // get the comics and folders from the database
    final isar = Isar.getInstance();
    List<Entry> entries = await isar!.entrys
        .where()
        .filter()
        .group((q) {
          return q
              .typeEqualTo(EntryType.book)
              .or()
              .typeEqualTo(EntryType.comic)
              .or()
              .typeEqualTo(EntryType.audiobook);
        })
        .and()
        .downloadedEqualTo(true)
        .and()
        .isFavoritedEqualTo(false)
        .sortByTitle()
        .findAll();
    entries.addAll(await isar.entrys
        .where()
        .filter()
        .group((q) {
          return q
              .typeEqualTo(EntryType.book)
              .or()
              .typeEqualTo(EntryType.comic)
              .or()
              .typeEqualTo(EntryType.audiobook);
        })
        .and()
        .downloadedEqualTo(true)
        .and()
        .isFavoritedEqualTo(true)
        .sortByTitle()
        .findAll());

    List<Folder> folders = await isar.folders.where().findAll();
    logger.d("got entries and folders");
    logger.d(folders.toString());

    return (entries, folders);
  }
}
