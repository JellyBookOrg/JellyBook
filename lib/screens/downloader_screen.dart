import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:file_utils/file_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:archive/archive.dart';
import 'dart:convert';
import 'package:mime/mime.dart';
import 'package:unrar_file/unrar_file.dart';

class DownloadScreen extends StatefulWidget {
  final String title;
  final String comicId;
  final String path;

  DownloadScreen({
    required this.title,
    required this.comicId,
    required this.path,
  });

  @override
  _DownloadScreenState createState() => _DownloadScreenState(
        title: title,
        comicId: comicId,
        filePath: path,
      );
}

class _DownloadScreenState extends State<DownloadScreen> {
  final String title;
  final String comicId;
  final String filePath;

  _DownloadScreenState({
    required this.comicId,
    required this.title,
    required this.filePath,
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
    downloadFile();
  }

  Future<void> downloadFile() async {
    final storage = new FlutterSecureStorage();
    Dio dio = Dio();
    bool checkPermission1 = await Permission.storage.request().isGranted;
    if (checkPermission1 == false) {
      await Permission.storage.request();
      checkPermission1 = await Permission.storage.request().isGranted;
    }
    if (checkPermission1 == true) {
      final prefs = await SharedPreferences.getInstance();
      url = await storage.read(key: 'server') ?? '';
      imageUrl = await storage.read(key: 'imageUrl') ?? '';
      id = await storage.read(key: 'ServerId') ?? '';
      String client = await storage.read(key: 'client') ?? '';
      token = await storage.read(key: 'AccessToken') ?? '';
      fileName = await fileNameFromTitle(title);
      String path = await prefs.getString(title) ?? 'Error';
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
      String fileName3 = await fileNameFromTitle(title);
      debugPrint(dirLocation + '/' + fileName3);
      // check if the folder exists
      bool folderExists = false;
      if (path != 'Error') {
        folderExists = true;
      }
      debugPrint(folderExists.toString());
      if (folderExists == true) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Comic Already Downloaded'),
              content: Text('The comic is already downloaded'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        debugPrint('Folder does not exist');
        try {
          FileUtils.mkdir([dirLocation]);
          // set the location of the folder
          var dir = dirLocation + '/' + fileName;
          if (filePath.contains('.cbz')) {
            dir += '.zip';
          } else if (filePath.contains('.cbr')) {
            dir += '.rar';
          }
          // dir += filePath.substring(filePath.lastIndexOf('.'));
          debugPrint('Directory created');
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

        String fileName2 = await fileNameFromTitle(title);
        FileUtils.mkdir([dirLocation + '/']);
        debugPrint('Comic folder created');
        debugPrint(dirLocation + '/' + fileName2);
        final fileType = lookupMimeType(dirLocation + '/' + fileName2 + '.zip');
        if (filePath.contains('.cbz')) {
          var bytes =
              File(dirLocation + '/' + fileName + '.zip').readAsBytesSync();
          FileUtils.mkdir([dirLocation + '/' + fileName2]);
          comicFolder = dirLocation + '/' + fileName2;
          var archive = ZipDecoder().decodeBytes(bytes);
          for (var file in archive) {
            var filename = file.name;
            if (file.isFile) {
              var data = file.content as List<int>;
              File(dirLocation + '/' + fileName2 + '/' + filename)
                ..createSync(recursive: true)
                ..writeAsBytesSync(data);
            } else {
              FileUtils.mkdir([dirLocation + '/' + fileName2 + '/' + filename]);
            }
          }
          debugPrint('Unzipped');
          File(dirLocation + '/' + fileName + '.zip').deleteSync();

          debugPrint('Zip file extracted');
        } else if (filePath.contains('.cbr')) {
          FileUtils.mkdir([dirLocation + '/' + fileName2]);
          comicFolder = dirLocation + '/' + fileName2;
          try {
            await UnrarFile.extract_rar(dirLocation + '/' + fileName + '.rar',
                dirLocation + '/' + fileName2 + '/');
            debugPrint('Rar file extracted');
            debugPrint('Unzipped');
            File(dirLocation + '/' + fileName + '.rar').deleteSync();
          } catch (e) {
            debugPrint("Extraction failed " + e.toString());
          }
        } else {
          debugPrint('Error');
        }
      }

      setState(() {
        downloading = false;
        progress = 0.0;
        path = dirLocation + '/' + fileName;
        Navigator.pop(context);
      });
    } else {
      debugPrint('Permission not granted');
    }
    var prefs = await SharedPreferences.getInstance();
    debugPrint("title: " + title);
    debugPrint("comicFolder: " + comicFolder);
    prefs.setString(title, comicFolder);
  }

  Future<String> getFilePath(String fileName) async {
    final directory = await getExternalStorageDirectory();
    final path = directory!.path;
    return path;
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
    fileName = fileName.replaceAll('!', '_');
    fileName = fileName.replaceAll(',', '_');
    fileName = fileName.replaceAll('\'', '');
    fileName = fileName.replaceAll('’', '');
    fileName = fileName.replaceAll('‘', '');
    fileName = fileName.replaceAll('“', '');
    fileName = fileName.replaceAll('”', '');
    fileName = fileName.replaceAll('"', '');
    fileName = fileName.replaceAll(RegExp(r'[^\x00-\x7F]+'), '');
    return fileName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloading file: ' + title),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Cancel download'),
                    content:
                        Text('Are you sure you want to cancel the download?'),
                    actions: [
                      TextButton(
                        child: Text('Confirm'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          progress = 0.0;
                          downloading = false;
                          FileUtils.rm([path]);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (downloading == true)
              Column(
                children: [
                  Text(
                    'Downloading file...',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CircularProgressIndicator(
                    value: progress / 100,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    progress.toStringAsFixed(0) + '%',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            if (downloading == false)
              Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 200,
                    color: Colors.green,
                  ),
                  SizedBox(
                    height: 180,
                  ),
                  Text(
                    'Book Already Downloaded',
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextButton(
                    child: Text('Close', style: TextStyle(fontSize: 20)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
