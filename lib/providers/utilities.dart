// The purpose for this file is to have a class that contains functions that are used in multiple files

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jellybook/models/entry.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:file_utils/file_utils.dart';

Future<String> getPath() async {
  // get the path to the documents directory
  Directory documentsDirectory = await getApplicationDocumentsDirectory();

  // get the path to the database
  String path = documentsDirectory.path + "/jellybook.db";

  return path;
}
