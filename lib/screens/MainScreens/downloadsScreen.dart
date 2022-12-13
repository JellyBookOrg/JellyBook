// The purpose of this file is to have a screen with all the downloaded books with easy access to delete them

import 'package:flutter/material.dart';
import 'package:jellybook/screens/collectionScreen.dart';
import 'package:jellybook/screens/infoScreen.dart';
import 'package:isar/isar.dart';
import 'package:jellybook/models/entry.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:jellybook/providers/fixRichText.dart';
import 'package:flutter_star/flutter_star.dart';

class DownloadsScreen extends StatefulWidget {
  @override
  _DownloadsScreenState createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  Future<List<Map<String, dynamic>>> getEntries() async {
    final isar = Isar.getInstance();
    // final isar = Isar.openSync([EntrySchema]);
    List<Map<String, dynamic>> entries = [];
    // get the entries from the database
    final entryList =
        await isar!.entrys.where().filter().downloadedEqualTo(true).findAll();
    // get the length of the list
    final length = entryList.length;
    // var entryList = box.values.toList();
    debugPrint("bookIds: $length");
    for (int i = 0; i < length; i++) {
      // get the first entry that matches the bookId
      // convert element.id to int
      var entry = entryList.firstWhere((element) => int.parse(element.id) == i);
      entries.add({
        'id': entry.id,
        'title': entry.title,
        'imagePath': entry.imagePath != ''
            ? entry.imagePath
            : 'https://via.placeholder.com/200x316?text=No+Image',
        'rating': entry.rating,
        'description': entry.description,
        'path': entry.path,
        'year': entry.releaseDate,
        'type': entry.type,
        'tags': entry.tags,
        'url': entry.url,
      });
    }
    return entries;
  }

  Future<List<Map<String, dynamic>>> get entries async {
    return await getEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "Downloads",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // add a divider
          const SizedBox(height: 5),
          Divider(height: 10, color: Colors.grey[400]),
          const SizedBox(height: 5),
          FutureBuilder(
            future: entries,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData &&
                  snapshot.data.length > 0 &&
                  snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        if (snapshot.data[index]['type'] != 'Folder') {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      InfoScreen(
                                comicId: snapshot.data[index]['id'],
                                title: snapshot.data[index]['title'],
                                imageUrl: snapshot.data[index]['imagePath'],
                                stars: snapshot.data[index]['rating'],
                                description: snapshot.data[index]
                                    ['description'],
                                path: snapshot.data[index]['type'],
                                year: snapshot.data[index]['year'],
                                url: snapshot.data[index]['url'],
                                tags: snapshot.data[index]['tags'],
                              ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                var begin = const Offset(1.0, 0.0);
                                var end = Offset.zero;
                                var curve = Curves.ease;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));

                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ),
                          );
                        } else if (snapshot.data[index]['type'] == 'folder') {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      collectionScreen(
                                folderId: snapshot.data[index]['id'],
                                name: snapshot.data[index]['title'],
                                image: snapshot.data[index]['imagePath'],
                                bookIds: snapshot.data[index]['bookIds'],
                              ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                var begin = const Offset(1.0, 0.0);
                                var end = Offset.zero;
                                var curve = Curves.ease;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));

                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ),
                          );
                        }
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Delete"),
                                content: const Text(
                                    "Are you sure you want to delete this book/comic?"),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text("Delete"),
                                    onPressed: () {
                                      final isar = Isar.getInstance();
                                      var entry = isar!.entrys
                                          .where()
                                          .idEqualTo(snapshot.data[index]['id'])
                                          .findFirstSync();
                                      isar.entrys.delete(entry!.isarId);
                                      snapshot.data.removeAt(index);
                                      setState(() {});
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          final isar = Isar.getInstance();
                          isar!.entrys.delete(snapshot.data[index]['id']);
                          // delete the entry from the list
                          setState(() {
                            snapshot.data.removeAt(index);
                          });
                        },
                      ),
                      title: Text(snapshot.data[index]['title']),
                      leading: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(2, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            snapshot.data[index]['imagePath'],
                            width: MediaQuery.of(context).size.width * 0.1,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (snapshot.data[index]['rating'] >= 0)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: CustomRating(
                                    max: 5,
                                    score: snapshot.data[index]['rating'] / 2,
                                    star: Star(
                                      fillColor: Color.lerp(
                                          Colors.red,
                                          Colors.yellow,
                                          snapshot.data[index]['rating'] / 10)!,
                                      emptyColor: Colors.grey.withOpacity(0.5),
                                    ),
                                    onRating: (double score) {},
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                  child: Text(
                                    "${(snapshot.data[index]['rating'] / 2).toStringAsFixed(2)} / 5.00",
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (snapshot.data[index]['rating'] < 0 &&
                              snapshot.data[index]['description'] != '')
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  text: fixRichText(
                                      snapshot.data[index]['description']),
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              } else if (snapshot.hasData &&
                  snapshot.data.length == 0 &&
                  snapshot.connectionState == ConnectionState.done) {
                // due to this being inside a Column, just using a Center widget doesn't work
                return Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "No books were found to be downloaded",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Icon(Icons.sentiment_dissatisfied, size: 100),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "An error has occured",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Icon(Icons.sentiment_dissatisfied, size: 100),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
