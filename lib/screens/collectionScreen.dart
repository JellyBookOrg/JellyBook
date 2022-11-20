// The purpose of this file is to create a list of entries from a selected folder

// import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jellybook/models/folder.dart';
import 'package:jellybook/models/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_star/flutter_star.dart';
import 'package:jellybook/screens/infoScreen.dart';

class collectionScreen extends StatelessWidget {
  final String folderId;
  final String name;
  final String image;
  final List<String> bookIds;

  collectionScreen({
    required this.folderId,
    required this.name,
    required this.image,
    required this.bookIds,
  });

  // make a list of entries from the the list of bookIds
  Future<List<Map<String, dynamic>>> getEntries() async {
    var box = Hive.box<Entry>('bookShelf');
    List<Map<String, dynamic>> entries = [];
    var entryList = box.values.toList();
    debugPrint("bookIds: ${bookIds.length}");
    for (int i = 0; i < bookIds.length; i++) {
      // get the first entry that matches the bookId
      var entry = entryList.firstWhere((element) => element.id == bookIds[i]);
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
      debugPrint("entry: ${entry.id}");
      debugPrint("entry: ${entry.title}");
      debugPrint("entry: ${entry.imagePath}");
      debugPrint("entry: ${entry.rating}");
      debugPrint("entry: ${entry.type}");
      debugPrint("entry: ${entry.description}");
      debugPrint("entry: ${entry.path}");
      debugPrint("entry: ${entry.tags}");
      debugPrint("entry: ${entry.url}");
    }
    return entries;
    // checkeach field of the entry to make sure it is not null
  }

  // getter for the list of entries calling getEntries()
  Future<List<Map<String, dynamic>>> get entries async {
    return await getEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: FutureBuilder(
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
                    if (snapshot.data[index]['type'] == 'book' ||
                        snapshot.data[index]['type'] == 'comic') {
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
                            description: snapshot.data[index]['description'],
                            path: snapshot.data[index]['type'],
                            year: snapshot.data[index]['year'],
                            url: snapshot.data[index]['url'],
                            tags: snapshot.data[index]['tags'],
                          ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = Offset(1.0, 0.0);
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
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = Offset(1.0, 0.0);
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
                  title: Text(snapshot.data[index]['title']),
                  leading: Image.network(snapshot.data[index]['imagePath']),
                  // have the subitle be the rating
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (snapshot.data[index]['rating'] >= 0)
                        // allign the stars to the very left of the row
                        Row(
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
                                            snapshot.data[index]['rating'] /
                                                10)!,
                                        emptyColor:
                                            Colors.grey.withOpacity(0.5),
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
                                  // add a padding for 80% of the screen width
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        0,
                                        0,
                                        MediaQuery.of(context).size.width *
                                            0.29,
                                        0),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      // if the rating is less than 0 and the description is not empty
                      // then display the first 50 characters of the description
                      if (snapshot.data[index]['rating'] < 0 &&
                          snapshot.data[index]['description'] != '')
                        Text(
                          snapshot.data[index]['description'].length > 50
                              ? snapshot.data[index]['description']
                                      .substring(0, 42) +
                                  "..."
                              : snapshot.data[index]['description'],
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 15,
                          ),
                        ),
                    ],
                  ),
                );

                // subtitle: snapshot.data[index]['rating'] != null
                //     ? Row(
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           for (int i = 0;
                //               i < snapshot.data[index]['rating'];
                //               i++)
                //             Icon(
                //               Icons.star,
                //               color: Colors.yellow,
                //             ),
                //         ],
                //       )
                //     : null,
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
    // return FutureBuilder(
    //   // wait until the list of entries is created before building the screen
    //   future: getEntries(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       debugPrint("snapshot: ${snapshot.data}");
    //       return Scaffold(
    //         appBar: AppBar(
    //           title: Text(name),
    //           backgroundColor: Colors.blueGrey[900],
    //         ),
    //         body: Container(
    //           child: ListView.builder(
    //             itemCount: snapshot.data!.length,
    //             itemBuilder: (context, index) {
    //               // have the image, title, and rating
    //               return Container(
    //                 child: ListTile(
    //                   leading: Image.network(
    //                     snapshot.data![index]['imagePath'],
    //                     width: 100,
    //                     height: 100,
    //                     fit: BoxFit.cover,
    //                   ),
    //                   title: Text(snapshot.data![index]['title']),
    //                 ),
    //               );
    //             },
    //           ),
    //         ),
    //       );
    //     } else {
    //       return Scaffold(
    //         appBar: AppBar(
    //           title: Text('Loading'),
    //           backgroundColor: Colors.blueGrey[900],
    //         ),
    //         body: Container(
    //           child: Center(
    //             child: CircularProgressIndicator(),
    //           ),
    //         ),
    //       );
    //     }
    //   },
    // );
  }
}
