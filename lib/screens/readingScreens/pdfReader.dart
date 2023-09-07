// The purpose of this file is to allow the user to read pdf files

import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:jellybook/screens/downloaderScreen.dart';
import 'package:jellybook/providers/fileNameFromTitle.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
import 'package:jellybook/models/entry.dart';
import 'package:pdfx/pdfx.dart';
import 'package:jellybook/providers/progress.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jellybook/variables.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:jellybook/screens/AudioPicker.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:jellybook/widgets/AudioPlayerWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  String audioPath = '';
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration audioPosition = Duration();
  String audioId = '';
  // pages
  int _totalPages = 0;
  late PdfController pdfController;
  late String direction;

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
    setDirection();
  }

  @override
  void dispose() {
    // dispose of the pdf controller
    pdfController.dispose();
    audioPlayer.dispose();
    // timer?.cancel();
    super.dispose();
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

  void setDirection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    direction = prefs.getString('readingDirection') ?? 'ltr';
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
                '${snapshot.error}',
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(title),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
                actions: [
                  audioPlayerWidget(),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              body: Center(
                child: Container(
                  child: PdfView(
                    controller: pdfController,
                    onPageChanged: (page) {
                      saveProgress(page: page, comicId: comicId);
                    },
                    scrollDirection: direction == 'rtl' || direction == 'ltr'
                        ? Axis.horizontal
                        : Axis.vertical,
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
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
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
}
