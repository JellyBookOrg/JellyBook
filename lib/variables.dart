/// The purpose of this file is to store all global variables.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jellybook/themes/themeManager.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

// get the ApplicationDocumentsDirectory path

late String localPath;

Logger logger = Logger(
  output: kDebugMode == true
      ? ConsoleOutput()
      : FileOutput(
          file: File("/storage/emulated/0/Documents/jellybook.log"),
          overrideExisting: true,
          encoding: utf8,
          sink: IOSink(File("/storage/emulated/0/Documents/jellybook.log")
              .openWrite(mode: FileMode.writeOnlyAppend, encoding: utf8)),
        ),
  level: Level.debug,
  printer: kDebugMode == true
      ? PrettyPrinter()
      : PrettyPrinter(
          methodCount: 5,
          errorMethodCount: 8,
          lineLength: 120,
          colors: false,
          printEmojis: true,
          printTime: true,
        ),
);

// class FileOutput extends LogOutput {
//   FileOutput({
//     required this.file,
//   });
//
//   File file;
//
//   @override
//   void init() {
//     super.init();
//     if (!file.existsSync()) {
//       file.createSync();
//     }
//   }
//
//   @override
//   void output(OutputEvent event) async {
//     print(event.lines);
//     for (var line in event.lines) {
//       await file.writeAsString("${line.toString()}\n",
//           mode: FileMode.writeOnlyAppend);
//     }
//   }
// }

class FileOutput extends LogOutput {
  final File file;
  final bool overrideExisting;
  final Encoding encoding;
  late IOSink sink;

  FileOutput({
    required this.file,
    this.overrideExisting = false,
    this.encoding = utf8,
    IOSink? sink,
  }) {
    this.sink = sink ??
        file.openWrite(
          mode:
              overrideExisting ? FileMode.writeOnly : FileMode.writeOnlyAppend,
          encoding: encoding,
        );
  }

  // @override
  // void init() {
  //   sink = file.openWrite(
  //     mode: overrideExisting ? FileMode.writeOnly : FileMode.writeOnlyAppend,
  //     encoding: encoding,
  //   );
  // }

  @override
  void output(OutputEvent event) {
    sink.writeAll(event.lines, '\n');
  }

  @override
  Future<void> destroy() async {
    await sink.flush();
    await sink.close();
  }
}
