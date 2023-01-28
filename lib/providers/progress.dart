// The purpose of this file is to save the progress of the user in a book/comic or get the progress of the user in a book/comic

// import 'package:hive_flutter/hive_flutter.dart';
import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
import 'package:jellybook/models/entry.dart';
import 'package:logger/logger.dart';

Future<void> saveProgress({
  required int page,
  required String comicId,
  List<String> pages = const [],
}) async {
  var logger = Logger();
  // open the database
  final isar = Isar.getInstance();

  // get the entry
  final entry = await isar!.entrys.where().idEqualTo(comicId).findFirst();

  // update the entry
  entry!.pageNum = page;

  // update the progress
  if (pages.isNotEmpty) {
    entry.progress = (page / pages.length) * 100;
  }

  // update the entry
  await isar.writeTxn(() async {
    await isar.entrys.put(entry);
  });

  logger.d("saved progress");
  logger.d("page num: ${entry.pageNum}");
}

Future<void> getProgress(String comicId) async {
  var logger = Logger();
  // open the database
  final isar = Isar.openSync([EntrySchema]);

  // get the entry
  final entry = await isar.entrys.where().idEqualTo(comicId).findFirst();

  // get the progress
  var progress = entry!.progress;

  // get the page number
  var pageNum = entry.pageNum;

  logger.d("progress: $progress");
  logger.d("page num: $pageNum");
}
