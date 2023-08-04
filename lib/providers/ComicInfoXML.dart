// the purpose of this file is to parse the ComicInfo.xml file used in comics to store metadata

import 'dart:io';
import 'package:xml/xml.dart' as xml;
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:jellybook/variables.dart';
import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
import 'package:jellybook/models/entry.dart';

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

  Map<int, String> monthMap = {
    1: 'January',
    2: 'Febuary',
    3: 'March',
    4: 'April',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'August',
    9: 'September',
    10: 'October',
    11: 'Novemeber',
    12: 'December',
  };

  logger.d('xmlFileContent: $xmlFileContent');
  // add the release date
  if (xmlFileContent.findAllElements('Month').isNotEmpty &&
      xmlFileContent.findAllElements('Year').isNotEmpty) {
    String? month = xmlFileContent.findAllElements('Month').first.text;
    final year = xmlFileContent.findAllElements('Year').first.text;
    final monthInt = int.parse(month);
    final monthString = monthMap[monthInt];
    String releaseDate = '';
    if (monthString != null) {
      releaseDate = '$monthString $year';
    } else {
      releaseDate = year;
    }
    entry.releaseDate = releaseDate;
  }
  logger.d('releaseDate: ${entry.releaseDate}');

  // add authors
  if (xmlFileContent.findAllElements('Writer').isNotEmpty) {
    final author = xmlFileContent.findAllElements('Writer');
    // add the author
    entry.writer = author.first.text;
  }
  if (xmlFileContent.findAllElements('Penciller').isNotEmpty) {
    final author = xmlFileContent.findAllElements('Penciller');
    // add the author
    entry.penciller = author.first.text;
  }
  if (xmlFileContent.findAllElements('Inker').isNotEmpty) {
    final author = xmlFileContent.findAllElements('Inker');
    // add the author
    entry.inker = author.first.text;
  }
  if (xmlFileContent.findAllElements('Colorist').isNotEmpty) {
    final author = xmlFileContent.findAllElements('Colorist');
    // add the author
    entry.colorist = author.first.text;
  }
  if (xmlFileContent.findAllElements('Letterer').isNotEmpty) {
    final author = xmlFileContent.findAllElements('Letterer');
    // add the author
    entry.letterer = author.first.text;
  }
  if (xmlFileContent.findAllElements('CoverArtist').isNotEmpty) {
    final author = xmlFileContent.findAllElements('CoverArtist');
    // add the author
    entry.coverArtist = author.first.text;
  }
  if (xmlFileContent.findAllElements('Editor').isNotEmpty) {
    final author = xmlFileContent.findAllElements('Editor');
    // add the author
    entry.editor = author.first.text;
  }
  if (xmlFileContent.findAllElements('Publisher').isNotEmpty) {
    final author = xmlFileContent.findAllElements('Publisher');
    // add the author
    entry.publisher = author.first.text;
  }
  if (xmlFileContent.findAllElements('Imprint').isNotEmpty) {
    final author = xmlFileContent.findAllElements('Imprint');
    // add the author
    entry.imprint = author.first.text;
  }

  // save to database
  final isar = Isar.getInstance();
  await isar!.writeTxn(() async {
    await isar.entrys.put(entry);
  }).catchError((dynamic error) {
    logger.e(error);
  }).onError((dynamic error, dynamic stackTrace) {
    logger.e(error);
  });
}
