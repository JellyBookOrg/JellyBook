import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:archive/archive.dart';
import 'package:unrar_file/unrar_file.dart';
import 'package:jellybook/providers/fileNameFromTitle.dart';

// import the database
import 'package:jellybook/models/entry.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

  @override
  void initState() {
    super.initState();
    downloadFile(forceDownload);
  }

  Future<void> downloadFile(bool forceDown) async {
    var box = Hive.box<Entry>('bookShelf');

    // get the entry that matches the comicId
    var entries = box.values.where((element) => element.id == comicId).toList();
    var entry = entries[0];

    final storage = FlutterSecureStorage();
    final prefs = await SharedPreferences.getInstance();
    Dio dio = Dio();
    bool checkPermission1 = await Permission.storage.request().isGranted;
    if (checkPermission1 == false) {
      checkPermission1 = await Permission.storage.request().isGranted;
    }

    if (entry.folderPath != '') {
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
      token = await storage.read(key: 'AccessToken') ?? '';
      fileName = await fileNameFromTitle(entry.path.split('/').last);
      String dirLocation =
          await getApplicationDocumentsDirectory().then((value) => value.path);
      Map<String, String> headers = {
        'Accept':
            'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
        'Accept-Encoding': 'gzip, deflate',
        'Accept-Language': 'en-US,en;q=0.5',
        'Connection': 'keep-alive',
        'Upgrade-Insecure-Requests': '1',
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:89.0) Gecko/20100101 Firefox/89.0',
      };
      url = url + '/Items/' + comicId + '/Download?api_key=' + token;
      var files = await Directory(dirLocation).list().toList();
      debugPrint(files.toString());
      String dir = dirLocation + '/' + fileName;
      debugPrint(dir);
      debugPrint('Folder does not exist');
      try {
        // make directory
        await Directory(dirLocation).create(recursive: true);
        debugPrint('Directory created');
        // FileUtils.mkdir([dirLocation]);
        // set the location of the folder
        dir = dirLocation + '/' + fileName;
        // if (entry.path.contains('cbz')) {
        //   // dir += '.zip';
        // } else if (entry.path.contains('.cbr')) {
        //   // dir += '.rar';
        // } else if (entry.path.contains('.pdf')) {
        //   // dir += '.pdf';
        // }
        // set the comic file
        entry.filePath = dir;
        debugPrint('Directory created');
        debugPrint("Attempting to download file");
        await dio.download(url, dir,
            options: Options(
              headers: headers,
            ), onReceiveProgress: (receivedBytes, totalBytes) {
          setState(() {
            downloading = true;
            progress = (receivedBytes / totalBytes * 100);
          });
        });
        debugPrint(files.toString());
      } catch (e) {
        debugPrint(e.toString());
      }

      String fileName2 = await fileNameFromTitle(entry.title);
      // FileUtils.mkdir([dirLocation + '/']);
      // make directory
      try {
        await Directory(dirLocation).create(recursive: true);
      } catch (e) {
        debugPrint(e.toString());
      }
      debugPrint('Comic folder created');
      debugPrint(dirLocation + '/' + fileName2);

      // FileUtils.mkdir([dirLocation + '/' + fileName2]);
      // make directory
      try {
        await Directory(dirLocation + '/' + fileName2).create(recursive: true);
      } catch (e) {
        debugPrint(e.toString());
      }
      comicFolder = dirLocation + '/' + fileName2;
      if (dir.contains('.zip')) {
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
            // FileUtils.mkdir([dirLocation + '/' + fileName2 + '/' + filename]);
            // make directory
            try {
              await Directory(dirLocation + '/' + fileName2 + '/' + filename)
                  .create(recursive: true);
            } catch (e) {
              debugPrint(e.toString());
            }
          }
        }
        debugPrint('Unzipped');
        File(dirLocation + '/' + fileName).deleteSync();

        entry.downloaded = true;

        entry.folderPath = dirLocation + '/' + fileName2;

        debugPrint('Zip file extracted');
      } else if (dir.contains('.rar')) {
        try {
          await UnrarFile.extract_rar(dirLocation + '/' + fileName,
              dirLocation + '/' + fileName2 + '/');
          debugPrint('Rar file extracted');
          debugPrint('Unzipped');
          File(dirLocation + '/' + fileName).deleteSync();
          entry.downloaded = true;
        } catch (e) {
          debugPrint("Extraction failed " + e.toString());
        }
      } else if (entry.path.contains('.pdf')) {
        debugPrint('PDF file');

        try {
          var file = File(dirLocation + '/' + fileName);
          // var file = File(dirLocation + '/' + fileName + '.pdf');
          // FileUtils.mkdir([dirLocation + '/' + fileName2]);
          // make directory
          try {
            await Directory('$dirLocation/$fileName2').create(recursive: true);
          } catch (e) {
            debugPrint(e.toString());
          }
          file.renameSync(dirLocation + '/' + fileName2 + '/' + fileName);
          entry.folderPath = dirLocation + '/' + fileName2;
          entry.filePath = dirLocation + '/' + fileName2 + '/' + fileName;
          debugPrint('PDF file moved');
          entry.downloaded = true;
          entry.folderPath = dirLocation + '/' + fileName2;
        } catch (e) {
          debugPrint(e.toString());
        }

        debugPrint('PDF file extracted to folder');
        debugPrint('(Not really extracted)');
      } else {
        debugPrint('Error');
      }

      setState(() {
        downloading = true;
        progress = 0.0;
        path = dirLocation + '/' + fileName;
        Navigator.pop(context);
      });
    }
    debugPrint("title: " + entry.title);
    debugPrint("comicFolder: " + comicFolder);
    // prefs.setString(title, comicFolder);
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
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
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
}
