// the purpose of this file is to read epub files

import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:epub_view_enhanced/epub_view_enhanced.dart';
import 'package:jellybook_epub_view/jellybook_epub_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
import 'package:jellybook/models/entry.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jellybook/variables.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:jellybook/screens/AudioPicker.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:jellybook/widgets/AudioPlayerWidget.dart';

class EpubReader extends StatefulWidget {
  final String title;
  final String comicId;

  EpubReader({
    required this.title,
    required this.comicId,
  });

  _EpubReaderState createState() => _EpubReaderState(
        title: title,
        comicId: comicId,
      );
}

class _EpubReaderState extends State<EpubReader> {
  final String title;
  final String comicId;

  List<String> chapters = [];
  String filePath = '';
  int pageNum = 0;
  double progress = 0.0;
  String fileType = '';
  final isar = Isar.getInstance();

  // audio variables
  String audioPath = '';
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration audioPosition = const Duration();
  String audioId = '';

  _EpubReaderState({
    required this.title,
    required this.comicId,
  });

  late EpubController _epubController;

  // we will find the index position and jump to position

  // late EpubBookRef _epubBookRef;
  // Future<void> saveProgress(String url) async {
  //   final isar = Isar.getInstance();
  //   final entry = await isar!.entrys.filter().idEqualTo(comicId).findFirst();
  //   // final entry = await isar!.entrys.where().idEqualTo(comicId).findFirst();
  //
  //   // update the entry
  //   // entry!.pageNum = page;
  //
  //   // delete the old entry and add the new one
  //   await isar.writeTxn(() async {
  //     // await isar.entrys.put(entry);
  //   });
  //
  //   logger.d("saved progress");
  //   // logger.d("page num: ${entry.pageNum}");
  // }

  Future<void> updateChapter(String epubCfiNum) async {
    if (epubCfiNum == "error") {
      return;
    }
    final entry = await isar!.entrys.where().idEqualTo(comicId).findFirst();
    logger.d("epubCfiNum: $epubCfiNum");
    await isar!.writeTxn(() async {
      entry!.epubCfi = epubCfiNum;
      await isar!.entrys.put(entry);
    });
  }

  Future<void> goToChapter(EpubController epubController) async {
    final entry = await isar!.entrys.where().idEqualTo(comicId).findFirst();
    var pageCfi = entry!.epubCfi;
    if (pageCfi.isNotEmpty && pageCfi != "") {
      logger.d("pageCfi: $pageCfi");
      epubController.gotoEpubCfi(pageCfi);
      // _epubController.gotoEpubCfi(pageCfi);
    }
  }

  Future<void> saveChapterIndex(int index) async {
    final entry = await isar!.entrys.where().idEqualTo(comicId).findFirst();
    if (entry == null) return;

    await isar!.writeTxn(() async {
      entry.pageNum = index;
      await isar!.entrys.put(entry);
    });

    logger.d("Saved chapter index: $index");
  }

  Future<int?> loadChapterIndex() async {
    final entry = await isar!.entrys.where().idEqualTo(comicId).findFirst();
    if (entry == null) return null;
    return entry.pageNum;
  }

  Future<void> openController() async {
    final entry = await isar!.entrys.where().idEqualTo(comicId).findFirst();
    final filePath = entry!.filePath;
    _epubController = EpubController(
      document: EpubDocument.openFile(File(addEscapeSequence(filePath))),
    );
  }

  String addEscapeSequence(String str) {
    str = str
        // replace all the single quotes with double single quotes
        .replaceAll("'", "\\'")
        // replace all the double quotes with double double quotes
        .replaceAll('"', '\\"')
        // replace all the [ with double [
        .replaceAll('[', '\\[')
        // replace all the ] with double ]
        .replaceAll(']', '\\]')
        // replace all the { with double {
        .replaceAll('{', '\\{')
        // replace all the } with double }
        .replaceAll('}', '\\}')
        // replace all the ( with double (
        .replaceAll('(', '\\(')
        // replace all the ) with double )
        .replaceAll(')', '\\)')
        // replace all the < with double <
        .replaceAll('<', '\\<')
        // replace all the > with double >
        .replaceAll('>', '\\>')
        // replace all the | with double |
        .replaceAll('|', '\\|')
        // replace all the ? with double ?
        .replaceAll('?', '\\?')
        // replace all the * with double *
        .replaceAll('*', '\\*')
        // replace all the + with double +
        .replaceAll('+', '\\+')
        // replace all the , with double ,
        .replaceAll(',', '\\,')
        // replace all the ; with double ;
        .replaceAll(';', '\\;')
        // replace all the : with double :
        .replaceAll(':', '\\:');
    return str;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _epubController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> onAudioPickerPressed() async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AudioPicker(),
      ),
    );
    if (result != null) {
      await getAudioId(result);
      logger.d('result: $result');
      setState(() => audioPath = result);
    }
  }

  Future<void> playAudio(String audioPath, Duration position) async {
    logger.d('audioPath: $audioPath');
    await audioPlayer.play(DeviceFileSource(audioPath), position: position);
    await audioPlayer.seek(position);
    FlutterBackgroundService().invoke("setAsForeground");
    setState(() {
      isPlaying = true;
    });

    // Listen to audio position changes and update audioPosition variable
    audioPlayer.onPositionChanged.listen((Duration newPosition) {
      audioPosition = newPosition;
    });
  }

  Future<void> savePosition() async {
    Isar? isar = Isar.getInstance();
    if (isar != null) {
      var entry =
          await isar.entrys.where().filter().idEqualTo(audioId).findFirst();
      if (entry != null) {
        await isar.writeTxn(() async {
          entry.pageNum = audioPosition.inSeconds;
          isar.entrys.put(entry);
        });
        logger.d('saved position: ${entry.pageNum}');
      }
    }
  }

  Future<void> pauseAudio() async {
    await savePosition();
    await audioPlayer.pause();
    FlutterBackgroundService().invoke("setAsBackground");
    setState(() {
      isPlaying = false;
    });
  }

  Future<void> stopAudio() async {
    await savePosition();
    await audioPlayer.stop();
    FlutterBackgroundService().invoke("setAsBackground");
    setState(() {
      isPlaying = false;
    });
  }

  Future<void> getAudioId(String audioPath) async {
    Isar? isar = Isar.getInstance();
    if (isar != null) {
      var entry = await isar.entrys
          .where()
          .filter()
          .filePathEqualTo(audioPath)
          .findFirst();
      if (entry != null) {
        setState(() {
          audioId = entry.id;
        });
      }
    }
  }

  Widget audioPlayerWidget() {
    if (audioPath == '') {
      return IconButton(
        icon: const Icon(Icons.audiotrack),
        onPressed: onAudioPickerPressed,
      );
    }
    return AudioPlayerWidget(
      audioPath: audioPath,
      isPlaying: isPlaying,
      progress: progress,
      onAudioPickerPressed: onAudioPickerPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: openController(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: EpubViewActualChapter(
                  controller: _epubController,
                  builder: (chapterValue) => Text(chapterValue?.chapter?.Title
                          ?.replaceAll('\n', ' ')
                          .trim() ??
                      title),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  audioPlayerWidget(),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              drawer: Drawer(
                child: EpubViewTableOfContents(
                  controller: _epubController,
                ),
              ),
              body: EpubView(
                  (url) {
                    logger.d("External link pressed: $url");
                    // open url in browser
                    launchUrl(Uri.parse(url));
                  },
                  controller: _epubController,
                  onDocumentLoaded: (document) async {
                    logger.d("Document loaded: ${document.Title}");

                    final savedIndex = await loadChapterIndex();
                    if (savedIndex != null) {
                      logger.d("Restoring chapter index: $savedIndex");
                      Future.delayed(Duration(milliseconds: 500), () {
                        _epubController.jumpTo(index: savedIndex);
                      });
                    }
                  },
                  // onDocumentLoaded: (document) {
                  //   logger.d("Document loaded: ${document.Title}");
                  //   // wait 5 seconds and then go to the chapter
                  //   Future.delayed(Duration(seconds: 5), () {
                  //     logger.d("Document loaded: ${document.Title}");
                  //     goToChapter(_epubController);
                  //   });
                  //   // goToChapter(_epubController);
                  // },
                  onChapterChanged: (chapterValue) {
                    final index = chapterValue?.position.index;
                    if (index != null) {
                      logger.d("Saving chapter index: $index");
                      saveChapterIndex(index);
                    }
                  }
                  // onChapterChanged: (chapter) {
                  //   // only do it every 5th time
                  //
                  //   // logger.d("Chapter changed: $chapter");
                  //   // logger.d(chapter!.position);
                  //   updateChapter(_epubController.generateEpubCfi() ?? "error");
                  // },
                  ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
