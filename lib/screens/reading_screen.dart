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
import 'package:jellybook/providers/getChapters.dart';
import 'package:jellybook/providers/progress.dart';

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
  String comicFolder = '';
  int pageNums = 0;
  int pageNum = 0;
  double progress = 0.0;

  _ReadingScreenState({
    required this.title,
    required this.comicId,
  });

  Future<void> checkDownloaded() async {
    var prefs = await SharedPreferences.getInstance();
    folderName = prefs.getString(title) ?? "";
    var filePath = prefs.getString("path") ?? "Error";
    if (folderName == "") {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) =>
              DownloadScreen(
            title: title,
            comicId: comicId,
            path: filePath,
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

  List<String> pages = [];
  Future<void> createPageList() async {
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
      pageNums++;
    }
  }

  void initState() {
    super.initState();
    checkDownloaded();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // getChapters requires folderName to be set
      future: getChapters(folderName),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: Text(title),
            ),
            body: FutureBuilder(
              future: getProgress(comicId),
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
                                      File(pages[index]),
                                      // File(path + '/' + pages[index]),
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                },
                                onPageChanged: (index) {
                                  saveProgress(index, comicId);
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
