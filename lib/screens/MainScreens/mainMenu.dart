// The purpose of this file is to create the main menu screen (this is part of the list of screens in the bottom navigation bar)
import 'package:flutter/material.dart';
import 'package:jellybook/models/folder.dart';
import 'package:jellybook/providers/fetchCategories.dart';
import 'package:jellybook/screens/collectionScreen.dart';
import 'package:jellybook/screens/infoScreen.dart';
import 'package:jellybook/screens/loginScreen.dart';
import 'package:jellybook/screens/MainScreens/searchScreen.dart';
import 'package:jellybook/models/login.dart';
import 'package:jellybook/screens/offlineBookReader.dart';
import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
import 'package:jellybook/models/entry.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jellybook/variables.dart';
import 'package:jellybook/widgets/roundedImageWithShadow.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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
  static const _pageSize = 20;
  final PagingController<int, Entry> _pagingController =
      PagingController(firstPageKey: 0);
  Future<void> logout() async {
    final isar = Isar.getInstance();
    List<Login> logins = await isar!.logins.where().findAll();
    List<int> loginIds = logins.map((e) => e.isarId).toList();
    List<Entry> entries = await isar.entrys.where().findAll();
    List<int> entryIds = entries.map((e) => e.isarId).toList();
    List<Folder> folders = await isar.folders.where().findAll();
    List<int> folderIds = folders.map((e) => e.isarId).toList();
    await isar.writeTxn(() async {
      logger.i('deleted ${loginIds.length} logins');
      isar.logins.deleteAll(loginIds);
      logger.i('deleted ${entryIds.length} entries');
      isar.entrys.deleteAll(entryIds);
      logger.i('deleted ${folderIds.length} folders');
      isar.folders.deleteAll(folderIds);
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  bool force = false;

  int _selectedIndex = 0;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      logger.i('pageKey: $pageKey');
      // fetchEntries(pageKey);
    });
    super.initState();
    // fetchCategories();
  }

  // dispose
  @override
  void dispose() {
    super.dispose();
  }

// should be a futureBuilder
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          // icon: const Icon(Icons.home),
          icon: const Icon(Icons.refresh_rounded),
          tooltip: AppLocalizations.of(context)?.refresh ?? 'Refresh',
          onPressed: () {
            setState(
              () {
                force = true;
              },
            );
          },
        ),
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
              child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(),
                ),
              );
            },
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                const SizedBox(width: 10),
                Text(
                  (AppLocalizations.of(context)?.search ?? 'Search') + '…',
                  style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          )),
        ),
        // title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: () {
              logout();
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 10),
          FutureBuilder(
            future: getServerCategories(force: force),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data != null) {
                  List<Widget> collectionChildren = [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          AppLocalizations.of(context)?.collections ??
                              "Collections",
                          style: const TextStyle(
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
                        itemExtent: MediaQuery.of(context).size.width / 3,
                        itemBuilder: (context, index) {
                          return SizedBox(
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
                                        folderId: snapshot.data.$2
                                            .elementAt(index)
                                            .id,
                                        name: snapshot.data.$2
                                            .elementAt(index)
                                            .name,
                                        image: snapshot.data.$2
                                            .elementAt(index)
                                            .image,
                                        bookIds: snapshot.data.$2
                                            .elementAt(index)
                                            .bookIds,
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
                                        snapshot.data.$2.elementAt(index).name,
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
                                        child: RoundedImageWithShadow(
                                          imageUrl: snapshot.data.$2
                                                  .elementAt(index)
                                                  .image ??
                                              'Asset',
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
                      // cacheExtent: 30,
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
                                    logger.i("tapped");
                                    // logger.i(snapshot.data.$1.elementAt(index));
                                    int selectedIndex =
                                        index; // Store the index of the selected entry
                                    Entry selectedEntry = snapshot.data.$1
                                        .elementAt(selectedIndex);

                                    Entry? updatedEntry = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            InfoScreen(entry: selectedEntry),
                                      ),
                                    );
                                    // update state of the card
                                    if (updatedEntry != null) {
                                      // Update the state of the card
                                      setState(() {
                                        // Check if snapshot.data.$1 is a list that can be modified
                                        if (snapshot.data.$1 is List<Entry>) {
                                          snapshot.data.$1[selectedIndex] =
                                              updatedEntry;
                                        } else {
                                          // If the list is immutable, create a new list with the updated entry
                                          var newList = List<Entry>.from(
                                              snapshot.data.$1);
                                          newList[selectedIndex] = updatedEntry;
                                          // Update the data source
                                          snapshot.data.$1 = newList;
                                        }
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
                                            // height should be 80% of the card
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                6 *
                                                0.8,
                                            child: RoundedImageWithShadow(
                                              imageUrl: snapshot.data.$1
                                                      .elementAt(index)
                                                      .imagePath ??
                                                  'Asset',
                                            ),
                                          ),
                                          if (snapshot.data.$1
                                                  .elementAt(index)
                                                  .isFavorited ==
                                              true)
                                            // icon in circle in bottom $2 corner
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
                                            snapshot.data.$1?[index].title ??
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

                                      if (snapshot.data.$1
                                              .elementAt(index)
                                              .releaseDate !=
                                          "null")
                                        Flexible(
                                          // give some padding to the text
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: AutoSizeText(
                                              snapshot.data.$1
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
                          snapshot.data.$2 != null)
                        ...collectionChildren,
                      if (snapshot.data.$1.toString().isNotEmpty)
                        ...libraryChildren,
                      // const SizedBox(
                      //   height: 10,
                      // ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  logger.e("Error: ${snapshot.error!}");
                  logger.e("Stack Trace: ${snapshot.stackTrace}");
                  return Center(
                    // return error message if there is an error
                    child: Text(
                      (AppLocalizations.of(context)?.error ?? "Error") +
                          ": " +
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
                    Text(
                      AppLocalizations.of(context)?.waitToFetchDB ??
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
