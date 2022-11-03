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
import 'package:unrar_file/unrar_file.dart';
import 'package:jellybook/providers/fileNameFromTitle.dart';
import 'package:jellybook/providers/downloader.dart';

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
    final prefs = await SharedPreferences.getInstance();
    Dio dio = Dio();
    bool checkPermission1 = await Permission.storage.request().isGranted;
    if (checkPermission1 == false) {
      await Permission.storage.request();
      checkPermission1 = await Permission.storage.request().isGranted;
    }

    // check if the directory exists
    String title2 = await fileNameFromTitle(title);
    var filePathTest = await getApplicationDocumentsDirectory();
    String path = await prefs.getString(title) ?? 'Error';
    bool checkDirectory =
        await Directory(filePathTest.path + '/' + title2).exists();
    debugPrint("directory: $filePath/$title2");
    debugPrint("checkDirectory: $checkDirectory");

    // check if the directory exists
    // bool checkDown = await checkDownloaded(title);
    if (checkPermission1 == true) {
      if (checkDirectory == true) {
        return;
      }
      url = await storage.read(key: 'server') ?? '';
      imageUrl = await storage.read(key: 'imageUrl') ?? '';
      id = await storage.read(key: 'ServerId') ?? '';
      String client = await storage.read(key: 'client') ?? '';
      token = await storage.read(key: 'AccessToken') ?? '';
      fileName = await fileNameFromTitle(title);
      String fileName3 = await fileNameFromTitle(title);
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
      debugPrint(dirLocation + '/' + fileName3);
      debugPrint('Folder does not exist');
      try {
        FileUtils.mkdir([dirLocation]);
        // set the location of the folder
        dir = dirLocation + '/' + fileName;
        if (filePath.contains('.cbz')) {
          dir += '.zip';
        } else if (filePath.contains('.cbr')) {
          dir += '.rar';
        }
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

      String fileName2 = await fileNameFromTitle(title);
      FileUtils.mkdir([dirLocation + '/']);
      debugPrint('Comic folder created');
      debugPrint(dirLocation + '/' + fileName2);

      // make directory to extract to
      FileUtils.mkdir([dirLocation + '/' + fileName2]);
      comicFolder = dirLocation + '/' + fileName2;
      // check if the file is a zip or rar
      // final fileType = lookupMimeType(dirLocation + '/' + fileName2 + '.zip');
      if (dir.contains('.zip')) {
        // if (filePath.contains('.zip')) {
        var bytes =
            File(dirLocation + '/' + fileName2 + '.zip').readAsBytesSync();

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
            FileUtils.mkdir([dirLocation + '/' + fileName2 + '/' + filename]);
          }
        }
        debugPrint('Unzipped');
        File(dirLocation + '/' + fileName + '.zip').deleteSync();

        debugPrint('Zip file extracted');
      } else if (dir.contains('.rar')) {
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

      setState(() {
        downloading = true;
        progress = 0.0;
        path = dirLocation + '/' + fileName;
        Navigator.pop(context);
      });
    }
    // var prefs = await SharedPreferences.getInstance();
    debugPrint("title: " + title);
    // debugPrint("path: " + filePath);
    debugPrint("comicFolder: " + comicFolder);
    prefs.setString(title, comicFolder);
  }

  Future<String> getFilePath(String fileName) async {
    final directory = await getExternalStorageDirectory();
    final path = directory!.path;
    return path;
  }

  // now we will build the UI
  // if the file is downloading then show a circular progress indicator
  // otherwise we will show a screen saying the file is already downloaded
  // There shouldn't be a download button

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        // dont include the back button if the file is downloading
        automaticallyImplyLeading: !downloading,
      ),
      body: Center(
        child: downloading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // make circular progress indicator and make it take up 7/8 of the screen horizontally
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
                // if downloading == false then say the file is already downloaded but if true tell the user its checking

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
