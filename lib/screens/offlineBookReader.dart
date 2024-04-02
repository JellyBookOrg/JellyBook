// The purpose of this screen is to allow the user to read the book offline

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:jellybook/providers/fetchCategories.dart';
import 'package:jellybook/providers/themeProvider.dart';
import 'package:jellybook/screens/MainScreens/searchScreen.dart';
import 'package:jellybook/screens/collectionScreen.dart';
import 'package:jellybook/screens/loginScreen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:jellybook/screens/infoScreen.dart';
import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
import 'package:jellybook/screens/offlineBookReader.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:jellybook/models/entry.dart';
import 'package:jellybook/models/folder.dart';
import 'package:jellybook/models/login.dart';
import 'package:jellybook/main.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jellybook/providers/languageProvider.dart';
import 'package:jellybook/variables.dart';
import 'package:jellybook/widgets/roundedImageWithShadow.dart';

class OfflineBookReader extends StatefulWidget {
  SharedPreferences prefs;
  OfflineBookReader({Key? key, required this.prefs}) : super(key: key);

  @override
  _OfflineBookReaderState createState() => _OfflineBookReaderState(prefs);
}

class _OfflineBookReaderState extends State<OfflineBookReader> {
  SharedPreferences prefs;
  _OfflineBookReaderState(this.prefs);

  @override
  void initState() {
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> status) {
      // if the user is online
      if (status.contains(ConnectivityResult.wifi) ||
          status.contains(ConnectivityResult.mobile) ||
          status.contains(ConnectivityResult.ethernet)) {
        final isar = Isar.getInstance();
        final login = isar!.logins.where().findFirstSync();
        if (login!.serverUrl.isNotEmpty && login.username.isNotEmpty) {
          final url = login.serverUrl;
          final username = login.username;
          final password = login.password;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MyApp(
                url: url,
                username: username,
                password: password,
                prefs: prefs,
              ),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        }
        // go to the login screen
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // create a listener to see if the user is online or offline
  Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          // icon: const Icon(Icons.home),
          icon: const Icon(Icons.refresh_rounded),
          tooltip: AppLocalizations.of(context)?.refresh ?? "Refresh",
          onPressed: () {
            // refresh the app so that if the user has gone online, the app will show the login screen

            setState(() {
              // restart the app
              // find the ansestor of the context that is a navigator
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => MyApp(prefs: prefs),
                ),
              );
            });
          },
        ),
        title: Text(AppLocalizations.of(context)?.offlineBookReader ??
            "Offline Book Reader"),
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 10),
          FutureBuilder(
            future: getServerCategoriesOffline(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data != null) {
                  logger.i("Snapshot Data");
                  // logger.i("Collections: ${snapshot.data.$1}");
                  List<Widget> collectionChildren = [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          AppLocalizations.of(context)?.collections ??
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
                        itemCount: snapshot.data.$2?.length,
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
                                    MaterialPageRoute(
                                      builder: (context) => collectionScreen(
                                        folderId: snapshot.data.$2[index].id,
                                        name: snapshot.data.$2[index].name,
                                        image: snapshot.data.$2[index].image,
                                        bookIds:
                                            snapshot.data.$2[index].bookIds,
                                      ),
                                    ),
                                  );
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
                                        snapshot.data.$2[index].name,
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
                                          child: RoundedImageWithShadow(
                                            imageUrl:
                                                snapshot.data.$2[index].image,
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
                  ];
                  List<Widget> libraryChildren = [
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          AppLocalizations.of(context)?.library ?? "Library",
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
                    GridView.count(
                      crossAxisCount: 2,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      addAutomaticKeepAlives: true,
                      addSemanticIndexes: true,
                      addRepaintBoundaries: true,
                      cacheExtent: 1000,
                      children: List.generate(
                        snapshot.data.$1.length,
                        (index) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return Card(
                                borderOnForeground: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => InfoScreen(
                                          entry: snapshot.data.$1!
                                              .elementAt(index),
                                          offline: true,
                                        ),
                                      ),
                                    );
                                    // update state of the card
                                    logger.d(result);
                                    if (result != null) {
                                      setState(() {
                                        snapshot.data.$1!
                                            .elementAt(index)
                                            .isFavorited = result.$1;
                                      });
                                    }
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Stack(
                                        children: <Widget>[
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                6 *
                                                0.8,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                5,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
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
                                              child: RoundedImageWithShadow(
                                                imageUrl: snapshot.data.$1!
                                                    .elementAt(index)
                                                    .imagePath,
                                              ),
                                            ),
                                          ),
                                          if (snapshot.data.$1!
                                                  .elementAt(index)
                                                  .isFavorited ==
                                              true)
                                            // icon in circle in bottom right corner
                                            // allow it to be off the image without being cut off
                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.8),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
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
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: AutoSizeText(
                                            snapshot.data.$1
                                                    ?.elementAt(index)
                                                    .title ??
                                                "null",
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

                                      if (snapshot.data.$1!
                                              .elementAt(index)
                                              .releaseDate !=
                                          "null")
                                        Flexible(
                                          // give some padding to the text
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: AutoSizeText(
                                              snapshot.data.$1!
                                                  .elementAt(index)
                                                  .releaseDate,
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
                          );
                        },
                        // itemCount: snapshot.data.$1!.length,
                      ),
                    ),
                  ];
                  return Column(
                    children: [
                      if (snapshot.data.$2.toString().isNotEmpty &&
                          snapshot.data.$2 != null &&
                          snapshot.data.$2.toString() != "[]")
                        ...collectionChildren,
                      if (snapshot.data.$1.toString().isNotEmpty &&
                          snapshot.data.$1 != null &&
                          snapshot.data.$1.toString() != "[]")
                        ...libraryChildren,
                      // check if there is no data to display
                      if (snapshot.data.$1.toString().isEmpty ||
                          snapshot.data.$2 == null ||
                          snapshot.data.$2.toString() == "[]" &&
                              snapshot.data.$1.toString().isEmpty ||
                          snapshot.data.$1 == null ||
                          snapshot.data.$1.toString() == "[]")
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height / 2 - 140,
                            ),
                            const Icon(
                              Icons.wifi_off,
                              size: 75,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            AutoSizeText(
                              AppLocalizations.of(context)?.noContent ??
                                  "I'm sorry but you havent downloaded any content yet.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              maxFontSize: 30,
                              minFontSize: 10,
                              maxLines: 2,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: AutoSizeText(
                                AppLocalizations.of(context)?.noContent2 ??
                                    "If you have not connected to the internet, please connect to the internet and click the refresh button in the top left corner of the screen.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                  height: 1.25,
                                ),
                                maxFontSize: 30,
                                minFontSize: 10,
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  logger.e("Error: ${snapshot.error!}");
                  logger.e("Stack Trace: ${snapshot.stackTrace}");
                  return Center(
                    // return error message if there is an error
                    child: Text(
                      (AppLocalizations.of(context)?.error ?? "Error") +
                          snapshot.error.toString(),
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                      ),
                    ),
                  );
                  // if theres no books in the database, show a message
                } else if (snapshot.data == null) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)?.noBooks ?? "No books found",
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
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2 - 120,
                    ),
                    const Text(
                      "Please wait while we fetch content from the database",
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const CircularProgressIndicator(),
                  ],
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
