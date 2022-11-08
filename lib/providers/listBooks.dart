// The purpose of this file is to return a list of books/comics from the database to be displayed in the app

// import 'package:objectbox/objectbox.dart';
import 'package:jellybook/models/entry.dart';
// import 'package:jellybook/providers/saveEntry.dart';
// import 'package:jellybook/objectbox.g.dart';
import 'package:jellybook/providers/fetchBooks.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<List<Map<String, dynamic>>> listBooks(
    String comicsId, String etag) async {
  // get the path to the database (this is a function in utilities.dart)

  // open the database
  var box = Hive.box<Entry>('bookShelf');

  // get the box that stores the entries
  var entries = box.values.toList();

  // create a list of maps to store the entries
  List<Map<String, dynamic>> books = [];

  await getComics(comicsId, etag);

  // loop through the entries and add them to the list of maps
  for (int i = 0; i < entries.length; i++) {
    books.add({
      'id': entries[i].id,
      'title': entries[i].title,
      'description': entries[i].description,
      'imagePath': entries[i].imagePath,
      'releaseDate': entries[i].releaseDate,
      'downloaded': entries[i].downloaded,
      'path': entries[i].path,
      'url': entries[i].url,
      'tags': entries[i].tags,
      'rating': entries[i].rating,
      'progress': entries[i].progress,
    });
  }

  // return the list of maps
  return books;
}
