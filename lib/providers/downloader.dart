// The purpose of this file is to allow the user to download the book/comic they have selected

import 'package:flutter/foundation.dart';

// database imports
import 'package:jellybook/models/entry.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// first we need to check if its already downloaded
Future<bool> checkDownloaded(String id) async {
  var box = Hive.box<Entry>('bookShelf');

  // get the box that stores the entries
  var entries = box.get('entries') as List<Entry>;

  // get the entry
  var entry = entries.firstWhere((element) => element.id == id);

  // print the entry
  debugPrint(entry.toString());

  // check if the entry is downloaded
  if (entry.downloaded) {
    return true;
  } else {
    return false;
  }
}
