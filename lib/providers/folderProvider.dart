// The purpose of this file is to take the list of entries and create folders if their parentId is not one of the categories

import 'package:shared_preferences/shared_preferences.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:jellybook/models/folder.dart';
import 'package:jellybook/models/entry.dart';
import 'package:flutter/foundation.dart';

// This function takes the list of entries and creates folders if their parentId is not one of the categories
// It adds the folder to the list of folders in a hive box
class CreateFolders {
  static Future<void> createFolders(
      List<Entry> entries, List<String> categories) async {
    // Get the list of folders from the hive box
    // debugPrint("creating folders");
    var box = Hive.box<Folder>('folders');
    // var foldersBox = Hive.box<Folder>('folders');

    final prefs = await SharedPreferences.getInstance();
    var categories = prefs.getString('categories') ?? '';
    // debugPrint("categories: $categories");

    // new plan, create the list of folders first, then add the entries to the folders

    // instead of having a List<Folder> we will have a Map<String, dynamic> and convert it to a List<Folder> at the end
    List<Map<String, dynamic>> newFolders = [];
    // List<Folder> newFolders = [];
    List<String> newFolderIds = [];
    for (int i = 0; i < entries.length; i++) {
      // debugPrint('Entry: ${entries[i].type}');
      if (entries[i].type == 'folder') {
        if (!categories.contains(entries[i].id)) {
          // if the folder is not in the list of categories then add it to the list of folders
          try {
            // add the folder to the list of folders
            newFolders.add({
              'id': entries[i].id,
              'name': entries[i].title,
              'image': entries[i].imagePath,
              'bookIds': [],
            });
            // newFolders.add(Folder(
            //   id: entries[i].id,
            //   name: entries[i].title,
            //   image: entries[i].imagePath,
            //   bookIds: [],
            // ));
            newFolderIds.add(entries[i].id);
          } catch (e) {
            debugPrint("error creating folder: $e");
          }
        }
      }
    }

    // now add the entries to the folders
    for (int i = 0; i < entries.length; i++) {
      if (entries[i].type == 'book' || entries[i].type == 'comic') {
        if (newFolderIds.contains(entries[i].parentId)) {
          int index = newFolderIds.indexOf(entries[i].parentId);
          newFolders[index]['bookIds'].add(entries[i].id);
        }
      }
    }

    // now we debugPrint the new folders
    debugPrint("newFolders: ${newFolders.length}");
    for (int i = 0; i < newFolders.length; i++) {
      debugPrint("newFolder: ${newFolders[i]['name']}");
      debugPrint("newFolder Id: ${newFolders[i]['id']}");
      debugPrint("newFolder: ${newFolders[i]['bookIds']}");
    }

    // now we have a list of folders, we need to add them to the hive box
    for (int i = 0; i < newFolders.length; i++) {
      // wait until everything is done before adding the folders to the hive box
      await box.add(Folder(
        id: newFolders[i]['id'],
        name: newFolders[i]['name'],
        image: newFolders[i]['image'],
        bookIds: newFolders[i]['bookIds'].cast<String>(),
      ));
    }
  }

  // fetch the list of folders from the hive box
  static Future<List<Folder>> getFolders(
      List<Entry> entries, List<String> categories) async {
    // if (box.isNotEmpty) {
    //   var folders = box.values.toList();
    //   return folders;
    // } else {
    var folders = await CreateFolders.createFolders(entries, categories);
    // if folders is finished then return the list of folders
    var foldersBox = Hive.box<Folder>('folders');
    var foldersList = foldersBox.values.toList();
    debugPrint("foldersList: ${foldersList.length}");
    return foldersList;
  }
}
