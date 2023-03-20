// the purpose of this file is to show a list of books that the user has started reading and has not finished yet

import 'package:flutter/material.dart';
// import 'package:jellybook/screens/collectionScreen.dart';
import 'package:jellybook/screens/infoScreen.dart';
import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
import 'package:jellybook/models/entry.dart';
import 'package:auto_size_text/auto_size_text.dart';
// import 'package:jellybook/providers/fixRichText.dart';
import 'package:flutter_star/flutter_star.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:logger/logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContinueReadingScreen extends StatefulWidget {
  const ContinueReadingScreen();

  @override
  _ContinueReadingScreenState createState() => _ContinueReadingScreenState();
}

class _ContinueReadingScreenState extends State<ContinueReadingScreen> {
  var isar = Isar.getInstance();
  var logger = Logger();

  // get all the entries that have been started but not finished
  Future<List<Entry>> getEntries() async {
    var entries = await isar!.entrys
        .where()
        .filter()
        .group((q) => q.downloadedEqualTo(true).and().pageNumGreaterThan(0))
        .downloadedEqualTo(true)
        .and()
        .pageNumGreaterThan(0)
        .or()
        .group((q) => q.epubCfiIsNotEmpty().and().downloadedEqualTo(true))
        .findAll();
    // convert the entries to a list
    return entries;
  }

  @override
  void initState() {
    super.initState();
    getEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.continueReading ??
            "Continue Reading"),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                AppLocalizations.of(context)?.continueReading ??
                    "Continue Reading",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // add a divider
          const SizedBox(height: 5),
          Divider(
            height: 10,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[800]
                : Colors.grey[400],
            // color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 5),
          FutureBuilder(
            future: getEntries(),
            builder: (context, snapshot) {
              logger.d("${snapshot.data}");
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data!.isNotEmpty) {
                // logger.d(snapshot.data.toString());
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
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
                              isDownloaded: snapshot.data![index].downloaded,
                            ),
                          ),
                        );
                        setState(() {});
                      },
                      title: AutoSizeText(
                        snapshot.data![index].title,
                        maxLines: 1,
                        style: const TextStyle(
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
                            // if (snapshot.data![index].pageNum != 0)
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: snapshot.data![index].imagePath != "Asset"
                                  ? FancyShimmerImage(
                                      imageUrl: snapshot.data![index].imagePath,
                                      errorWidget: Image.asset(
                                        "assets/images/NoCoverArt.png",
                                        fit: BoxFit.cover,
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      boxFit: BoxFit.fitWidth,
                                    )
                                  : Image.asset(
                                      'assets/images/NoCoverArt.png',
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      fit: BoxFit.fitWidth,
                                    ),
                            ),
                          ),
                          snapshot.data![index].progress != 0
                              ? Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    height: MediaQuery.of(context).size.height *
                                        0.14,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.black.withOpacity(0.5)
                                          : Colors.grey.withOpacity(0.5),
                                      // color: Colors.black.withOpacity(0.5),
                                      borderRadius: const BorderRadius.only(
                                        bottomRight: Radius.circular(5),
                                      ),
                                    ),
                                    child: Center(
                                      child: AutoSizeText(
                                        maxLines: 1,
                                        "${snapshot.data![index].progress.toString().substring(0, snapshot.data![index].progress.toString().length > 4 ? 4 : snapshot.data![index].progress.toString().length)}%",
                                        style: TextStyle(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 20,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                )
                              : snapshot.data![index].pageNum != 0
                                  ? Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.14,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.black.withOpacity(0.5)
                                              : Colors.grey.withOpacity(0.5),
                                          // color: Colors.black.withOpacity(0.5),
                                          borderRadius: const BorderRadius.only(
                                            bottomRight: Radius.circular(5),
                                          ),
                                        ),
                                        child: Center(
                                          child: AutoSizeText(
                                            maxLines: 1,
                                            "${snapshot.data![index].pageNum}p",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 20,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    )
                                  : snapshot.data![index].epubCfi == ""
                                      ? Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.black
                                                      .withOpacity(0.5)
                                                  : Colors.grey
                                                      .withOpacity(0.5),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                bottomRight: Radius.circular(5),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                snapshot.data![index].pageNum
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : const Text(""),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (snapshot.data![index].description.isNotEmpty)
                            AutoSizeText(
                              snapshot.data![index].description,
                              maxLines: 2,
                              style: const TextStyle(
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
                                    " ${snapshot.data![index].rating / 2}/5.0",
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                // return the error in the center of the screen
                return Center(
                  child: Text(
                    snapshot.error.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
                // if its empty, tell the user that there are no entries
              } else if (snapshot.data!.isEmpty) {
                return Center(
                  // add text saying that there are no books/comics that have been started and have a frown under it
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)?.noBooksStarted ??
                            "You have not started any books/comics yet.",
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
