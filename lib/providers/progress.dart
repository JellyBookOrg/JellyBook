// The purpose of this file is to save the progress of the user in a book/comic or get the progress of the user in a book/comic

import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:jellybook/models/entry.dart';

Future<void> saveProgress({
  required int page,
  required String comicId,
  List<String> pages = const [],
}) async {
  var db = Hive.box<Entry>('bookShelf');

  // get the box that stores the entries
  var entries = db.values.toList();

  // get the entry
  var entry = entries.firstWhere((element) => element.id == comicId);

  // update the entry
  entry.pageNum = page;

  // update the progress
  if (pages.isNotEmpty) {
    entry.progress = (page / pages.length) * 100;
  }

  // delete the old entry and add the new one
  entries.remove(entry);
  entries.add(entry);

  debugPrint("saved progress");
  debugPrint("page num: ${entry.pageNum}");
}

Future<void> getProgress(String comicId) async {
  var db = Hive.box<Entry>('bookShelf');

  // get the box that stores the entries
  var entries = db.get('entries') as List<Entry>;

  // get the entry
  var entry = entries.firstWhere((element) => element.id == comicId);

  // get the progress
  var progress = entry.progress;

  // get the page number
  var pageNum = entry.pageNum;

  debugPrint("progress: $progress");
  debugPrint("page num: $pageNum");
}
