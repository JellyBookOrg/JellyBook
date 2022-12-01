// The purpose of this file is to allow the user to download the book/comic they have selected

import 'package:flutter/foundation.dart';

// database imports
import 'package:jellybook/models/entry.dart';
import 'package:isar/isar.dart';

// first we need to check if its already downloaded
Future<bool> checkDownloaded(String id) async {
  // open the database
  final isar = Isar.getInstance();

  // get the entry
  final entry = await isar!.entrys.where().idEqualTo(id).findFirst();

  // get the entry

  // print the entry
  debugPrint(entry.toString());

  // check if the entry is downloaded
  return entry?.downloaded ?? false;
}
