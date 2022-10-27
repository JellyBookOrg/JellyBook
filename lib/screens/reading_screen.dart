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

class ReadingScreen extends StatefulWidget {
  final String title;
  final String comicId;
  // final storage = new FlutterSecureStorage();

  ReadingScreen({
    required this.title,
    required this.comicId,
  });

  // create a stateful widget
  _ReadingScreenState createState() => _ReadingScreenState(
        title: title,
        comicId: comicId,
      );
}

class _ReadingScreenState extends State<ReadingScreen> {
  final String title;
  final String comicId;

  _ReadingScreenState({
    required this.title,
    required this.comicId,
  });

  // first we need to check if the file exists
  // if it does (and is a cbz file) then we need to extract it
  Future<void> checkFile() async {
    // check if we have permission to read the file
    PermissionStatus permission = await Permission.storage.status;
    // get location of file
    String dirLocation = await getExternalStorageDirectory().toString();
    if (permission == PermissionStatus.granted) {
      // check if the file exists
      var title2 = await fileNameFromTitle(title);
      if (FileUtils.testfile(dirLocation + '/' + title2 + '.cbz', 'exists') ==
          true) {
        // extract the file
        extractFile();
      } else {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) =>
                DownloadScreen(
              title: title,
              comicId: comicId,
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
      }
    }
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
    // remove quotes
    fileName = fileName.replaceAll('\'', '');
    fileName = fileName.replaceAll('’', '');
    fileName = fileName.replaceAll('‘', '');
    fileName = fileName.replaceAll('“', '');
    fileName = fileName.replaceAll('”', '');
    fileName = fileName.replaceAll('"', '');
    fileName = fileName.replaceAll(RegExp(r'[^\x00-\x7F]+'), '');
    return fileName;
  }

  Future<void> extractFile() async {
    // get location of file
    String dirLocation = await getExternalStorageDirectory().toString();
    // get the file
    var title2 = await fileNameFromTitle(title);
    var file = File(dirLocation + '/' + title2 + '.cbz');
    // read the file
    var bytes = file.readAsBytesSync();
    // decode the file
    var archive = ZipDecoder().decodeBytes(bytes);
    // extract the file
    for (var file in archive) {
      var filename = file.name;
      if (file.isFile) {
        var data = file.content as List<int>;
        File(dirLocation + '/' + title2 + '/' + filename)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory(dirLocation + '/' + title2 + '/' + filename)
          ..create(recursive: true);
      }
    }
  }

  // create a list of pages/images
  List<Widget> pages = [];
  Future<void> createPageList() async {
    // get location of file
    String dirLocation = await getExternalStorageDirectory().toString();
    // get the file
    var title2 = await fileNameFromTitle(title);
    // get the directory
    var dir = Directory(dirLocation + '/' + title2);
    // get the list of files
    var files = dir.listSync();
    // sort the files
    files.sort((a, b) => a.path.compareTo(b.path));
    // add the files to the list
    for (var file in files) {
      pages.add(
        Image.file(
          // convert filesystementity to file
          File(file.path),
          fit: BoxFit.contain,
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
      body: Center(
        child: Text('Reading Screen'),
      ),
    );
  }
}
