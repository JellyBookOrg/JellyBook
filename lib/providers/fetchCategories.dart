// The purpose of this file is to fetch the categories from the database

import 'package:shared_preferences/shared_preferences.dart';
import 'package:openapi/openapi.dart';
import 'dart:convert';
import 'package:jellybook/providers/fetchBooks.dart';
import 'package:flutter/material.dart';
import 'package:jellybook/providers/folderProvider.dart';
import 'package:jellybook/models/entry.dart';
import 'package:jellybook/models/folder.dart';
import 'package:isar/isar.dart';
import 'package:package_info_plus/package_info_plus.dart' as p_info;
import 'package:logger/logger.dart';
import 'package:jellybook/providers/pair.dart';

// have optional perameter to have the function return the list of folders
Future<Pair> getServerCategories(context) async {
  var logger = Logger();
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
  final data = response.data.items;

  bool hasComics = true;
  if (hasComics) {
    String comicsId = '';
    String etag = '';
    List<String> categories = [];
    // add all data['Items'] to categories
    data.forEach((element) {
      categories.add(element.name);
    });

    categories.remove('Shows');
    categories.remove('Movies');
    categories.remove('Music');
    categories.remove('Collections');
    categories.remove('shows');
    categories.remove('movies');
    categories.remove('music');
    categories.remove('collections');

    List<String> selected = [];
    List<String> includedAutomatically = [
      'comics',
      'book',
      'comic book',
      'book',
      'books',
      'comic books',
      'manga',
      'mangas',
      'comics & graphic novels',
      'graphic novels',
      'graphic novel',
      'novels',
      'novel',
      'ebook',
      'ebooks',
    ];
    for (var i = 0; i < categories.length; i++) {
      if (includedAutomatically.contains(categories[i].toLowerCase())) {
        selected.add(categories[i]);
      }
    }
    List<Future<List<Map<String, dynamic>>>> comicsArray = [];
    List<String> comicsIds = [];
    logger.d("selected: " + selected.toString());
    data.forEach((element) {
      if (selected.contains(element.name)) {
        comicsId = element.id;
        comicsIds.add(comicsId);
        etag = element.etag;
        comicsArray.add(getComics(comicsId, etag));
      }
    });

    List<Map<String, dynamic>> comics = [];
    Stream<Map<String, dynamic>> comicsStream = Stream.fromFutures(comicsArray)
        .asyncMap((comicsList) => comicsList)
        .expand((comicsList) => comicsList);
    // once all the comics are fetched, combine them into one list
    // for (int i = 0; i < comicsArray.length; i++) {
    //   comics.addAll(await comicsArray[i]);
    // }

    await for (Map<String, dynamic> comic in comicsStream) {
      // logger.i("adding comic '${comic['name']}' to comics list");
      comics.add(comic);
    }

    prefs.setStringList('comicsIds', comicsIds);

    List<Map<String, dynamic>> likedComics = [];
    List<Map<String, dynamic>> unlikedComics = [];
    logger.d(comics.length.toString());
    for (int i = 0; i < comics.length; i++) {
      if (comics[i]['isFavorited'].toString() == 'true') {
        likedComics.add(comics[i]);
        logger.d("added comic to likedComics");
      } else {
        unlikedComics.add(comics[i]);
      }
    }

    comics = likedComics + unlikedComics;

    final isar = Isar.getInstance();
    List<String> categoriesList = [];
    for (int i = 0; i < selected.length; i++) {
      categoriesList.add(selected[i]);
    }
    logger.i("categoriesList: $categoriesList");
    prefs.setStringList('categories', categoriesList);
    List<Entry> entries = await isar!.entrys.where().findAll();

    await CreateFolders.getFolders(categoriesList);
    List<Folder> folders = await isar.folders.where().findAll();
    folders.forEach((element) {
      logger.d("folder name: " + element.name);
    });
    logger.d("folderSize: " + folders.length.toString());
    // await CreateFolders.getFolders(entries, categoriesList);

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
    // await removeEntriesFromDatabase(comicsArray);

    return Pair(comics, folderMap);
  } else {
    logger.e('No comics found');
  }
  return Pair([], []);
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
  var logger = Logger();

  // pop up a dialog to choose categories
  // use stateful builder to rebuild the dialog when the list changes
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Choose Categories'),
            content: Container(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(categories[index]),
                    value: selected.contains(categories[index]),
                    onChanged: (bool? value) {
                      if (value == true &&
                          !selected.contains(categories[index])) {
                        selected.add(categories[index]);
                      } else if (value == false &&
                          selected.contains(categories[index])) {
                        selected.remove(categories[index]);
                      }
                      setState(() {});
                    },
                  );
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Done'),
                onPressed: () {
                  if (selected.isNotEmpty) {
                    Navigator.of(context).pop();
                  } else {
                    logger.e("No categories selected");
                    // snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No categories selected'),
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
  return selected;
}
