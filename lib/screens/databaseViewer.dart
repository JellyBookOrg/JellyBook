// The purpose of this file is to display the database in a table format for debugging purposes

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jellybook/models/entry.dart';

class DatabaseViewer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Database Viewer'),
        // button to delete all entries
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // confirm deletion
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Delete All Entries?'),
                    content: Text('This action cannot be undone.'),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Delete'),
                        onPressed: () {
                          // delete all entries
                          deleteAllEntries(context);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Entry>('bookShelf').listenable(),
        builder: (context, Box box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Text('No entries'),
            );
          } else {
            // return a scrollable list of the entries where each entry is a row can be tapped to view the entry
            // make scrollable
            return Scrollbar(
              child: ListView.builder(
                itemCount: box.values.length,
                itemBuilder: (context, index) {
                  final entry = box.getAt(index);
                  return ListTile(
                    title: Text(entry.title),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EntryViewer(entry: entry),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class EntryViewer extends StatelessWidget {
  final Entry entry;

  EntryViewer({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(entry.title),
      ),
      // display body as table
      // make scrollable
      body: Scrollbar(
        child: ListView(
          children: [
            Table(
              defaultColumnWidth: FixedColumnWidth(150.0),
              border: TableBorder.all(
                  color: Colors.white, style: BorderStyle.solid, width: 1),
              children: [
                TableRow(children: [
                  Text('Title', textAlign: TextAlign.center),
                  Text(entry.title),
                ]),
                TableRow(children: [
                  Text('ID', textAlign: TextAlign.center),
                  Text(entry.id),
                ]),
                TableRow(children: [
                  Text('Description', textAlign: TextAlign.center),
                  Text(entry.description),
                ]),
                TableRow(children: [
                  Text('Image', textAlign: TextAlign.center),
                  Text(entry.imagePath),
                ]),
                TableRow(children: [
                  Text('Release Date', textAlign: TextAlign.center),
                  Text(entry.releaseDate),
                ]),
                TableRow(children: [
                  Text('Downloaded', textAlign: TextAlign.center),
                  Text(entry.downloaded.toString()),
                ]),
                TableRow(children: [
                  Text('URL', textAlign: TextAlign.center),
                  Text(entry.url),
                ]),
                TableRow(children: [
                  Text('Tags', textAlign: TextAlign.center),
                  Text(entry.tags.toString()),
                ]),
                TableRow(children: [
                  Text('Rating', textAlign: TextAlign.center),
                  Text(entry.rating.toString()),
                ]),
                TableRow(children: [
                  Text('Progress', textAlign: TextAlign.center),
                  Text(entry.progress.toString() + "%"),
                ]),
                TableRow(children: [
                  Text('PageNumber', textAlign: TextAlign.center),
                  Text(entry.pageNum.toString()),
                ]),
                TableRow(children: [
                  Text('Folder Path', textAlign: TextAlign.center),
                  Text(entry.folderPath),
                ]),
                TableRow(children: [
                  Text('File Path', textAlign: TextAlign.center),
                  Text(entry.path),
                ]),
                TableRow(children: [
                  Text('File Type', textAlign: TextAlign.center),
                  Text(entry.type),
                ]),
              ],
              // end of table
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> deleteAllEntries(BuildContext context) async {
  // delete all entries
  final box = Hive.box<Entry>('bookShelf');
  await box.clear();
  // refresh the database viewer
}
