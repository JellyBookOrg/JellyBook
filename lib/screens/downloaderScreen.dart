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
import 'package:jellybook/providers/parseEpub.dart';
import 'package:jellybook/providers/ComicInfoXML.dart';
import 'package:openapi/openapi.dart';

// import the database
import 'package:jellybook/models/entry.dart';
import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jellybook/variables.dart';

class DownloadScreen extends StatefulWidget {
  Entry entry;
  DownloadScreen({
    required this.entry,
  });

  @override
  _DownloadScreenState createState() => _DownloadScreenState(
        entry: entry,
      );
}

class _DownloadScreenState extends State<DownloadScreen> {
  // final String comicId;
  Entry entry;
  bool forceDownload = false;

  _DownloadScreenState({
    required this.entry,
    this.forceDownload = false,
  });
  double progress = 0.0;
  String token = '';
  String id = '';
  String fileName = '';
  String path = '';
  String platformVersion = 'Unknown';
  bool downloading = false;
  bool downloaded = false;
  String comicFolder = 'Error';
  DownloadStatus downloadStatus = DownloadStatus.NotDownloaded;

  final isar = Isar.getInstance();
  String dirLocation = '';
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    downloadFile(forceDownload);
  }

  Future<void> downloadFile(bool forceDown) async {
    // set the status to downloading
    downloadStatus = DownloadStatus.Downloading;
    // get the entry that matches the comicId
    downloaded = entry.downloaded;

    final storage = FlutterSecureStorage();
    final prefs = await SharedPreferences.getInstance();
    // bool checkPermission1 = await Permission.storage.request().isGranted;
    // if (checkPermission1 == false) {
    //   await Permission.storage.request();
    //   checkPermission1 = await Permission.storage.request().isGranted;
    // }
    // print all details of the entry
    logger.d("Entry details:\nTitle: " +
        entry.title +
        "\nID: " +
        entry.id +
        "\nURL: " +
        entry.url +
        "\nImage Path: " +
        entry.imagePath +
        "\nFolder Path: " +
        entry.folderPath +
        "\nFile Path: " +
        entry.filePath +
        "\nPath: " +
        entry.path +
        "\nDownloaded: " +
        entry.downloaded.toString());
    // if (checkPermission1 == false) {
    //   checkPermission1 = await Permission.storage.request().isGranted;
    // }

    if (entry.folderPath.toString() != '') {
      // set the path to the comic folder
      path = entry.folderPath;
      await Directory(path).create(recursive: true);
    }
    // if (checkPermission1 == true) {
    if (entry.folderPath != '' && forceDown == false) {
      return;
    }
    logger.d('About to download file');

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
    final api = Openapi(basePathOverride: entry.url).getLibraryApi();
    Response<Uint8List> download;
    downloading = true;
    download = await api
        .getDownload(
      itemId: id,
      headers: headers,
      onReceiveProgress: (received, total) {
        setState(() {
          progress = (received / total * 100);
        });
      },
    )
        .onError((error, stackTrace) {
      logger.e(error);
      logger.e(stackTrace);
      setState(() {
        downloading = false;
        progress = 0.0;
        downloadStatus = DownloadStatus.DownloadFailed;
      });
      return Response<Uint8List>(
        data: Uint8List(0),
        requestOptions: RequestOptions(path: ''),
        statusCode: 0,
      );
    });
    if (download.statusCode != 200) {
      logger.e('Download failed');
      setState(() {
        downloading = false;
        progress = 0.0;
        downloadStatus = DownloadStatus.DownloadFailed;
      });
      return;
    }
    logger.d('File downloaded');
    // update to say writing file
    await writeToFile(download, dir);

    await extractFile(dir);

    setState(() {
      entry.downloaded = true;
      entry.progress = 0.0;
      // entry.filePath = dirLocation + '/' + fileName;
      // pop the navigator but pass in the value of true
      Navigator.pop(context, entry);
    });
    // }
    logger.d('title: ' + entry.title);
    logger.d('comicFolder: ' + comicFolder);

    // save the comic to the database
    await isar!.writeTxn(() async {
      await isar!.entrys.put(entry);
    });
    // prefs.setString(title, comicFolder);
  }

  Future<void> writeToFile(Response<Uint8List> data, String dir) async {
    downloadStatus = DownloadStatus.Downloaded;
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
        title: Text(AppLocalizations.of(context)?.downloading ?? 'Downloading'),
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
                    title: Text((AppLocalizations.of(context)?.redownload ??
                            'Redownload') +
                        '?'),
                    content: Text(
                      AppLocalizations.of(context)?.redownload ??
                          'Are you sure you want to redownload this file?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: Text(
                            AppLocalizations.of(context)?.cancel ?? 'Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                          downloadFile(true);
                        },
                        child: Text(AppLocalizations.of(context)?.redownload ??
                            'Redownload'),
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
                  if (progress < 100 &&
                      downloadStatus == DownloadStatus.Downloading)
                    Text(
                      (AppLocalizations.of(context)?.downloadingFile ??
                              'Downloading File:') +
                          ' ' +
                          progress.toStringAsFixed(2) +
                          '%',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (progress == 100)
                    Text(
                      AppLocalizations.of(context)?.extractingContent ??
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
            : downloadStatus != DownloadStatus.DownloadFailed &&
                    downloadStatus != DownloadStatus.DecompressingFailed &&
                    !downloaded
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)?.fileDownloaded ??
                            'File Downloaded',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Giant icon with check mark
                      const Icon(
                        Icons.check_circle,
                        size: 100,
                        color: Colors.green,
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)?.downloadFailed ??
                            "The download was unable to complete. Please try again later.",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Giant icon with check mark
                      const Icon(
                        Icons.error,
                        size: 100,
                        color: Colors.red,
                      ),
                    ],
                  ),
      ),
    );
  }

  Future<void> extractFile(String dir) async {
    logger.d('Extracting file');
    downloadStatus = DownloadStatus.Decompressing;
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
    List<String> audioFileTypes = [
      'flac',
      'mpga',
      'mp3',
      'm3u',
      'm3u8',
      'm4a',
      'm4b',
      'wav',
    ];
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
      parseXML(entry);
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
      parseXML(entry);
    } else if (entry.path.contains('.pdf')) {
      logger.d('PDF file');

      try {
        var file = File(dirLocation + '/' + fileName);
        try {
          await Directory('$dirLocation/$fileName2').create(recursive: true);
        } catch (e) {
          logger.d(e.toString());
        }
        file.renameSync(comicFolder + '/' + fileName);
        entry.folderPath = comicFolder;
        entry.filePath = comicFolder + '/' + fileName;
        logger.d('PDF file moved');
        entry.downloaded = true;
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
      } catch (e) {
        logger.e(e.toString());
      }

      logger.d('EPUB file extracted');
      // get the OEBPS/content.opf file and parse it
      logger.d('Now parsing the content.opf file');
      parseEpub(entry);
      // check if director contains audio file
    } else if (audioFileTypes.any(dir.contains)) {
      logger.d('Audio file');
      try {
        var file = File(dirLocation + '/' + await fileNameFromTitle(fileName));
        try {
          await Directory('$dirLocation/$fileName2').create(recursive: true);
        } catch (e) {
          logger.d(e.toString());
        }
        file.renameSync(dirLocation + '/' + fileName2 + '/' + fileName);
        entry.folderPath = dirLocation + '/' + fileName2;
        entry.filePath = dirLocation + '/' + fileName2 + '/' + fileName;
        logger.d('Audio file moved');
        entry.downloaded = true;
        entry.folderPath = dirLocation + '/' + fileName2;
      } catch (e) {
        logger.e(e.toString());
      }
    } else {
      logger.e('Error');
    }

    logger.d('IsarId: ${entry.isarId}');
    await isar?.writeTxn(() async {
      await isar?.entrys.put(entry).then((value) {
        logger.d('Entry updated');
        logger.d('isarId: ${entry.isarId}');
        logger.d('entry.filePath: ${entry.filePath}');
      });
    });
  }
}

enum DownloadStatus {
  NotDownloaded,
  Downloading,
  Downloaded,
  Decompressing,
  DownloadFailed,
  DecompressingFailed,
}
