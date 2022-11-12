// The purpose of this file is to allow the user to read pdf files

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jellybook/screens/downloaderScreen.dart';
import 'package:jellybook/providers/fileNameFromTitle.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jellybook/models/entry.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:jellybook/providers/progress.dart';
// import 'package:open_filex/open_filex.dart';

class PdfReader extends StatefulWidget {
  final String comicId;
  final String title;

  PdfReader({
    required this.comicId,
    required this.title,
  });

  _PdfReaderState createState() => _PdfReaderState(
        comicId: comicId,
        title: title,
      );
}

class _PdfReaderState extends State<PdfReader> {
  final String comicId;
  final String title;

  List<String> chapters = [];
  String folderName = '';
  String comicFolder = '';
  // int pageNums = 0;
  // int pageNum = 0;
  double progress = 0.0;
  String fileType = '';
  var box = Hive.box<Entry>('bookShelf');
  // bool _isLoading = true;
  String path = '';
  int page = 1;
  int total = 0;
  // pages
  int _totalPages = 0;

  _PdfReaderState({
    required this.comicId,
    required this.title,
  });

  // first, we want to see if the user has given us permission to access their files
  // if they have, we want to check if the comic has been downloaded
  // if it has, we want to get the file extension to determine how to read it
  // if it hasn't, we want to tell the user to download it first
  @override
  void initState() {
    super.initState();
    getPath();
    // loadBook();
  }

  // get the path to the comic
  Future<void> getPath() async {
    // get the entry from the box
    var entries = box.values.where((element) => element.id == comicId).toList();
    var entry = entries[0];
    // get the path to the comic
    path = entry.filePath;
    debugPrint('path: $path');

    // get current page
    page = entry.pageNum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        // have a container for the pdf
        child: Container(
          child: PDFView(
            defaultPage: page,
            filePath: path,
            autoSpacing: true,
            enableSwipe: true,
            pageSnap: true,
            swipeHorizontal: true,
            nightMode: false,
            onError: (error) {
              debugPrint(error.toString());
            },
            onPageError: (page, error) {
              debugPrint('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              // _controller.complete(pdfViewController);
            },
            onPageChanged: (int? page, int? total) {
              debugPrint('page change: $page/$total');
              saveProgress(page: page ?? 0, comicId: comicId);
            },
          ),
        ),
      ),
    );
  }
}
