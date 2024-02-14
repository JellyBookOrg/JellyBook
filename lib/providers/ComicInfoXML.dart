// the purpose of this file is to parse the ComicInfo.xml file used in comics to store metadata

import 'dart:io';
import 'package:xml/xml.dart' as xml;
import 'package:jellybook/variables.dart';
import 'package:isar/isar.dart';
import 'package:jellybook/models/entry.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> parseXML(Entry entry) async {
  // find the ComicInfo.xml file
  final files = Directory(entry.folderPath).listSync();
  File? xmlFile;
  for (var file in files) {
    if (file.path.toLowerCase().endsWith('comicinfo.xml')) {
      xmlFile = File(file.path);
      break;
    }
  }
  if (xmlFile == null) {
    logger.e('ComicInfo.xml file not found');

    return;
  }
  // confirm that its xs:complexType is ComicInfo
  final xmlFileContent = xml.XmlDocument.parse(xmlFile.readAsStringSync());
  if (xmlFileContent.rootElement.name.toString() != 'ComicInfo') {
    logger.e('ComicInfo.xml file is not of xs:complexType ComicInfo');

    return;
  }

  // add authors
  if (xmlFileContent.findAllElements('Writer').isNotEmpty) {
    final author = xmlFileContent.findAllElements('Writer');
    // add the author
    entry.writer = author.first.innerText;
    logger.d('writer: ${entry.writer}');
  }
  if (xmlFileContent.findAllElements('Penciller').isNotEmpty) {
    final author = xmlFileContent.findAllElements('Penciller');
    // add the author
    entry.penciller = author.first.innerText;
    logger.d('penciller: ${entry.penciller}');
  }
  if (xmlFileContent.findAllElements('Inker').isNotEmpty) {
    final author = xmlFileContent.findAllElements('Inker');
    // add the author
    entry.inker = author.first.innerText;
    logger.d('inker: ${entry.inker}');
  }
  if (xmlFileContent.findAllElements('Colorist').isNotEmpty) {
    final author = xmlFileContent.findAllElements('Colorist');
    // add the author
    entry.colorist = author.first.innerText;
    logger.d('colorist: ${entry.colorist}');
  }
  if (xmlFileContent.findAllElements('Letterer').isNotEmpty) {
    final author = xmlFileContent.findAllElements('Letterer');
    // add the author
    entry.letterer = author.first.innerText;
    logger.d('letterer: ${entry.letterer}');
  }
  if (xmlFileContent.findAllElements('CoverArtist').isNotEmpty) {
    final author = xmlFileContent.findAllElements('CoverArtist');
    // add the author
    entry.coverArtist = author.first.innerText;
    logger.d('coverArtist: ${entry.coverArtist}');
  }
  if (xmlFileContent.findAllElements('Editor').isNotEmpty) {
    final author = xmlFileContent.findAllElements('Editor');
    // add the author
    entry.editor = author.first.innerText;
    logger.d('editor: ${entry.editor}');
  }
  if (xmlFileContent.findAllElements('Publisher').isNotEmpty) {
    final author = xmlFileContent.findAllElements('Publisher');
    // add the author
    entry.publisher = author.first.innerText;
    logger.d('publisher: ${entry.publisher}');
  }
  if (xmlFileContent.findAllElements('Imprint').isNotEmpty) {
    final author = xmlFileContent.findAllElements('Imprint');
    // add the author
    entry.imprint = author.first.innerText;
    logger.d('imprint: ${entry.imprint}');
  }

  // save to database
  final isar = Isar.getInstance();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var useSentry = prefs.getBool('useSentry') ?? false;
  await isar!.writeTxn(() async {
    await isar.entrys.put(entry);
  }).catchError((error, stackTrace) async {
    if (useSentry) await Sentry.captureException(error, stackTrace: stackTrace);
    logger.e(error);
  }).onError((error, stackTrace) {
    if (useSentry) Sentry.captureException(error, stackTrace: stackTrace);
    logger.e(error);
  });
}
