// The purpose of this file is to delete a comic from the client
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:jellybook/models/entry.dart';
import 'dart:io';

Future<void> deleteComic(String id, context) async {
  bool delete = false;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Delete Comic"),
        content: Text("Are you sure you want to delete this comic?"),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("Delete"),
            onPressed: () {
              confirmedDelete(id, context);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> confirmedDelete(String id, context) async {
  // get the entry from the database
  final isar = Isar.getInstance();
  // if download is true, delete the file
  final entry = await isar!.entrys.where().idEqualTo(id).findFirst();
  if (entry!.downloaded == true) {
    try {
      await File(entry.folderPath).delete(recursive: true);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  if (entry.downloaded == true) {
    debugPrint("Deleting file");
    debugPrint(entry.folderPath);
    final String path = entry.folderPath;
    debugPrint(path.toString());
    try {
      Directory(path).deleteSync(recursive: true);
    } catch (e) {
      debugPrint("error deleting directory: $e");
    }

    debugPrint("Deleted comic: " + entry.title);
    debugPrint("Deleted comic path: " + entry.folderPath);
    entry.downloaded = false;
    entry.folderPath = "";
    entry.pageNum = 0;
    entry.progress = 0;
    await isar.writeTxn(() async {
      await isar.entrys.put(entry);
    });

    await isar.close();
  } else {
    debugPrint("Comic not downloaded");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Comic not downloaded"),
      ),
    );
  }
}
