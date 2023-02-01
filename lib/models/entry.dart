// The purpose of this file is to define how book/comic entries are stored in the database

import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';

part 'entry.g.dart';

enum EntryType {
  book,
  comic,
  folder,
}

@Collection()
class Entry {
  Id isarId = Isar.autoIncrement;

  @Index()
  String id;
  String title;
  String description;
  String imagePath;
  String releaseDate;
  bool downloaded = false;
  String path;
  String url;
  List<String> tags;
  double rating = -1;
  double progress = 0.0;
  int pageNum = 0;
  String folderPath = "";
  String filePath = "";
  @enumerated
  EntryType type;
  String parentId = "";
  String epubCfi = "";
  bool isFavorited = false;

  Entry({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.releaseDate,
    this.downloaded = false,
    required this.path,
    required this.url,
    required this.tags,
    required this.rating,
    this.progress = 0.0,
    this.pageNum = 0,
    this.folderPath = '',
    this.filePath = '',
    this.type = EntryType.book,
    this.parentId = '',
    this.epubCfi = '',
    this.isFavorited = false,
  });
}
