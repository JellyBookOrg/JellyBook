// The purpose of this file is to allow the user to read the book/comic they have downloaded
// The new version will have seperate methods for doing so for different file types

// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:isar/isar.dart';
import 'package:jellybook/models/entry.dart';
import 'package:logger/logger.dart';

// reading screens
import 'package:jellybook/screens/readingScreens/pdfReader.dart';
import 'package:jellybook/screens/readingScreens/cbrCbzReader.dart';
import 'package:jellybook/screens/readingScreens/epubReader.dart';

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

// make class not need to have a build method
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
  String fileType = '';
  final isar = Isar.getInstance();
  final logger = Logger();
  // var isar = Isar.open([EntrySchema], inspector: true);

  _ReadingScreenState({
    required this.title,
    required this.comicId,
  });

  // first, we want to see if the user has given us permission to access their files
  // if they have, we want to check if the comic has been downloaded
  // if it has, we want to get the file extension to determine how to read it
  // if it hasn't, we want to tell the user to download it first
  @override
  void initState() {
    super.initState();
    checkPermission(comicId);
    readComic(comicId);
  }

  void checkPermission(String comicId) async {
    if (await Permission.storage.request().isGranted) {
      // if the user has given us permission, we want to check if the comic has been downloaded
      checkDownloaded();
      // if it is, find the file extension and read it
      try {
        // get the entry
        var entry = await isar!.entrys.where().idEqualTo(comicId).findFirst();

        logger.i("entry of checkPermission: $entry");
      } catch (e) {
        logger.e("entry in checkPermission: $e");
      }
    } else {
      // if the user hasn't given us permission, we want to tell them to do so
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Permission Required'),
          content: const Text(
              'JellyBook needs permission to access your files to read your comics'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  Future<void> checkDownloaded() async {
    // get it from the database

    logger.i("comicId: $comicId");
    // final isar = await Isar.open([EntrySchema], inspector: true);

    final entry = await isar!.entrys.where().idEqualTo(comicId).findFirst();

    logger.i("entry: $entry");
    logger.i("entry.path: ${entry!.path}");
    logger.i("entry.title: ${entry.title}");

    // get the entry
    var downloaded = entry.downloaded;

    if (downloaded == false) {
      // if the comic hasn't been downloaded, we want to tell the user to download it first
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Download Required'),
          content: const Text(
              'JellyBook needs to download the comic before you can read it'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
    //   Navigator.push(
    //     context,
    //     PageRouteBuilder(
    //       transitionDuration: const Duration(milliseconds: 500),
    //       pageBuilder: (context, animation, secondaryAnimation) =>
    //           DownloadScreen(
    //         comicId: comicId,
    //       ),
    //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //         var begin = const Offset(1.0, 0.0);
    //         var end = Offset.zero;
    //         var curve = Curves.ease;
    //
    //         var tween =
    //             Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    //
    //         return SlideTransition(
    //           position: animation.drive(tween),
    //           child: child,
    //         );
    //       },
    //     ),
    //   );
    // }
  }

  // check file extension
  Future<String> checkFileExtension(String id) async {
    // get it from the database

    // get the entry
    // final isar = await Isar.open([EntrySchema], inspector: true);
    final entry =
        await isar!.entrys.filter().idEqualTo(id).findFirst() as Entry;

    // get the file extension
    String fileExtension = '';
    try {
      fileExtension = entry.filePath.split('.').last;
      logger.i("fileExtension: $fileExtension");
    } catch (e) {
      logger.e("error getting file extension: $e");
    }

    return fileExtension;
  }

  // choose how to read the file
  Future<void> readComic(String id) async {
    // get the file extension
    var fileExtension = await checkFileExtension(id);

    // use a switch statement to determine how to read the file
    switch (fileExtension) {
      case 'pdf':
        Navigator.push(
          context,
          // for the route, have no transition
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 0),
            pageBuilder: (context, animation, secondaryAnimation) =>
                PdfReader(comicId: comicId, title: title),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
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
        logger.i("Filetype: $fileExtension");
        break;

      case 'cbz':
      case 'cbr':
      case 'zip':
      case 'rar':
        Navigator.push(
          context,
          // for the route, have no transition
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 0),
            pageBuilder: (context, animation, secondaryAnimation) =>
                CbrCbzReader(
              comicId: comicId,
              title: title,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
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
        break;
      case 'epub':
        Navigator.push(
          context,
          // for the route, have no transition
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 0),
            pageBuilder: (context, animation, secondaryAnimation) => EpubReader(
              comicId: comicId,
              title: title,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
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
        break;
      default:
        // if the file extension is not supported, tell the user
        logger.e('File extension not supported');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('File Type Not Supported'),
            content: const Text(
                'JellyBook does not support this file type. Please download a different file'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const Center(
        child: Text("Please wait while we load your comic/book",
            style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
