// The purpose of this file is to define how book/comic entries are stored in the database

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'entry.g.dart';

@HiveType(typeId: 0)
class Entry extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String description;

  @HiveField(3)
  late String imagePath;

  @HiveField(4)
  late String releaseDate;

  @HiveField(5)
  late bool downloaded = false;

  @HiveField(6)
  late String path;

  @HiveField(7)
  late String url;

  @HiveField(8)
  late List<dynamic> tags;

  @HiveField(9)
  late double rating;

  // the progress of the book/comic
  late double progress = 0.0;
  late int pageNum = 0;

  // folder path
  late String folderPath = '';

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
  });

  void _requireInitialized() {
    // await Hive.initFlutter();
    Hive.openBox('bookShelf');
  }

  Future<void> save() async {
    _requireInitialized();
    final box = await Hive.openBox<Entry>('bookShelf');
    await box.put(id, this);
  }

  Future<void> delete() async {
    _requireInitialized();
    final box = await Hive.openBox<Entry>('bookShelf');
    await box.delete(id);
  }
}
