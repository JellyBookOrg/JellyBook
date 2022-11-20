// The purpose of this file is to define the model for the folders that will house collections of books/compics

import 'package:hive_flutter/hive_flutter.dart';

part 'folder.g.dart';

// Folder should have a name, a image, and a list of book ids
@HiveType(typeId: 1)
class Folder {
  @HiveField(0)
  String name;

  @HiveField(1)
  String id;

  @HiveField(2)
  String image = '';

  @HiveField(3)
  List<String> bookIds = [''];

  // image and bookIds are optional
  Folder({
    required this.name,
    required this.id,
    this.image = '',
    this.bookIds = const [''],
  });
}
