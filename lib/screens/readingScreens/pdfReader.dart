// The purpose of this file is to allow the user to read pdf files

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jellybook/screens/downloaderScreen.dart';
import 'package:jellybook/providers/fileNameFromTitle.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
import 'package:jellybook/models/entry.dart';
import 'package:pdfx/pdfx.dart';
import 'package:jellybook/providers/progress.dart';
import 'package:logger/logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  double progress = 0.0;
  String fileType = '';
  final isar = Isar.getInstance();
  // bool _isLoading = true;
  String path = '';
  int page = 1;
  int total = 0;
  // pages
  int _totalPages = 0;
  late PdfController pdfController;

  var logger = Logger();

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
  }

  // get the path to the comic
  Future<void> getPath() async {
    // get the entry from the box
    final entry = await isar!.entrys.where().idEqualTo(comicId).findFirst();
    // get the path to the comic
    path = entry!.filePath;
    logger.d('path: $path');

    // get current page
    page = entry.pageNum;

    pdfController = PdfController(
      document: PdfDocument.openFile(path),
      initialPage: page,
    );
  }

  @override
  Widget build(BuildContext context) {
    // await the future to get the path as FutureBuilder
    return FutureBuilder(
      future: getPath(),
      builder: (context, snapshot) {
        // if the future is done
        if (snapshot.connectionState == ConnectionState.done) {
          // if there is an error
          if (snapshot.hasError) {
            // return an error message
            return Center(
              child: Text(
                (AppLocalizations.of(context)?.error ?? 'Error:') +
                    ' ${snapshot.error}',
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(title),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ),
              body: Center(
                child: Container(
                  child: PdfView(
                    controller: pdfController,
                    onPageChanged: (page) {
                      saveProgress(page: page, comicId: comicId);
                    },
                    onDocumentError: (error) {
                      logger.e('error: $error');
                    },
                    pageSnapping: true,
                  ),
                ),
              ),
            );
          }
        } else {
          // return a loading indicator
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
