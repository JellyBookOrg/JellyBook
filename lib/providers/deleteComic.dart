// The purpose of this file is to delete a comic from the client
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:jellybook/models/entry.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import 'package:jellybook/variables.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> deleteComic(String id, context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)?.delete ?? "Delete Comic"),
        content: Text(AppLocalizations.of(context)?.deleteConfirm ??
            "Are you sure you want to delete this comic?"),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context)?.cancel ?? "Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)?.delete ?? "Delete"),
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
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool useSentry = prefs.getBool('useSentry') ?? false;
  if (entry!.downloaded) {
    try {
      await File(entry.folderPath).delete(recursive: true);
    } catch (e, s) {
      if (useSentry) await Sentry.captureException(e, stackTrace: s);
      logger.e(e.toString());
    }
  }
  if (entry.downloaded) {
    logger.d("Deleting file");
    logger.d(entry.folderPath);
    final String path = entry.folderPath;
    logger.d(path.toString());
    try {
      Directory(path).deleteSync(recursive: true);
    } catch (e, s) {
      if (useSentry) await Sentry.captureException(e, stackTrace: s);
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
  } else {
    logger.d("Comic not downloaded");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)?.noContent ?? "Comic not downloaded",
        ),
      ),
    );
  }
}
