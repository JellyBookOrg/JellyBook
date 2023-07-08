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
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
import 'package:jellybook/models/entry.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jellybook/variables.dart';
import 'package:jellybook/providers/pair.dart';

class InfoScreen extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String url;
  final String description;
  final String year;
  final double stars;
  final String comicId;
  final String path;
  bool isDownloaded;
  bool isLiked;
  bool offline;

  InfoScreen({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.url,
    required this.comicId,
    required this.stars,
    required this.path,
    required this.year,
    required this.isLiked,
    this.offline = false,
    required this.isDownloaded,
  });

  @override
  _InfoScreenState createState() => _InfoScreenState(
        title: title,
        imageUrl: imageUrl,
        description: description,
        url: url,
        comicId: comicId,
        stars: stars,
        path: path,
        year: year,
        isLiked: isLiked,
        offline: offline,
        isDownloaded: isDownloaded,
      );
}

class _InfoScreenState extends State<InfoScreen> {
  final String title;
  final String imageUrl;
  final String url;
  final String description;
  final String year;
  final double stars;
  final String comicId;
  final String path;
  bool isDownloaded;
  bool isLiked;
  bool offline;
  _InfoScreenState({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.url,
    required this.comicId,
    required this.stars,
    required this.path,
    required this.year,
    required this.isLiked,
    this.offline = false,
    required this.isDownloaded,
  });

  Future<List<String>> getTags(String id) async {
    final isar = Isar.getInstance();
    Entry? entries = await isar?.entrys.where().idEqualTo(id).findFirst();
    return entries?.tags ?? ["Error"];
  }

// check if it is liked or not by checking the database
  Future<bool> checkLiked(String id) async {
    final isar = Isar.getInstance();
    final entries = await isar?.entrys.where().idEqualTo(id).findFirst();
    return entries?.isFavorited ?? false;
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    await updateLike(comicId);
    return !isLiked;
  }

  @override
  void initState() {
    super.initState();
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
          onPressed: () async {
            // update the page so that the liked comics are at the top
            bool isLiked = await checkLiked(comicId);
            Navigator.pop(context, Pair(isLiked, isDownloaded));
          },
        ),
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              deleteComic(comicId, context).then((value) {
                isDownloaded = false;
                setState(() {});
              });
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
                  child: SizedBox(
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDownloaded
                                  ? Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .primary
                                  : Colors.grey,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              if (isDownloaded) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReadingScreen(
                                      title: title,
                                      comicId: comicId,
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(AppLocalizations.of(context)
                                            ?.downloadFirst ??
                                        "You need to download the comic first"),
                                  ),
                                );
                              }
                            },
                            child: const Icon(Icons.play_arrow),
                          ),
                          IconButton(
                            icon: !isDownloaded
                                ? Icon(
                                    Icons.download,
                                    size: 22,
                                    color: !offline
                                        ? Theme.of(context).iconTheme.color
                                        : Colors.white,
                                  )
                                : const Icon(
                                    Icons.download_done,
                                    size: 22,
                                    color: Colors.greenAccent,
                                  ),

                            onPressed: () {
                              if (!offline) {
                                // push to the downloader screen and on return check if it returns a value of true and assign that to isDownloaded
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DownloadScreen(
                                      comicId: comicId,
                                    ),
                                  ),
                                ).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      isDownloaded = value;
                                    });
                                  }
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        AppLocalizations.of(context)
                                                ?.downloadOffline ??
                                            "You are offline, please connect to the internet & reload this app to download this comic",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.color ??
                                                Colors.white)),
                                    backgroundColor:
                                        Theme.of(context).dialogBackgroundColor,
                                    duration: const Duration(seconds: 5),
                                  ),
                                );
                              }
                            },
                            // icon: const Icon(Icons.download),
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
                                      color: isLiked
                                          ? Colors.red
                                          : Theme.of(context).iconTheme.color ??
                                              Colors.white,
                                    );
                                  },
                                  onTap: (bool isLiked) async {
                                    updateLike(comicId);
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
              child: MarkdownBody(
                data: fixRichText(description),
                selectable: false,
                shrinkWrap: true,
                styleSheet:
                    MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                  p: const TextStyle(
                    inherit: true,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                  pPadding: const EdgeInsets.all(5),
                  blockSpacing: 10,
                  code: const TextStyle(
                    inherit: true,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
              ),
              // child: RichText(
              //   text: TextSpan(
              //     text: "\t\t\t${fixRichText(description)}",
              //     style: const TextStyle(
              //       fontSize: 14,
              //       color: Colors.grey,
              //       fontStyle: FontStyle.italic,
              //       height: 1.5,
              //     ),
              //   ),
              // ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              child: FutureBuilder(
                future: getTags(comicId),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(5),
                          child: Chip(
                            label: Text(snapshot.data![index]),
                          ),
                        );
                      },
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
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
