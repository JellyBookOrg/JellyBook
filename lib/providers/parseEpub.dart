// the purpose of this file is to parse information from an epub file

import 'dart:io';
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:jellybook/variables.dart';
import 'package:xml/xml.dart' as xml;
import 'package:isar/isar.dart';
import 'package:jellybook/models/entry.dart';

Future<void> parseEpub(Entry entry) async {
  List<int> bytes = File(entry.filePath).readAsBytesSync();
  // Extract the contents
  Archive archive = ZipDecoder().decodeBytes(bytes);
  ArchiveFile opfFile = archive.files.firstWhere(
    (file) => file.name.toLowerCase() == 'content.opf',
    orElse: () => archive.files.firstWhere(
      (file) => file.name.toLowerCase() == 'oebps/content.opf',
      orElse: () => throw Exception('No OPF file found in archive'),
    ),
  );
  // get the tags from the opf file
  List<String> tags = [];
  final opfFileContent = xml.XmlDocument.parse(utf8.decode(opfFile.content));
  // get the tags <dc:subject> from the opf file
  final subjects = opfFileContent.findAllElements('dc:subject');
  for (var subject in subjects) {
    tags.add(subject.innerText);
  }

  logger.d("tags: $tags");
  final isar = Isar.getInstance();
  Entry? entry2 = await isar?.entrys.where().idEqualTo(entry.id).findFirst();
  logger.d("entry2 tags: ${entry2!.tags}");
  Set<String> allTags = {...tags, ...entry2.tags};
  logger.d("all tags: $allTags");
  List<String> allTagsList = allTags.toList();
  logger.d("all tags list: $allTagsList");
  entry2.tags = allTagsList;

  await isar!.writeTxn(() async {
    await isar.entrys.put(entry2);
  }).catchError((error) {
    logger.e(error);
  }).onError((error, stackTrace) {
    logger.e(error);
  });
}
