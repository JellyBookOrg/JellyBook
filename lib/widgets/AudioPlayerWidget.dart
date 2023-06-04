// The purpose of this file is to provide a audio player for the user to listen to the audiobook they have downloaded (whilst reading the book)

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
import 'package:jellybook/models/entry.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jellybook/variables.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioPath;
  bool isPlaying;
  double progress;
  final Function() onAudioPickerPressed;

  AudioPlayerWidget({
    required this.audioPath,
    required this.isPlaying,
    required this.progress,
    required this.onAudioPickerPressed,
  });

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  Duration audioPosition = Duration();
  AudioPlayer audioPlayer = AudioPlayer();
  String audioId = '';

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void onPlayPausePressed() async {
    if (widget.isPlaying) {
      await pauseAudio();
    } else {
      await playAudio(widget.audioPath, audioPosition);
    }
  }

  void onSliderChanged(double value) {
    setState(() {
      widget.progress = value;
    });
  }

  void onSliderChangeEnd(double value) async {
    await audioPlayer.seek(Duration(seconds: value.toInt()));
    await audioPlayer.resume();
  }

  Future<void> playAudio(String audioPath, Duration position) async {
    logger.d('audioPath: $audioPath');
    await audioPlayer.play(DeviceFileSource(audioPath), position: position);
    await audioPlayer.seek(position);
    FlutterBackgroundService().invoke("setAsForeground");
    setState(() {
      widget.isPlaying = true;
    });

    audioPlayer.onPositionChanged.listen((Duration newPosition) {
      setState(() {
        audioPosition = newPosition;
      });
    });
  }

  Future<void> pauseAudio() async {
    await savePosition();
    await audioPlayer.pause();
    FlutterBackgroundService().invoke("setAsBackground");
    setState(() {
      widget.isPlaying = false;
    });
  }

  Future<void> stopAudio() async {
    await savePosition();
    await audioPlayer.stop();
    FlutterBackgroundService().invoke("setAsBackground");
    setState(() {
      widget.isPlaying = false;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin on top and bottom
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(80),
        border: Border.all(
          color: Theme.of(context).secondaryHeaderColor,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              widget.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
            onPressed: onPlayPausePressed,
          ),
          Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            width: MediaQuery.of(context).size.width * 0.3,
            child: Slider(
              value: widget.progress,
              onChanged: onSliderChanged,
              onChangeEnd: onSliderChangeEnd,
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.audiotrack),
            onPressed: widget.onAudioPickerPressed,
          ),
        ],
      ),
    );
  }
}
