// The purpose of this file is to define the model for the folders that will house collections of books/compics

import 'package:isar/isar.dart';

part 'folder.g.dart';

// Folder should have a name, a image, and a list of book ids
@Collection()
class Folder {
  Id isarId = Isar.autoIncrement;

  @Index()
  String name;
  String id;
  String image = '';
  List<String> bookIds = [''];

  // image and bookIds are optional
  Folder({
    required this.name,
    required this.id,
    this.image = '',
    this.bookIds = const [''],
  });
}
