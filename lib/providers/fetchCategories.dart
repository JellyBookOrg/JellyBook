// The purpose of this file is to fetch the categories from the database

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as Http;
import 'dart:convert';
import 'package:jellybook/providers/fetchBooks.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jellybook/providers/folderProvider.dart';
import 'package:jellybook/models/entry.dart';
import 'package:jellybook/models/folder.dart';
import 'package:hive_flutter/hive_flutter.dart';

// have optional perameter to have the function return the list of folders
Future<List<Map<String, dynamic>>> getServerCategories(context,
    {bool returnFolders = false}) async {
  debugPrint("getting server categories");
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('accessToken') ?? "";
  final url = prefs.getString('server') ?? "";
  final userId = prefs.getString('UserId') ?? "";
  final client = prefs.getString('client') ?? "JellyBook";
  final device = prefs.getString('device') ?? "";
  final deviceId = prefs.getString('deviceId') ?? "";
  final version = prefs.getString('version') ?? "1.0.7";
  debugPrint("got prefs");
  Map<String, String> headers =
      getHeaders(url, client, device, deviceId, version, token);
  final response = await Http.get(
    Uri.parse(url + "/Users/" + userId + "/Views"),
    headers: headers,
  );

  debugPrint("got response");
  debugPrint(response.statusCode.toString());
  debugPrint(response.body);
  final data = await json.decode(response.body);

  bool hasComics = true;
  if (hasComics) {
    String comicsId = '';
    String etag = '';
    List<String> categories = [];
    // add all data['Items'] to categories
    data['Items'].forEach((item) {
      categories.add(item['Name']);
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
    if (categories.contains('Comics')) {
      selected.add('Comics');
    } else if (categories.contains('comics')) {
      selected.add('comics');
    } else if (categories.contains('Books')) {
      selected.add('Books');
    } else if (categories.contains('books')) {
      selected.add('books');
    } else {
      hasComics = false;
    }
    // get length of prefs.getStringList('categories') (its a List<dynamic>?)
    // List<String> selected = prefs.getStringList('categories') ?? ['Error'];
    // if (selected[0] == 'Error') {
    //   selected = await chooseCategories(categories, context);
    //   debugPrint("selected: $selected");
    //   prefs.setStringList('categories', selected);
    // }
    // if (prefs.getStringList('categories')!.length == 0) {
    //   selected = await chooseCategories(categories, context);
    //   prefs.setStringList('categories', selected);
    // } else {
    //   selected = prefs.getStringList('categories')!;
    // }
    List<Future<List<Map<String, dynamic>>>> comicsArray = [];
    List<String> comicsIds = [];
    debugPrint("selected: " + selected.toString());
    for (int i = 0; i < data['Items'].length; i++) {
      if (selected.contains(data['Items'][i]['Name'])) {
        comicsId = data['Items'][i]['Id'];
        comicsIds.add(comicsId);
        etag = data['Items'][i]['Etag'];
        comicsArray.add(getComics(comicsId, etag));
      }
    }

    // once all the comics are fetched, combine them into one list
    List<Map<String, dynamic>> comics = [];
    for (int i = 0; i < comicsArray.length; i++) {
      // comicsArray[i].then((value) {
      //   comics.addAll(value);
      // });
      comics.addAll(await comicsArray[i]);
    }

    prefs.setStringList('comicsIds', comicsIds);

    if (returnFolders) {
      List<String> categoriesList = [];
      for (int i = 0; i < selected.length; i++) {
        categoriesList.add(selected[i]);
      }

      var boxEntries = Hive.box<Entry>('bookShelf');
      List<Entry> entriesList = boxEntries.values.toList();
      debugPrint("got entries list");
      var boxFolders = Hive.box<Folder>('folders');
      // List<Folder> foldersList = boxFolders.values.toList();
      // List<Folder> folders = await boxFolders.values.toList();
      List<Folder> folders =
          await CreateFolders.getFolders(entriesList, categoriesList);

      debugPrint("created folders");
      // convert folders to maps<strings, dynamic>
      List<Map<String, dynamic>> makeFolders() {
        List<Map<String, dynamic>> foldersMap = [];
        folders.forEach((folder) {
          foldersMap.add(
            {
              'id': folder.id,
              'name': folder.name,
              'image': folder.image,
              'bookIds': folder.bookIds,
            },
          );
        });
        return foldersMap;
      }

      List<Map<String, dynamic>> foldersMap = makeFolders();
      debugPrint("converted folders to maps");

      // wait for the folders to be created

      // return the list of folders
      return foldersMap;
    } else {
      return comics;
    }
    debugPrint("Returning comics");
    return comics;
  } else {
    debugPrint('No comics found');
  }
  return [];
}

Future<List<String>> chooseCategories(List<String> categories, context) async {
  List<String> selected = [];

  debugPrint("Getting categories");

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
                        // debugPrint(selected.toString() + " added");
                      } else if (value == false &&
                          selected.contains(categories[index])) {
                        selected.remove(categories[index]);
                        // debugPrint(selected.toString() + " removed");
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
                  if (selected != null && selected.isNotEmpty) {
                    Navigator.of(context).pop();
                  } else {
                    debugPrint("No categories selected");
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
