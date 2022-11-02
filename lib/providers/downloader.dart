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

// first we need to check if its already downloaded
Future<bool> checkDownloaded(String title) async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  var filePath = await getApplicationDocumentsDirectory();
  String title2 = await fileNameFromTitle(title);
  // check if the file exists in the directory
  var file = File(filePath.path + "/$title2");
  if (await file.exists()) {
    return true;
  } else {
    return false;
  }
}

// this function will create a list of all the pages in the book/comic
Future<List<String>> createPageList(List<String> chapters) async {
  List<String> pages = [];
  print("chapters: $chapters");
  var formats = [".jpg", ".jpeg", ".png", ".gif", ".webp", ".bmp", ".tiff"];
  List<String> pageFiles = [];
  for (var chapter in chapters) {
    List<FileSystemEntity> files = Directory(chapter).listSync();
    for (var file in files) {
      if (file.path.endsWith(formats[0]) ||
          file.path.endsWith(formats[1]) ||
          file.path.endsWith(formats[2]) ||
          file.path.endsWith(formats[3]) ||
          file.path.endsWith(formats[4]) ||
          file.path.endsWith(formats[5]) ||
          file.path.endsWith(formats[6])) {
        pageFiles.add(file.path);
      }
    }
  }
  pageFiles.sort();
  for (var page in pageFiles) {
    pages.add(page);
  }
  return pages;
}
