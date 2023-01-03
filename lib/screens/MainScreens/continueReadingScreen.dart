// the purpose of this file is to show a list of books that the user has started reading and has not finished yet

import 'package:flutter/material.dart';
import 'package:jellybook/screens/collectionScreen.dart';
import 'package:jellybook/screens/infoScreen.dart';
import 'package:isar/isar.dart';
import 'package:jellybook/models/entry.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:jellybook/providers/fixRichText.dart';
import 'package:flutter_star/flutter_star.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

class ContinueReadingScreen extends StatefulWidget {
  @override
  _ContinueReadingScreenState createState() => _ContinueReadingScreenState();
}

class _ContinueReadingScreenState extends State<ContinueReadingScreen> {
  var isar = Isar.getInstance();

  // get all the entries that have been started but not finished
  Future<List<Entry>> getEntries() async {
    var entries = await isar!.entrys
        .where()
        .filter()
        .downloadedEqualTo(true)
        .and()
        .pageNumGreaterThan(0)
        .findAll();
    // convert the entries to a list
    List<Entry> entriesList = [];
    for (int i = 0; i < entries.length; i++) {
      entriesList.add(entries[i]);
    }
    return entriesList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Continue Reading"),
      ),
      body: FutureBuilder(
        future: getEntries(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.length > 0) {
            debugPrint(snapshot.data.toString());
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InfoScreen(
                            year: snapshot.data![index].releaseDate,
                            title: snapshot.data![index].title,
                            path: snapshot.data![index].filePath,
                            stars: snapshot.data![index].rating,
                            comicId: snapshot.data![index].id,
                            url: snapshot.data![index].url,
                            tags: snapshot.data![index].tags,
                            description: snapshot.data![index].description,
                            imageUrl: snapshot.data![index].imagePath,
                            isLiked: snapshot.data![index].isFavorited,
                          ),
                        ),
                      );
                    },
                    title: AutoSizeText(
                      snapshot.data![index].title,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey[900]!.withOpacity(0.5)
                                    : Colors.grey[300]!.withOpacity(0.5),
                                // color: Colors.black.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(2, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: snapshot.data![index].imagePath != "Asset"
                                ? FancyShimmerImage(
                                    imageUrl: snapshot.data![index].imagePath,
                                    errorWidget: Image.asset(
                                      "assets/images/NoCoverArt.png",
                                      fit: BoxFit.cover,
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    boxFit: BoxFit.fitWidth,
                                  )
                                : Image.asset(
                                    'assets/images/NoCoverArt.png',
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    fit: BoxFit.fitWidth,
                                  ),
                          ),
                        ),
                        snapshot.data![index].progress != null &&
                                snapshot.data![index].progress != 0
                            ? Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  height:
                                      MediaQuery.of(context).size.height * 0.14,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.black.withOpacity(0.5)
                                        : Colors.grey.withOpacity(0.5),
                                    // color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(5),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      snapshot.data![index].progress
                                              .toString() +
                                          "%",
                                      style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  height:
                                      MediaQuery.of(context).size.width * 0.14,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.black.withOpacity(0.5)
                                        : Colors.grey.withOpacity(0.5),
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(5),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      snapshot.data![index].pageNum.toString(),
                                      style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (snapshot.data![index].description.isNotEmpty)
                          AutoSizeText(
                            snapshot.data![index].description,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (snapshot.data![index].rating > 0)
                          // prevent the rating from being touched since it can be changed if touched
                          IgnorePointer(
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: CustomRating(
                                    max: 5,
                                    score: snapshot.data![index].rating / 2,
                                    star: Star(
                                      fillColor: Color.lerp(
                                          Colors.red,
                                          Colors.yellow,
                                          snapshot.data![index].rating / 10)!,
                                      emptyColor:
                                          Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.grey[900]!
                                              : Colors.grey[300]!,
                                      // emptyColor: Colors.grey.withOpacity(0.5),
                                    ),
                                    onRating: (double score) {},
                                  ),
                                ),
                                Text(
                                  " " +
                                      (snapshot.data![index].rating / 2)
                                          .toString() +
                                      "/5.0",
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            // return the error in the center of the screen
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
            // if its empty, tell the user that there are no entries
          } else if (snapshot.data!.length == 0) {
            return Center(
              // add text saying that there are no books/comics that have been started and have a frown under it
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No books/comics have been started",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Icon(
                    Icons.sentiment_dissatisfied,
                    size: 100,
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
