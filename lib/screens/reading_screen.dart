// The purpose of this file is to allow the user to read the book/comic they have downloaded

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:file_utils/file_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:turn_page_transition/turn_page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:jellybook/screens/downloader_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadingScreen extends StatefulWidget {
  final String title;
  final String comicId;

  ReadingScreen({
    required this.title,
    required this.comicId,
  });

  _ReadingScreenState createState() => _ReadingScreenState(
        title: title,
        comicId: comicId,
      );
}

class _ReadingScreenState extends State<ReadingScreen> {
  final String title;
  final String comicId;
  List<String> chapters = [];
  String folderName = '';
  String path = '';
  int pageNums = 0;
  int pageNum = 0;
  double progress = 0.0;

  _ReadingScreenState({
    required this.title,
    required this.comicId,
  });

  Future<void> getChapters() async {
    Directory comicsFolder = await getApplicationDocumentsDirectory();
    var prefs = await SharedPreferences.getInstance();
    folderName = prefs.getString(title) ?? "";
    print("folder name: $folderName");
    path = folderName;
    List<FileSystemEntity> files = Directory(path).listSync();
    print(files);
    if (files[0].path.contains(".")) {
      for (var file in files) {
        String chapterName = file.path.split("/").last;
        chapters.add(chapterName);
      }
    } else {
      for (var file in files) {
        String chapterName = file.path.split("/").last;
        chapters.add(chapterName);
      }
    }
    print("Chapters:");
    print(chapters);
  }

  Future<void> checkDownloaded() async {
    var prefs = await SharedPreferences.getInstance();
    folderName = prefs.getString(title) ?? "";
    if (folderName == "") {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) =>
              DownloadScreen(
            title: title,
            comicId: comicId,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    }
  }

  Future<void> saveProgress(int page) async {
    var prefs = await SharedPreferences.getInstance();
    double progress = page / pageNums;
    prefs.setDouble(comicId + "_progress", progress);
    prefs.setInt(comicId + "_pageNum", page);
    print("saved progress");
    print("page num: $page");
  }

  Future<void> getProgress() async {
    var prefs = await SharedPreferences.getInstance();
    pageNum = await prefs.getInt(comicId + "_pageNum") ?? 0;
    progress = await prefs.getDouble(comicId + "_progress") ?? 0.0;
    print("page returned: $pageNum");
  }

  Future<String> fileNameFromTitle(String title) async {
    String fileName = title.replaceAll(' ', '_');
    fileName = fileName.replaceAll('/', '_');
    fileName = fileName.replaceAll(':', '_');
    fileName = fileName.replaceAll('?', '_');
    fileName = fileName.replaceAll('*', '_');
    fileName = fileName.replaceAll('"', '_');
    fileName = fileName.replaceAll('<', '_');
    fileName = fileName.replaceAll('>', '_');
    fileName = fileName.replaceAll('|', '_');
    fileName = fileName.replaceAll('!', '_');
    fileName = fileName.replaceAll(',', '_');
    fileName = fileName.replaceAll('\'', '');
    fileName = fileName.replaceAll('’', '');
    fileName = fileName.replaceAll('‘', '');
    fileName = fileName.replaceAll('“', '');
    fileName = fileName.replaceAll('”', '');
    fileName = fileName.replaceAll('"', '');
    fileName = fileName.replaceAll(RegExp(r'[^\x00-\x7F]+'), '');
    return fileName;
  }

  List<String> pages = [];
  Future<void> createPageList() async {
    print("folder name: $folderName");
    List<FileSystemEntity> files = Directory(path).listSync();
    print(files);
    bool isFolder = false;
    for (var file in files) {
      if (await Directory(file.path).exists()) {
        isFolder = true;
      }
    }

    if (!isFolder) {
      for (var file in files) {
        String chapterName = file.path.split("/").last;
        pages.add(chapterName);
      }
    } else {
      List<String> pageFiles = [];
      for (var file in files) {
        String chapterName = file.path.split("/").last;
        pageFiles = Directory(path + '/' + chapterName)
            .listSync()
            .map((e) => e.path.split("/").last)
            .toList();
        pageFiles.sort();
        for (var page in pageFiles) {
          pages.add(chapterName + '/' + page);
          pageNums++;
        }
      }
    }
  }

  void initState() {
    super.initState();
    checkDownloaded();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getChapters(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: Text(title),
            ),
            body: FutureBuilder(
              future: getProgress(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return FutureBuilder(
                    future: createPageList(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Column(
                          children: [
                            Expanded(
                              child: PageView.builder(
                                itemCount: pages.length,
                                controller: PageController(
                                  initialPage: pageNum,
                                ),
                                itemBuilder: (context, index) {
                                  return InteractiveViewer(
                                    child: Image.file(
                                      File(path + '/' + pages[index]),
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                },
                                onPageChanged: (index) {
                                  saveProgress(index);
                                  progress = index / pageNums;
                                  // getProgress();
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
