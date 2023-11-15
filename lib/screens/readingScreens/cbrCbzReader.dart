// The purpose of this file is to allow the user to read the book/comic they have downloaded

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jellybook/providers/updatePagenum.dart';
import 'package:jellybook/screens/downloaderScreen.dart';
import 'package:jellybook/providers/fileNameFromTitle.dart';
import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:jellybook/models/entry.dart';
import 'package:jellybook/providers/progress.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jellybook/variables.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:jellybook/screens/AudioPicker.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:jellybook/widgets/AudioPlayerWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

// cbr/cbz reader
class CbrCbzReader extends StatefulWidget {
  final String title;
  final String comicId;

  const CbrCbzReader({
    Key? key,
    required this.title,
    required this.comicId,
  }) : super(key: key);

  @override
  _CbrCbzReaderState createState() => _CbrCbzReaderState();
}

class _CbrCbzReaderState extends State<CbrCbzReader> {
  late String title;
  late String comicId;
  int pageNum = 0;
  int pageNums = 0;
  double progress = 0.0;
  late String path;
  late List<String> chapters = [];
  late List<String> pages = [];
  late String direction;

  // audio variables
  String audioPath = '';
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration audioPosition = Duration();
  String audioId = '';

  void setDirection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    direction = prefs.getString('readingDirection') ?? 'ltr';
    logger.f("direction: $direction");
  }

  Future<void> createPageList() async {
    // create a list of chapters
    // call getChaptersFromDirectory with path as a FileSystemEntity
    await getChaptersFromDirectory(Directory(path));
    logger.d("chapters: $chapters");
    List<String> formats = [
      ".jpg",
      ".jpeg",
      ".png",
      ".gif",
      ".webp",
      ".bmp",
      ".tiff"
      // also include all variations of capitalizations of these
    ];
    List<String> pageFiles = [];
    for (var chapter in chapters) {
      List<String> files =
          Directory(chapter).listSync().map((e) => e.path).toList();
      for (var file in files) {
        if (formats.any((element) => file.toLowerCase().endsWith(element))) {
          pageFiles.add(file);
        }
      }
    }
    pageFiles.sort();
    for (var page in pageFiles) {
      pages.add(page);
      pageNums++;
    }
  }

  Future<void> getData() async {
    final isar = Isar.getInstance();
    return await isar!.entrys
        .where()
        .idEqualTo(comicId)
        .findFirst()
        .then((value) {
      setState(() {
        pageNum = value!.pageNum;
        progress = value.progress;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    title = widget.title;
    comicId = widget.comicId;
    getData();
    setDirection();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> saveProgress(int page) async {
    final isar = Isar.getInstance();
    final entry = await isar!.entrys.where().idEqualTo(comicId).findFirst();

    // update the entry
    entry!.pageNum = page;

    // update the progress
    entry.progress = (page / pages.length) * 100;

    // delete the old entry and add the new one
    await isar.writeTxn(() async {
      await isar.entrys.put(entry);
    });

    logger.d("saved progress");
    logger.d("page num: ${entry.pageNum}");
    updatePagenum(entry.id, entry.pageNum);
  }

  Future<void> getChapters() async {
    logger.d("getting chapters");
    // var status = await Permission.storage.status;
    // if (!status.isGranted) {
    //   await Permission.storage.request();
    // }

    // get the file path from the database
    final isar = Isar.getInstance();
    final entry = await isar!.entrys.where().idEqualTo(comicId).findFirst();

    // get the path
    path = entry!.folderPath;

    // print the entry
    logger.d("title: ${entry.title}");
    logger.d("path: ${entry.filePath}");
    logger.d("folder path: ${entry.folderPath}");
    logger.d("page num: ${entry.pageNum}");
    logger.d("progress: ${entry.progress}");
    logger.d("id: ${entry.id}");
    logger.d("downloaded: ${entry.downloaded}");
    // check if the entry is downloaded
    if (entry.downloaded) {
      progress = entry.progress;
      pageNum = entry.pageNum;
    }

    logger.d(path);
    File file = File(path);

    getChaptersFromDirectory(file);

    logger.d("Chapters:");
    logger.d(chapters.toString());
  }

  Future<void> getChaptersFromDirectory(FileSystemEntity directory) async {
    // Create a list of file types to check against
    List<String> fileTypes = [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.webp',
      '.bmp',
      '.tiff'
    ];

    // Check if the directory ends with any of the file types
    if (fileTypes
        .any((fileType) => directory.path.toLowerCase().endsWith(fileType))) {
      // If it does, add the parent directory to the chapters list if it's not already there
      if (!chapters.contains(directory.parent.path)) {
        chapters.add(directory.parent.path);
        logger.d("added ${directory.parent.path} to chapters");
      }
    } else {
      // If it doesn't, recursively check the files in the directory
      List<FileSystemEntity> files = [];
      try {
        files = Directory(directory.path).listSync();
        for (var file in files) {
          getChaptersFromDirectory(file);
        }
      } catch (e) {
        logger.d(
          "Error: not a valid directory, its a file",
        );
      }
    }
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
      future: getChapters(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: Text(title),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              actions: [
                audioPlayerWidget(),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            body: FutureBuilder(
              // get progress requires the comicId
              future: getProgress(comicId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return FutureBuilder(
                    future: createPageList(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Column(
                          children: [
                            Expanded(
                              child: PageView.builder(
                                scrollDirection:
                                    direction.toLowerCase() == 'vertical'
                                        ? Axis.vertical
                                        : Axis.horizontal,
                                reverse: direction == 'rtl',
                                // scrollDirection: Axis.vertical,
                                itemCount: pages.length,
                                controller: PageController(
                                  initialPage: pageNum,
                                ),
                                itemBuilder: (context, index) {
                                  return InteractiveViewer(
                                    child: Image.file(
                                      File(pages[index]),
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                },
                                onPageChanged: (index) {
                                  saveProgress(index);
                                  progress = index / pageNums;
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
