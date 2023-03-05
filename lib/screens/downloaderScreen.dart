// The purpose of this file is to create a screen that will download books

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:archive/archive.dart';
import 'package:unrar_file/unrar_file.dart';
import 'package:jellybook/providers/fileNameFromTitle.dart';
import 'package:openapi/openapi.dart';

// import the database
import 'package:jellybook/models/entry.dart';
import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';

import 'package:logger/logger.dart';

class DownloadScreen extends StatefulWidget {
  final String comicId;

  DownloadScreen({
    required this.comicId,
  });

  @override
  _DownloadScreenState createState() => _DownloadScreenState(
        comicId: comicId,
      );
}

class _DownloadScreenState extends State<DownloadScreen> {
  final String comicId;
  bool forceDownload = false;

  _DownloadScreenState({
    required this.comicId,
    this.forceDownload = false,
  });
  String url = '';
  String imageUrl = '';
  double progress = 0.0;
  String token = '';
  String id = '';
  String fileName = '';
  String path = '';
  String platformVersion = 'Unknown';
  bool downloading = false;
  String comicFolder = 'Error';

  var logger = Logger();
  final isar = Isar.getInstance();
  String dirLocation = '';
  late Entry entry;

  @override
  void initState() {
    super.initState();
    downloadFile(forceDownload);
  }

  Future<void> downloadFile(bool forceDown) async {
    // var isar = await Isar.open([EntrySchema]);

    // get the entry that matches the comicId
    entry = await isar!.entrys.where().idEqualTo(comicId).findFirst() as Entry;

    final storage = FlutterSecureStorage();
    final prefs = await SharedPreferences.getInstance();
    bool checkPermission1 = await Permission.storage.request().isGranted;
    if (checkPermission1 == false) {
      checkPermission1 = await Permission.storage.request().isGranted;
    }

    if (entry.folderPath.toString() != '') {
      // set the path to the comic folder
      path = entry.folderPath;
      await Directory(path).create(recursive: true);
    }
    if (checkPermission1 == true) {
      if (entry.folderPath != '' && forceDown == false) {
        return;
      }

      url = entry.url;
      imageUrl = entry.imagePath;
      id = entry.id.toString();

      // get stuff from the secure storage
      String client = await storage.read(key: 'client') ?? '';
      token = await storage.read(key: 'AccessToken') ??
          prefs.getString('accessToken') ??
          '';
      final device = prefs.getString('device') ?? '';
      final deviceId = prefs.getString('deviceId');
      final version = prefs.getString('version') ?? '';
      fileName = await fileNameFromTitle(entry.path.split('/').last);
      dirLocation =
          await getApplicationDocumentsDirectory().then((value) => value.path);
      Map<String, String> headers = {
        'Accept':
            'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
        'Accept-Encoding': 'gzip, deflate',
        'Accept-Language': 'en-US,en;q=0.5',
        'Connection': 'keep-alive',
        'Upgrade-Insecure-Requests': '1',
        'X-Emby-Authorization':
            'MediaBrowser Client="$client", Device="$device", DeviceId="$deviceId", Version="$version", Token="$token"',
      };
      // url = url + '/Items/' + comicId + '/Download?api_key=' + token;
      var files = await Directory(dirLocation).list().toList();
      logger.d(files.toString());
      String dir = dirLocation + '/' + fileName;
      logger.d(dir);
      logger.d('Folder does not exist');
      // try {
      // make directory
      await Directory(dirLocation).create(recursive: true);
      logger.d('Directory created');
      // set the location of the folder
      dir = dirLocation + '/' + fileName;
      // set the comic file
      entry.filePath = dir;
      logger.d('Directory created');
      logger.d('Attempting to download file');
      final api = Openapi(basePathOverride: url).getLibraryApi();
      Response<Uint8List> download;
      download = await api.getDownload(
        itemId: id,
        headers: headers,
        onReceiveProgress: (received, total) {
          setState(() {
            downloading = true;
            progress = (received / total * 100);
          });
        },
      );
      logger.d('File downloaded');
      // update to say writing file
      await writeToFile(download, dir);

      await extractFile(dir);

      setState(() {
        downloading = true;
        progress = 0.0;
        path = dirLocation + '/' + fileName;
        // pop the navigator but pass in the value of true
        Navigator.pop(context, true);
      });
    }
    logger.d('title: ' + entry.title);
    logger.d('comicFolder: ' + comicFolder);

    // save the comic to the database
    await isar!.writeTxn(() async {
      await isar!.entrys.put(entry);
    });
    // prefs.setString(title, comicFolder);
  }

  Future<void> writeToFile(Response<Uint8List> data, String dir) async {
    final file = File(dir);
    await file.writeAsBytes(data.data!);
  }

  // now we will build the UI
  // if the file is downloading then show a circular progress indicator
  // otherwise we will show a screen saying the file is already downloaded
  // There shouldn't be a download button

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloading'),
        automaticallyImplyLeading: !downloading,
        // if the file is downloaded, have a button to force download
        actions: [
          if (!downloading)
            IconButton(
              icon: Icon(Icons.download),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Redownload?'),
                    content:
                        Text('Are you sure you want to redownload this file?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                          downloadFile(true);
                        },
                        child: Text('Redownload'),
                      ),
                    ],
                  ),
                );
              },
            )
        ],
      ),
      body: Center(
        child: downloading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.width * 0.7,
                    child: CircularProgressIndicator(
                      value: progress / 100,
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (progress < 100)
                    Text(
                      'Downloading File: ' + progress.toStringAsFixed(2) + '%',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (progress == 100)
                    Text(
                      'Extracting Content',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'File Downloaded',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Giant icon with check mark
                  Icon(
                    Icons.check_circle,
                    size: 100,
                    color: Colors.green,
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> extractFile(String dir) async {
    String fileName2 = await fileNameFromTitle(entry.title);
    // make directory
    try {
      await Directory(dirLocation).create(recursive: true);
    } catch (e) {
      logger.d(e.toString());
    }
    logger.d('Comic folder created');
    logger.d('$dirLocation/$fileName2');

    try {
      await Directory(dirLocation + '/' + fileName2).create(recursive: true);
    } catch (e) {
      logger.d(e.toString());
    }
    comicFolder = dirLocation + '/' + fileName2;
    if (dir.contains('.zip') || dir.contains('.cbz')) {
      var bytes = File(dirLocation + '/' + fileName).readAsBytesSync();

      // extract the zip file
      var archive = ZipDecoder().decodeBytes(bytes);
      for (var file in archive) {
        var filename = file.name;
        if (file.isFile) {
          var data = file.content as List<int>;
          File(dirLocation + '/' + fileName2 + '/' + filename)
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        } else {
          try {
            await Directory(dirLocation + '/' + fileName2 + '/' + filename)
                .create(recursive: true);
          } catch (e) {
            logger.d(e.toString());
          }
        }
      }
      logger.d('Unzipped');
      File(dirLocation + '/' + fileName).deleteSync();

      entry.downloaded = true;

      entry.folderPath = dirLocation + '/' + fileName2;

      logger.d('Zip file extracted');
    } else if (dir.contains('.rar') || dir.contains('.cbr')) {
      try {
        await UnrarFile.extract_rar(
            dirLocation + '/' + fileName, dirLocation + '/' + fileName2 + '/');
        logger.d('Rar file extracted');
        logger.d('Unzipped');
        File(dirLocation + '/' + fileName).deleteSync();
        entry.downloaded = true;
        entry.folderPath = dirLocation + '/' + fileName2;
      } catch (e) {
        logger.d(e.toString());
      }
    } else if (entry.path.contains('.pdf')) {
      logger.d('PDF file');

      try {
        var file = File(dirLocation + '/' + fileName);
        try {
          await Directory('$dirLocation/$fileName2').create(recursive: true);
        } catch (e) {
          logger.d(e.toString());
        }
        file.renameSync(dirLocation + '/' + fileName2 + '/' + fileName);
        entry.folderPath = dirLocation + '/' + fileName2;
        entry.filePath = dirLocation + '/' + fileName2 + '/' + fileName;
        logger.d('PDF file moved');
        entry.downloaded = true;
        entry.folderPath = dirLocation + '/' + fileName2;
      } catch (e) {
        logger.d(e.toString());
      }

      logger.d('PDF file extracted to folder');
      logger.d('PDF file extracted');
    } else if (dir.contains('.epub')) {
      logger.d('EPUB file');
      try {
        var file = File(dirLocation + '/' + fileName);
        try {
          await Directory('$dirLocation/$fileName2').create(recursive: true);
        } catch (e) {
          logger.d(e.toString());
        }
        file.renameSync(dirLocation + '/' + fileName2 + '/' + fileName);
        entry.folderPath = dirLocation + '/' + fileName2;
        entry.filePath = dirLocation + '/' + fileName2 + '/' + fileName;
        logger.d('EPUB file moved');
        entry.downloaded = true;
        entry.folderPath = dirLocation + '/' + fileName2;
      } catch (e) {
        logger.e(e.toString());
      }

      logger.d('EPUB file extracted');
    } else {
      logger.e('Error');
    }

    await isar!.writeTxn(() async {
      await isar!.entrys.put(entry);
    });
  }
}
