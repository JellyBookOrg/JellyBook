// The purpose of this file is to allow the user to read the book/comic they have downloaded

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jellybook/screens/downloader_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:jellybook/providers/fileNameFromTitle.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:archive/archive.dart';
// import 'package:archive/archive_io.dart';
// import 'package:turn_page_transition/turn_page_transition.dart';

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

  Future<void> getChapters() async {
    final prefs = await SharedPreferences.getInstance();
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    var filePath = await getApplicationDocumentsDirectory();
    String title2 = await fileNameFromTitle(title);
    // check if the directory exists
    if (await Directory(filePath.path + '/' + title2).exists()) {
      comicFolder = filePath.path + '/' + title2;
    } else {
      comicFolder = 'Error';
    }
    // comicFolder = prefs.getString(title) ?? "";
    print('Comic Folder: ' + comicFolder);
    // print("folder name: $folderName");
    path = comicFolder;
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
                List<FileSystemEntity> files4 =
                    Directory(file3.path).listSync();
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
  }

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
                                      File(pages[index]),
                                      // File(path + '/' + pages[index]),
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
