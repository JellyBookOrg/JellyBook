// The purpose of this file is to take the list of entries and create folders if their parentId is not one of the categories

import 'package:shared_preferences/shared_preferences.dart';

import 'package:isar/isar.dart';
import 'package:jellybook/models/folder.dart';
import 'package:jellybook/models/entry.dart';
import 'package:flutter/foundation.dart';

// This function takes the list of entries and creates folders if their parentId is not one of the categories
// It adds the folder to the list of folders in a isar box
class CreateFolders {
  static Future<void> createFolders(
      List<Entry> entries, List<String> categories) async {
    final isar = Isar.getInstance();

    final prefs = await SharedPreferences.getInstance();
    var categories = prefs.getString('categories') ?? '';
    List<Map<String, dynamic>> newFolders = [];
    // List<Folder> newFolders = [];
    List<String> newFolderIds = [];
    // for id in entries
    for (var entry in entries) {
      if (entry.type == 'Folder') {
        if (!categories.contains(entry.id)) {
          try {
            newFolders.add({
              'id': entry.id,
              'name': entry.title,
              'image': entry.imagePath,
              'bookIds': [],
            });
            newFolderIds.add(entry.id);
          } catch (e) {
            debugPrint("error: $e");
          }
        }
      }
    }

    // now add the entries to the folders
    for (var entry in entries) {
      if (newFolderIds.contains(entry.parentId)) {
        for (var folder in newFolders) {
          if (folder['id'] == entry.parentId) {
            // ensure that the book is not already in the folder
            if (!folder['bookIds'].contains(entry.id)) {
              folder['bookIds'].add(entry.id);
            }
          }
        }
      }
    }

    // now we have a list of folders, we need to add them to the isar box
    for (int i = 0; i < newFolders.length; i++) {
      if (await isar!.folders.filter().idEqualTo(newFolders[i]['id']).count() ==
          0) {
        try {
          await isar.writeTxn(() async {
            await isar.folders.put(Folder(
              id: newFolders[i]['id'],
              name: newFolders[i]['name'],
              image: newFolders[i]['image'],
              bookIds: newFolders[i]['bookIds'].cast<String>(),
            ));
          });
        } catch (e) {
          debugPrint("error: $e");
        }
      }
    }
  }

  static Future<List<Folder>> getFolders(
      List<Entry> entries, List<String> categories) async {
    final isar = Isar.getInstance();
    final folders2 = await isar!.folders.where().findAll();
    if (folders2.isEmpty) {
      await CreateFolders.createFolders(entries, categories);
    }
    // get a list of folders from the isar database
    debugPrint("folders: ${folders2.length}");
    return folders2;
  }
}
