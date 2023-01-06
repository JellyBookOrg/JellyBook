// the goal of this file is to create a screen that displays information about the selected book/comic

import 'package:flutter/material.dart';
import 'package:flutter_star/flutter_star.dart';
import 'package:jellybook/providers/deleteComic.dart';
import 'package:jellybook/providers/fixRichText.dart';
import 'package:jellybook/screens/downloaderScreen.dart';
import 'package:jellybook/screens/readingScreen.dart';
import 'package:like_button/like_button.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:jellybook/providers/updateLike.dart';
import 'package:isar/isar.dart';
import 'package:jellybook/models/entry.dart';
import 'package:logger/logger.dart';

class InfoScreen extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String url;
  final String description;
  final List<dynamic> tags;
  final String year;
  final double stars;
  final String comicId;
  final String path;
  bool isLiked;

  InfoScreen(
      {required this.title,
      required this.imageUrl,
      required this.description,
      required this.tags,
      required this.url,
      required this.comicId,
      required this.stars,
      required this.path,
      required this.year,
      required this.isLiked});

  var logger = Logger();

// check if it is liked or not by checking the database
  Future<bool> checkLiked(String id) async {
    final isar = Isar.getInstance();
    final entries = await isar!.entrys.where().idEqualTo(id).findFirst();
    return entries!.isFavorited;
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    await updateLike(comicId);
    return !isLiked;
  }

  // init
  @override
  void initState() {
    checkLiked(comicId).then((value) {
      isLiked = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // update the page so that the liked comics are at the top
            Navigator.pop(context);
          },
        ),
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              deleteComic(comicId, context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .shadowColor
                                  .withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(2, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: imageUrl.isNotEmpty && imageUrl != "Asset"
                              ? FancyShimmerImage(
                                  imageUrl: imageUrl,
                                  boxFit: BoxFit.cover,
                                  errorWidget: Image.asset(
                                    "assets/images/NoCoverArt.png",
                                    width: MediaQuery.of(context).size.width /
                                        4 *
                                        0.8,
                                    fit: BoxFit.cover,
                                  ),
                                  width: MediaQuery.of(context).size.width /
                                      4 *
                                      0.8,
                                )
                              : Image.asset(
                                  'assets/images/NoCoverArt.png',
                                  width: MediaQuery.of(context).size.width /
                                      4 *
                                      0.8,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      // create the title
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (stars >= 0)
                            IgnorePointer(
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: CustomRating(
                                      max: 5,
                                      score: stars / 2,
                                      star: Star(
                                        fillColor: Color.lerp(Colors.red,
                                            Colors.yellow, stars / 10)!,
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
                                      "${(stars / 2).toStringAsFixed(2)} / 5.00",
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReadingScreen(
                                    title: title,
                                    comicId: comicId,
                                  ),
                                ),
                              );
                            },
                            child: const Icon(Icons.play_arrow),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(milliseconds: 500),
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      DownloadScreen(
                                    // title: title,
                                    comicId: comicId,
                                    // path: path,
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
                            },
                            icon: const Icon(Icons.download),
                          ),
                          // check if the comic is liked
                          FutureBuilder(
                            future: checkLiked(comicId),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                isLiked = snapshot.data as bool;
                                logger.i("isLiked: $isLiked");
                                return LikeButton(
                                  isLiked: isLiked,
                                  circleColor: const CircleColor(
                                    start: Colors.red,
                                    end: Colors.redAccent,
                                  ),
                                  bubblesColor: const BubblesColor(
                                    dotPrimaryColor: Colors.green,
                                    dotSecondaryColor: Colors.red,
                                  ),
                                  likeBuilder: (bool isLiked) {
                                    return Icon(
                                      Icons.favorite,
                                      color:
                                          isLiked ? Colors.red : Colors.white,
                                    );
                                  },
                                  onTap: (bool isLiked) async {
                                    updateLike(comicId);
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   const SnackBar(
                                    //     content: Text(
                                    //         "This feature is not available yet",
                                    //         style: TextStyle(
                                    //           color: Colors.white,
                                    //         )),
                                    //     backgroundColor: Colors.black,
                                    //   ),
                                    // );
                                    return !isLiked;
                                  },
                                );
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: RichText(
                text: TextSpan(
                  text: "\t\t\t" + fixRichText(description),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tags.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(5),
                    child: Chip(
                      label: Text(tags[index]),
                    ),
                  );
                },
              ),
            ),
            // make the year at the very bottom of the screen
            if (year != "null")
              Container(
                padding: const EdgeInsets.all(5),
                // use auto size text to make the text responsive
                child: Text(
                  year,
                  // autosize the text
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
