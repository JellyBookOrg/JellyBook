// The purpose of this file is to take the list of entries and create folders if their parentId is not one of the categories

import 'package:shared_preferences/shared_preferences.dart';

import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
import 'package:jellybook/models/folder.dart';
import 'package:jellybook/models/entry.dart';
import 'package:logger/logger.dart';

// This function takes the list of entries and creates folders if their parentId is not one of the categories
// It adds the folder to the list of folders in a isar box
class CreateFolders {
  static Future<void> createFolders(
      List<Entry> entries, List<String> categories) async {
    final isar = Isar.getInstance();
    var logger = Logger();

    final prefs = await SharedPreferences.getInstance();
    List<String> categories = prefs.getStringList('categories') ?? [];
    List<Folder> newFolders = [];
    entries.forEach((entry) {
      List<Entry> bookEntries =
          isar!.entrys.filter().parentIdEqualTo(entry.id).findAllSync();
      // get the ids of all bookEntries
      List<String> bookEntryIds = bookEntries.map((entry) => entry.id).toList();
      // write the ids to the folder
      // if the parentId is not in the categories list
      if (!categories.contains(entry.parentId)) {
        // create a new folder
        Folder newFolder = Folder(
          id: entry.id,
          name: entry.title,
          bookIds: bookEntryIds,
          image: entry.imagePath,
        );
        // add the folder to the list of folders
        newFolders.add(newFolder);
      }
    });
    for (int i = 0; i < newFolders.length; i++) {
      var folder =
          isar!.folders.filter().idEqualTo(newFolders[i].id).findFirstSync();
      if (folder != null) {
        final folderIsarId = folder.isarId;
        newFolders[i].isarId = folderIsarId;
        await isar.writeTxn(() async {
          await isar.folders.put(newFolders[i]);
        });
      } else {
        // if it doesn't, add the folder to the database
        await isar.writeTxn(() async {
          await isar.folders.put(newFolders[i]);
        });
      }
    }
  }

  static Future<void> getFolders(List<String> categories) async {
    final isar = Isar.getInstance();
    final entries = await isar!.entrys.filter().typeEqualTo('folder').findAll();
    await CreateFolders.createFolders(entries, categories);
  }
}
