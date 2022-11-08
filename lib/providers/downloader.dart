// The purpose of this file is to allow the user to download the book/comic they have selected

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as Http;
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:jellybook/providers/fileNameFromTitle.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_utils/file_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// database imports
import 'package:jellybook/models/entry.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// first we need to check if its already downloaded
Future<bool> checkDownloaded(String id) async {
  // get the path to the database
  String path = await _getPath();

  // open the hive database
  var box = await Hive.openBox('bookShelf', path: path);

  // get the box that stores the entries
  var entries = box.get('entries') as List<Entry>;

  // get the entry
  var entry = entries.firstWhere((element) => element.id == int.parse(id));

  // check if the entry is downloaded
  if (entry.downloaded) {
    // close the database
    await box.close();

    // return true
    return true;
  } else {
    // close the database
    await box.close();

    // return false
    return false;
  }
}

// get the path to the database
Future<String> _getPath() async {
  // get the path to the documents directory
  Directory documentsDirectory = await getApplicationDocumentsDirectory();

  // get the path to the database
  String path = documentsDirectory.path + "/jellybook.db";

  // return the path
  return path;
}
