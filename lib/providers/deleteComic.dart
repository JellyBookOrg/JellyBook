// The purpose of this file is to delete a comic from the client
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
  final box = Hive.box<Entry>('bookShelf');
  // if download is true, delete the file
  var entries = box.values.where((element) => element.id == id).toList();
  var entry = entries[0];
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
    entry.save();
  } else {
    debugPrint("Comic not downloaded");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Comic not downloaded"),
      ),
    );
  }
}
