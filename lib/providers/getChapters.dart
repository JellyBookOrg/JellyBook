// The purpose of this file is to get the chapters from a book

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as Http;
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<List<String>> getChapters(String folderName) async {
  // final prefs = await SharedPreferences.getInstance();
  List<String> chapters = [];
  // Directory comicsFolder = await getApplicationDocumentsDirectory();
  // folderName = prefs.getString(title) ?? "";
  // String comicFolder = prefs.getString(title) ?? "";
  print("folder name: $folderName");
  String path = folderName;
  List<FileSystemEntity> files = Directory(path).listSync();
  print(files);
  // what we want to do is recursively go through the folder and get all the last directories that dont contain any other directories
  // then we want to add them to the chapters list
  // max depth of 3
  // the way we will do the checking is by checkign to see if the file is ends with a jpg, jpeg, png...
  var formats = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'tiff'];
  for (var file in files) {
    if (file.path.endsWith(formats[0]) ||
        file.path.endsWith(formats[1]) ||
        file.path.endsWith(formats[2]) ||
        file.path.endsWith(formats[3]) ||
        file.path.endsWith(formats[4]) ||
        file.path.endsWith(formats[5]) ||
        file.path.endsWith(formats[6])) {
      print("file: $file");
      if (!chapters.contains(file.parent.path)) {
        chapters.add(file.parent.path);
      }
    } else {
      print("file: $file");
      List<FileSystemEntity> files2 = Directory(file.path).listSync();
      for (var file2 in files2) {
        if (file2.path.endsWith(formats[0]) ||
            file2.path.endsWith(formats[1]) ||
            file2.path.endsWith(formats[2]) ||
            file2.path.endsWith(formats[3]) ||
            file2.path.endsWith(formats[4]) ||
            file2.path.endsWith(formats[5]) ||
            file2.path.endsWith(formats[6])) {
          print("file2: $file2");
          if (!chapters.contains(file2.parent.path)) {
            chapters.add(file2.parent.path);
          }
        } else {
          print("file2: $file2");
          List<FileSystemEntity> files3 = Directory(file2.path).listSync();
          for (var file3 in files3) {
            if (file3.path.endsWith(formats[0]) ||
                file3.path.endsWith(formats[1]) ||
                file3.path.endsWith(formats[2]) ||
                file3.path.endsWith(formats[3]) ||
                file3.path.endsWith(formats[4]) ||
                file3.path.endsWith(formats[5]) ||
                file3.path.endsWith(formats[6])) {
              print("file3: $file3");
              if (!chapters.contains(file3.parent.path)) {
                chapters.add(file3.parent.path);
              }
            } else {
              print("file3: $file3");
              List<FileSystemEntity> files4 = Directory(file3.path).listSync();
              for (var file4 in files4) {
                if (file4.path.endsWith(formats[0]) ||
                    file4.path.endsWith(formats[1]) ||
                    file4.path.endsWith(formats[2]) ||
                    file4.path.endsWith(formats[3]) ||
                    file4.path.endsWith(formats[4]) ||
                    file4.path.endsWith(formats[5]) ||
                    file4.path.endsWith(formats[6])) {
                  print("file4: $file4");
                  if (!chapters.contains(file4.parent.path)) {
                    chapters.add(file4.parent.path);
                  }
                } else {
                  print("file4: $file4");
                  List<FileSystemEntity> files5 =
                      Directory(file4.path).listSync();
                  for (var file5 in files5) {
                    if (file5.path.endsWith(formats[0]) ||
                        file5.path.endsWith(formats[1]) ||
                        file5.path.endsWith(formats[2]) ||
                        file5.path.endsWith(formats[3]) ||
                        file5.path.endsWith(formats[4]) ||
                        file5.path.endsWith(formats[5]) ||
                        file5.path.endsWith(formats[6])) {
                      print("file5: $file5");
                      if (!chapters.contains(file5.parent.path)) {
                        chapters.add(file5.parent.path + "/");
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  print("Chapters:");
  print(chapters);
  return chapters;
}
