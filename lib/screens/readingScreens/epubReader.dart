// the purpose of this file is to read epub files

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:epub_view/epub_view.dart';
import 'package:jellybook/providers/fileNameFromTitle.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jellybook/models/entry.dart';
import 'package:url_launcher/url_launcher.dart';

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
  var box = Hive.box<Entry>('bookShelf');

  _EpubReaderState({
    required this.title,
    required this.comicId,
  });

  late EpubController _epubController;
  // late EpubBookRef _epubBookRef;
  Future<void> saveProgress(int page) async {
    var db = Hive.box<Entry>('bookShelf');

    // get the box that stores the entries
    var entries = db.values.toList();

    // get the entry
    var entry = entries.firstWhere((element) => element.id == comicId);

    // update the entry
    entry.pageNum = page;

    // delete the old entry and add the new one
    entries.remove(entry);
    entries.add(entry);

    debugPrint("saved progress");
    debugPrint("page num: ${entry.pageNum}");
  }

  @override
  void initState() {
    super.initState();
    // get list of entries
    var entries = box.values.toList();
    // get the entry that matches the comicId
    var entry = entries.firstWhere((element) => element.id == comicId);
    filePath = entry.filePath;

    debugPrint("filePath: $filePath");

    _epubController = EpubController(
      document: EpubDocument.openFile(
        File(filePath),
      ),
    );
    var pagesNum = entry.pageNum;
    if (pagesNum.toInt() > 0) {
      debugPrint("pagesNum: $pagesNum");
      // jump to the page
      _epubController.jumpTo(index: pagesNum);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: EpubViewActualChapter(
          controller: _epubController,
          builder: (chapterValue) => Text(
              chapterValue?.chapter?.Title?.replaceAll('\n', ' ').trim() ??
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
          debugPrint('External link pressed: $url');
          // open url in browser
          launchUrl(Uri.parse(url));
        },
        onDocumentLoaded: (document) {
          debugPrint('Document loaded: $document');
        },
        onChapterChanged: (chapter) {
          debugPrint('Chapter changed: $chapter');
          // find the entry
          var entries =
              box.values.where((element) => element.id == comicId).toList();
          var entry = entries[0];
          entry.pageNum = chapter?.paragraphNumber ?? 0;
          debugPrint("entry.pageNum: ${entry.pageNum}");
          // get position in box
          var position = box.values.toList().indexOf(entry);
          // put the entry back in the box
          box.putAt(position, entry);
        },
      ),
    );
  }
}
