// The purpose of this file is to delete a comic from the client
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
import 'package:jellybook/models/entry.dart';
import 'dart:io';
import 'package:jellybook/variables.dart';

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
  final isar = Isar.getInstance();
  final entry = await isar!.entrys.where().idEqualTo(id).findFirst();
  if (entry!.downloaded == true) {
    try {
      await File(entry.folderPath).delete(recursive: true);
    } catch (e) {
      logger.e(e.toString());
    }
  }
  if (entry.downloaded == true) {
    logger.d("Deleting file");
    logger.d(entry.folderPath);
    final String path = entry.folderPath;
    logger.d(path.toString());
    try {
      Directory(path).deleteSync(recursive: true);
    } catch (e) {
      logger.e("error deleting directory: $e");
    }

    logger.d("Deleted comic: " + entry.title);
    logger.d("Deleted comic path: " + entry.folderPath);
    entry.downloaded = false;
    entry.folderPath = "";
    entry.pageNum = 0;
    entry.progress = 0;
    await isar.writeTxn(() async {
      await isar.entrys.put(entry);
    });

    await isar.close();
  } else {
    logger.d("Comic not downloaded");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Comic not downloaded"),
      ),
    );
  }
}
