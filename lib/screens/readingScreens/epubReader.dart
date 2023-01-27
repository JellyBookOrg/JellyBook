// the purpose of this file is to read epub files

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:epub_view/epub_view.dart';
import 'package:jellybook/providers/fileNameFromTitle.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:isar/isar.dart';
import 'package:jellybook/models/entry.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logger/logger.dart';

class EpubReader extends StatefulWidget {
  final String title;
  final String comicId;

  EpubReader({
    required this.title,
    required this.comicId,
  });

  _EpubReaderState createState() => _EpubReaderState(
        title: title,
        comicId: comicId,
      );
}

class _EpubReaderState extends State<EpubReader> {
  final String title;
  final String comicId;

  List<String> chapters = [];
  String filePath = '';
  int pageNum = 0;
  double progress = 0.0;
  String fileType = '';
  final isar = Isar.getInstance();
  var logger = Logger();

  _EpubReaderState({
    required this.title,
    required this.comicId,
  });

  late EpubController _epubController;

  // late EpubBookRef _epubBookRef;
  Future<void> saveProgress(int page) async {
    final isar = Isar.getInstance();
    final entry = await isar!.entrys.filter().idEqualTo(comicId).findFirst();
    // final entry = await isar!.entrys.where().idEqualTo(comicId).findFirst();

    // update the entry
    entry!.pageNum = page;

    // delete the old entry and add the new one
    await isar.writeTxn(() async {
      await isar.entrys.put(entry);
    });

    logger.d("saved progress");
    logger.d("page num: ${entry.pageNum}");
  }

  Future<void> updateChapter(String epubCfiNum) async {
    if (epubCfiNum == "error") {
      return;
    }
    final entry = await isar!.entrys.where().idEqualTo(comicId).findFirst();
    await isar!.writeTxn(() async {
      entry!.epubCfi = epubCfiNum;
      logger.d("entry.pageNum: ${entry.pageNum}");
      await isar!.entrys.put(entry);
    });
  }

  Future<void> goToChapter(EpubController _epubController) async {
    final entry = await isar!.entrys.where().idEqualTo(comicId).findFirst();
    var pageCfi = entry!.epubCfi;
    if (pageCfi.isNotEmpty && pageCfi != "") {
      logger.d("pageCfi: $pageCfi");
      _epubController.gotoEpubCfi(pageCfi);
    }
  }

  Future<void> openController() async {
    final entry = await isar!.entrys.where().idEqualTo(comicId).findFirst();
    final filePath = entry!.filePath;
    _epubController = EpubController(
      document: EpubDocument.openFile(File(addEscapeSequence(filePath))),
    );
    // _epubController = EpubController(
    //   document: EpubDocument.openFile(File(filePath)),
    // );
    goToChapter(_epubController);
  }

  String addEscapeSequence(String str) {
    str = str
        // replace all the single quotes with double single quotes
        .replaceAll("'", "\\'")
        // replace all the double quotes with double double quotes
        .replaceAll('"', '\\"')
        // replace all the [ with double [
        .replaceAll('[', '\\[')
        // replace all the ] with double ]
        .replaceAll(']', '\\]')
        // replace all the { with double {
        .replaceAll('{', '\\{')
        // replace all the } with double }
        .replaceAll('}', '\\}')
        // replace all the ( with double (
        .replaceAll('(', '\\(')
        // replace all the ) with double )
        .replaceAll(')', '\\)')
        // replace all the < with double <
        .replaceAll('<', '\\<')
        // replace all the > with double >
        .replaceAll('>', '\\>')
        // replace all the | with double |
        .replaceAll('|', '\\|')
        // replace all the ? with double ?
        .replaceAll('?', '\\?')
        // replace all the * with double *
        .replaceAll('*', '\\*')
        // replace all the + with double +
        .replaceAll('+', '\\+')
        // replace all the , with double ,
        .replaceAll(',', '\\,')
        // replace all the ; with double ;
        .replaceAll(';', '\\;')
        // replace all the : with double :
        .replaceAll(':', '\\:');
    return str;
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  // request permissions
  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      // request read and write permissions
      await Permission.storage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: openController(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: EpubViewActualChapter(
                  controller: _epubController,
                  builder: (chapterValue) => Text(chapterValue?.chapter?.Title
                          ?.replaceAll('\n', ' ')
                          .trim() ??
                      title),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              drawer: Drawer(
                child: EpubViewTableOfContents(
                  controller: _epubController,
                ),
              ),
              body: EpubView(
                controller: _epubController,
                onExternalLinkPressed: (url) {
                  logger.d("External link pressed: $url");
                  // open url in browser
                  launchUrl(Uri.parse(url));
                },
                onDocumentLoaded: (document) {
                  logger.d("Document loaded: ${document.Title}");
                },
                onChapterChanged: (chapter) {
                  logger.d("Chapter changed: $chapter");
                  updateChapter(_epubController.generateEpubCfi() ?? "error");
                },
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
