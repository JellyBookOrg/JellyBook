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
Future<(List<Entry>, List<Folder>)> getServerCategories(context,
    {force = false}) async {
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
  List<Entry> booksTemp = await isar.entrys
      .filter()
      .not()
      .typeEqualTo(EntryType.folder)
      .and()
      .isFavoritedEqualTo(true)
      .sortByTitle()
      .findAll();
  booksTemp.addAll(await isar.entrys
      .filter()
      .not()
      .typeEqualTo(EntryType.folder)
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
  final data = response.data.items
      .where((element) => element.collectionType == 'books')
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
      Iterable<Entry> comicsTemp = await getComics(comicsIds[i], etag);
      // comics.addAll(comicsTemp);
    }
    comics = await isar.entrys
        .filter()
        .not()
        .typeEqualTo(EntryType.folder)
        .sortByTitle()
        .findAll();
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

    return (comics, folders);
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

Future<(List<Entry>, List<Folder>)> getServerCategoriesOffline(context) async {
  logger.d("getting server categories");
  // final p_info.PackageInfo packageInfo =
  //     await p_info.PackageInfo.fromPlatform();
  // final prefs = await SharedPreferences.getInstance();
  // final token = prefs.getString('accessToken') ?? "";
  // final url = prefs.getString('server') ?? "";
  // final userId = prefs.getString('UserId') ?? "";
  // final client = prefs.getString('client') ?? "JellyBook";
  // final device = prefs.getString('device') ?? "";
  // final deviceId = prefs.getString('deviceId') ?? "";
  // final version = prefs.getString('version') ?? packageInfo.version;
  logger.d("got prefs");

  bool hasComics = true;
  if (hasComics) {
    // get the comics and folders from the database
    final isar = Isar.getInstance();
    List<Entry> unlikedEntries = await isar!.entrys
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
        .findAll();

    List<Entry> likedEntries = await isar!.entrys
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
        .findAll();
    // sort by title
    likedEntries.sort((a, b) => a.title.compareTo(b.title));
    unlikedEntries.sort((a, b) => a.title.compareTo(b.title));

    List<Entry> entries = likedEntries + unlikedEntries;

    List<Folder> folders = await isar.folders.where().findAll();
    logger.d("got entries and folders");
    logger.d(folders.toString());

    return (entries, folders);
  }
}
