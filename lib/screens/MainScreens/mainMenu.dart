// The purpose of this file is to create the main menu screen (this is part of the list of screens in the bottom navigation bar)

import 'package:flutter/material.dart';
import 'package:jellybook/providers/fetchCategories.dart';
import 'package:jellybook/screens/collectionScreen.dart';
import 'package:jellybook/screens/infoScreen.dart';
import 'package:jellybook/screens/loginScreen.dart';
import 'package:jellybook/models/login.dart';
import 'package:isar/isar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:logger/logger.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  /*
           Heres what this should look like:
           - should be a grid view of cards
           - each comic should have its own card
           - the cards should have:
                - a photo
                - the title
                - the release data if known
                - a more info button
                - a progress bar if book has been started
           - At the bottom will be a bar witch will contain the following sections:
                - a library section
                - a search section
                - a settings section
        */

  var logger = Logger();

  Future<void> logout() async {
    final isar = Isar.getInstance();
    var logins = await isar!.logins.where().findAll();
    var loginIds = logins.map((e) => e.isarId).toList();
    await isar.writeTxn(() async {
      isar.logins.deleteAll(loginIds);
      logger.i('deleted ${loginIds.length} logins');
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // fetchCategories();
  }

// should be a futureBuilder
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {},
        ),
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              logout();
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          // text align left side of the column
          FutureBuilder(
            future: getServerCategories(context, returnFolders: true),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data.isNotEmpty) {
                  logger.i("snapshot data: ${snapshot.data}");
                  return Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Collections",
                            style: TextStyle(
                              // size is the size of a title
                              fontSize: 30,
                              // decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 6 * 1.2,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    logger.i("tapped");
                                    await Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            collectionScreen(
                                          folderId: snapshot.data[index]['id'],
                                          name: snapshot.data[index]['name'],
                                          image: snapshot.data[index]['image'],
                                          bookIds: snapshot.data[index]
                                              ['bookIds'],
                                        ),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          var begin = const Offset(1.0, 0.0);
                                          var end = Offset.zero;
                                          var curve = Curves.ease;

                                          var tween = Tween(
                                                  begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));

                                          return SlideTransition(
                                            position: animation.drive(tween),
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                    setState(() {});
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10 *
                                            MediaQuery.of(context).size.height /
                                            1000,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 10 *
                                                MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1000,
                                            right: 10 *
                                                MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1000),
                                        child: AutoSizeText(
                                          snapshot.data[index]['name'],
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          minFontSize: 5,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      // start all images at the same height rather than same offset
                                      SizedBox(
                                        height: 5 *
                                            MediaQuery.of(context).size.height /
                                            1000,
                                      ),
                                      Flexible(
                                        child: SizedBox(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.4),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              // add a shadow to the image
                                              child: snapshot.data[index]
                                                              ['image'] !=
                                                          null &&
                                                      snapshot.data[index]
                                                              ['image'] !=
                                                          "Asset"
                                                  ? FancyShimmerImage(
                                                      imageUrl: snapshot
                                                          .data[index]['image'],
                                                      errorWidget: Image.asset(
                                                          'assets/images/placeholder.png',
                                                          fit: BoxFit.cover),
                                                      boxFit: BoxFit.cover,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              5,
                                                    )
                                                  : Image.asset(
                                                      "assets/images/NoCoverArt.png",
                                                      fit: BoxFit.fitWidth,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // page break
                      const Divider(
                        height: 5,
                        thickness: 5,
                        indent: 0,
                        endIndent: 0,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              } else {
                return SizedBox(
                  height: 100,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
          // text align left side of the column
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "Library",
                style: TextStyle(
                  // size is the size of a title
                  fontSize: 30,
                  // decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          // vertical list of books
          FutureBuilder(
            future: getServerCategories(context,
                returnFolders: false, likedFirst: true),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    ),
                    itemBuilder: (context, index) {
                      return Card(
                        borderOnForeground: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        InfoScreen(
                                  title:
                                      snapshot.data![index]['name'] ?? "null",
                                  imageUrl: (snapshot.data![index]
                                          ['imagePath'] ??
                                      "Asset"),
                                  description: snapshot.data![index]
                                          ['description'] ??
                                      "null",
                                  tags:
                                      snapshot.data![index]['tags'] ?? ["null"],
                                  url: snapshot.data![index]['url'] ?? "null",
                                  year: snapshot.data![index]['releaseDate'] ??
                                      "null",
                                  stars: snapshot.data![index]['rating'] ?? -1,
                                  path: snapshot.data![index]['path'] ?? "null",
                                  comicId:
                                      snapshot.data![index]['id'] ?? "null",
                                  isLiked: snapshot.data![index]
                                          ['isFavourited'] ??
                                      false,
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
                            setState(() {});
                          },
                          child: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 10,
                              ),
                              Stack(
                                children: <Widget>[
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        6 *
                                        0.8,
                                    width:
                                        MediaQuery.of(context).size.width / 5,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .shadowColor
                                                .withOpacity(0.4),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: snapshot.data![index]
                                                        ['imagePath'] !=
                                                    null &&
                                                snapshot.data![index]
                                                        ['imagePath'] !=
                                                    "Asset"
                                            ? FancyShimmerImage(
                                                imageUrl: snapshot.data[index]
                                                    ['imagePath'],
                                                errorWidget: Image.asset(
                                                  "assets/images/NoCoverArt.png",
                                                  fit: BoxFit.fitWidth,
                                                ),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    5,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    5,
                                                boxFit: BoxFit.fitHeight,
                                              )
                                            : Image.asset(
                                                "assets/images/NoCoverArt.png",
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    6 *
                                                    0.8,
                                                fit: BoxFit.fitWidth,
                                              ),
                                      ),
                                    ),
                                  ),
                                  if (snapshot.data![index]['isFavorited'] ==
                                      true)
                                    // icon in circle in top right corner
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.8),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              // auto size text to fit the width of the card (max 2 lines)

                              Expanded(
                                flex: 3,
                                // give some padding to the text
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: AutoSizeText(
                                    snapshot.data?[index]['name'] ?? "null",
                                    maxLines: 3,
                                    minFontSize: 10,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),

                              if (snapshot.data![index]['releaseDate'] !=
                                  "null")
                                Flexible(
                                  // give some padding to the text
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: AutoSizeText(
                                      snapshot.data![index]['releaseDate'],
                                      maxLines: 1,
                                      minFontSize: 10,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: snapshot.data!.length,
                  );
                } else if (snapshot.hasError) {
                  logger.e("Error: ${snapshot.error}");
                  return Center(
                    // return error message if there is an error
                    child: Text(
                      "Error" + snapshot.error.toString(),
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                      ),
                    ),
                  );
                  // if theres no books in the database, show a message
                } else if (snapshot.data == null) {
                  return const Center(
                    child: Text(
                      "No books found",
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                } else {
                  return const SizedBox(
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              } else {
                // center both horizontally and vertically (the whole screen)

                return const Center(
                  child: SizedBox(
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
