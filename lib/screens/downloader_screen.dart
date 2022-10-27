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

class DownloadScreen extends StatefulWidget {
  final String title;
  final String comicId;
  // final storage = new FlutterSecureStorage();

  DownloadScreen({
    required this.title,
    required this.comicId,
  });

  @override
  _DownloadScreenState createState() => _DownloadScreenState(
        title: title,
        comicId: comicId,
      );
}

class _DownloadScreenState extends State<DownloadScreen> {
  final String title;
  final String comicId;

  _DownloadScreenState({
    required this.comicId,
    required this.title,
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
      // token = prefs.getString('token') ?? '';
      fileName = await fileNameFromTitle(title);
      String dirLocation =
          await getApplicationDocumentsDirectory().then((value) => value.path);
      Map<String, String> headers = {
        'Accept':
            'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
        'Accept-Encoding': 'gzip, deflate',
        'Accept-Language': 'en-US,en;q=0.5',
        'Connection': 'keep-alive',
        // 'Host': url,
        'Upgrade-Insecure-Requests': '1',
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:89.0) Gecko/20100101 Firefox/89.0',
      };
      url = url + '/Items/' + comicId + '/Download?api_key=' + token;
      // before downloading, check if a folder exists
      String fileName3 = await fileNameFromTitle(title);
      if (FileUtils.testfile(dirLocation + '/' + fileName3, 'directory') ==
          true) {
        // if it does, then pop up a dialog box telling the user that the comic is already downloaded and then pop
        // the screen
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
      }
      try {
        FileUtils.mkdir([dirLocation]);
        debugPrint('Directory created');
        await dio.download(url, dirLocation + '/' + fileName,
            options: Options(
              headers: headers,
            ), onReceiveProgress: (receivedBytes, totalBytes) {
          setState(() {
            downloading = true;
            progress = (receivedBytes / totalBytes * 100);
          });
        });
      } catch (e) {
        print(e);
      }

      // create folder for the comic if it doesn't exist
      String fileName2 = await fileNameFromTitle(title);
      String comicFolder = dirLocation + '/' + fileName2;
      FileUtils.mkdir([comicFolder]);
      debugPrint('Comic folder created');
      // if the file is a cbr or cbz, extract it to the comic folder
      if (fileName2.endsWith('.cbr') || fileName2.endsWith('.cbz')) {
        debugPrint('Extracting file');
        // read the file
        File file = File(dirLocation + '/' + fileName2);
        List<int> bytes = file.readAsBytesSync();
        // decode the RAR archive
        Archive archive = ZipDecoder().decodeBytes(bytes);
        // extract the contents of the RAR archive
        for (ArchiveFile archiveFile in archive) {
          String data = archiveFile.content as String;
          // write the file
          File(comicFolder + '/' + archiveFile.name)
            ..createSync(recursive: true)
            ..writeAsStringSync(data);
        }
        // delete the cbr or cbz file
        file.deleteSync();
      }

      setState(() {
        downloading = false;
        progress = 0.0;
        path = dirLocation + '/' + fileName;
        Navigator.pop(context);
      });
    } else {
      print('Permission not granted');
    }
  }

  Future<String> getFilePath(String fileName) async {
    final directory = await getExternalStorageDirectory();
    // final directory = await getApplicationDocumentsDirectory();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloading file: ' + title),
        // have a x button to cancel the download
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              // ask for confirmation before cancelling the download
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
            // check if the folder exists, if it doesnt then create it
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
            // if file exists, give a dialog saying that and then close the dialog
            if (downloading == false)
              Column(
                children: [
                  // big icon to show that that is in the top third of the screen
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
                  // close the dialog after 3 seconds
                ],
              ),
          ],
        ),
      ),
    );
  }
}
