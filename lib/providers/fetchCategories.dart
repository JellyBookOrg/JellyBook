// The purpose of this file is to fetch the categories from the database

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:openapi/openapi.dart';
import 'dart:convert';
import 'package:jellybook/providers/fetchBooks.dart';
import 'package:flutter/material.dart';
import 'package:jellybook/providers/folderProvider.dart';
import 'package:jellybook/models/entry.dart';
import 'package:jellybook/models/folder.dart';
import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
import 'package:package_info_plus/package_info_plus.dart' as p_info;
import 'package:jellybook/providers/pair.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jellybook/variables.dart';

// have optional perameter to have the function return the list of folders
Future<Pair> getServerCategories(context) async {
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

  // turn all the previous logger.d's into a single logger.d with multiple lines
  logger.i(
      "accessToken: $token\nserver: $url\nUserId: $userId\nclient: $client\ndevice: $device\ndeviceId: $deviceId\nversion: $version");

  logger.d("got prefs");
  Map<String, String> headers =
      getHeaders(url, client, device, deviceId, version, token);
  final api = Openapi(basePathOverride: url).getUserViewsApi();
  var response;
  try {
    response = await api.getUserViews(
        userId: userId, headers: headers, includeHidden: true);
    // logger.d(response);
  } catch (e) {
    logger.e(e);
  }

  logger.d("got response");
  logger.d(response.statusCode.toString());
  final data = response.data.items.where((element) => element.collectionType == 'books').toList();

  bool hasComics = true;
  if (hasComics) {
    String comicsId = '';
    String etag = '';
    List<String> categories = [];
    // add all data['Items'] to categories
    data.forEach((element) {
      categories.add(element.name);
    });

    List<Future<List<Map<String, dynamic>>>> comicsArray = [];
    List<String> comicsIds = [];
    logger.d("selected: " + categories.toString());
    data.forEach((element) {
        comicsId = element.id;
        comicsIds.add(comicsId);
        etag = element.etag;
        comicsArray.add(getComics(comicsId, etag));
    });

    List<Map<String, dynamic>> comics = [];
    Stream<Map<String, dynamic>> comicsStream = Stream.fromFutures(comicsArray)
        .asyncMap((comicsList) => comicsList)
        .expand((comicsList) => comicsList);

    await for (Map<String, dynamic> comic in comicsStream) {
      // logger.i("adding comic '${comic['name']}' to comics list");
      comics.add(comic);
    }

    prefs.setStringList('comicsIds', comicsIds);

    List<Map<String, dynamic>> likedComics = [];
    List<Map<String, dynamic>> unlikedComics = [];
    logger.d(comics.length.toString());
    for (int i = 0; i < comics.length; i++) {
      if (comics[i]['isFavorite'].toString() == 'true') {
        likedComics.add(comics[i]);
        logger.d("added comic '${comics[i]['name']}' to likedComics");
      } else {
        unlikedComics.add(comics[i]);
      }
    }

    comics = likedComics + unlikedComics;

    final isar = Isar.getInstance();
    List<String> categoriesList = [];
    for (int i = 0; i < data.length; i++) {
      categoriesList.add(data[i].name);
    }
    logger.i("categoriesList: $categoriesList");
    prefs.setStringList('categories', categoriesList);
    // List<Entry> entries = await isar!.entrys.where().findAll();

    await CreateFolders.getFolders(categoriesList);
    List<Folder> folders = await isar!.folders.where().findAll();

    // turn into a map
    List<Map<String, dynamic>> folderMap = [];
    for (int i = 0; i < folders.length; i++) {
      folderMap.add({
        'name': folders[i].name,
        'id': folders[i].id,
        'entries': folders[i].bookIds,
        'image': folders[i].image,
      });
    }

    logger.d("folderMap: " + folderMap.toString());
    var folderMap2 = await compareFolders(folderMap);
    logger.d("folderMap2: " + folderMap2.toString());

    return Pair(comics, folderMap2);
  }
}

// check to see if a folder isn't a subfolder of another folder
Future<List<Map<String, dynamic>>> compareFolders(
    List<Map<String, dynamic>> folders) async {
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

Future<List<String>> chooseCategories(List<String> categories, context) async {
  List<String> selected = [];
  List<String> wantedCategories = [];

  // pop up a dialog to choose categories
  // use stateful builder to rebuild the dialog when the list changes

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text("Choose Categories"),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.8,
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return CheckboxListTile(
                    title: Text(categories[index]),
                    value: selected.contains(categories[index]),
                    onChanged: (bool? value) {
                      if (value == true) {
                        wantedCategories.add(categories[index]);
                      } else {
                        wantedCategories.remove(categories[index]);
                      }
                      setState(() {});
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop(wantedCategories);
                },
              ),
            ],
          );
        },
      );
    },
  );
  return wantedCategories;
}

Future<Pair> getServerCategoriesOffline(context) async {
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
  logger.d("got prefs");

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
              .typeEqualTo(EntryType.comic);
        })
        .and()
        .downloadedEqualTo(true)
        .findAll();
    List<Folder> folders = await isar.folders.where().findAll();
    logger.d("got entries and folders");
    logger.d(folders.toString());

    // turn into a map
    List<Map<String, dynamic>> folderMap = [];
    for (int i = 0; i < folders.length; i++) {
      // go through each categories list of entries and see if it is downloaded, if it is, add it to the list, if not, don't
      List<String> entriesList = [];
      for (int j = 0; j < folders[i].bookIds.length; j++) {
        if (entries
            .map((entry) => entry.id)
            .toList()
            .contains(folders[i].bookIds[j])) {
          entriesList.add(folders[i].bookIds[j]);
        }
      }
      if (entriesList.isNotEmpty) {
        folderMap.add({
          "id": folders[i].id,
          "name": folders[i].name,
          "entries": entriesList,
          "image": folders[i].image,
        });
      }
    }

    List<Map<String, dynamic>> comics = [];
    entries.forEach((book) {
      logger.d(book.title);
      comics.add({
        'id': book.id,
        'name': book.title,
        // 'imagePath':
        //     '$url/Items/${book.id}/Images/Primary?&quality=90&Tag=${book.imageTags!['Primary']}',
        // // if the imageTags!['Primary'] is null then we use 'Asset' instead
        'imagePath': book.imagePath,
        'releaseDate': book.releaseDate,
        'path': book.path,
        'description': book.description,
        'url': book.url,
        'communityRating': book.rating,
        if (book.type == EntryType.comic || book.type == EntryType.book)
          'type': book.path.toString().split('.').last.toLowerCase(),
        'tags': book.tags,
        'parent': book.parentId,
        'isFavorite': book.isFavorited,
        'isDownloaded': book.downloaded,
      });
    });

    // organize the comics first by if liked and then alphabetically
    comics.sort((a, b) {
      if (a['isFavorite'] == b['isFavorite']) {
        return a['name'].compareTo(b['name']);
      } else if (a['isFavorite'] == true) {
        return -1;
      } else {
        return 1;
      }
    });

    return Pair(comics, folderMap);
  }
}
