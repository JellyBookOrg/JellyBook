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

  Future<void> _fetchPage(int pageKey) async {
    logger.i('pageKey: $pageKey');
    try {
      const pageSize = 20; // Define your page size
      final result = await fetchEntries(pageKey, pageSize);
      logger.i("result.\$1: ${result.$1}");
      final isLastPage = result.$1 < pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(result.$2);
      } else {
        final nextPageKey = pageKey + result.$1;
        _pagingController.appendPage(result.$2, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
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
      body: FutureBuilder<(List<Entry>, List<Folder>)>(
        future: getServerCategories(force: force),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data != null) {
              // Wrap Column in SliverToBoxAdapter for compatibility
              return CustomScrollView(
                slivers: <Widget>[
                  const SliverToBoxAdapter(child: SizedBox(height: 10)),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              AppLocalizations.of(context)?.collections ??
                                  "Collections",
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
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
                                          builder: (context) =>
                                              collectionScreen(
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
                                              MediaQuery.of(context)
                                                  .size
                                                  .height /
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
                                            snapshot.data.$2
                                                .elementAt(index)
                                                .name,
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
                                              MediaQuery.of(context)
                                                  .size
                                                  .height /
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
                        const Divider(
                          height: 5,
                          thickness: 5,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              AppLocalizations.of(context)?.library ??
                                  "Library",
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
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
                  PagedSliverGrid<int, Entry>(
                    pagingController: _pagingController,
                    addRepaintBoundaries: true,
                    addSemanticIndexes: true,
                    addAutomaticKeepAlives: true,
                    // shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                    ),
                    builderDelegate: PagedChildBuilderDelegate<Entry>(
                        itemBuilder: (context, entry, index) => SizedBox(
                              child: GridEntryWidget(entry),
                            )),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              );
            } else if (snapshot.hasError) {
              // Handle error state
              return SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            } else {
              // Handle null data state
              return const SliverToBoxAdapter(
                child: Center(
                  child: Text("No data found"),
                ),
              );
            }
          } else {
            // Handle loading state
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class GridEntryWidget extends StatefulWidget {
  final Entry entry;

  const GridEntryWidget(this.entry);

  // createState function
  @override
  GridEntryWidgetState createState() => GridEntryWidgetState();
}

class GridEntryWidgetState extends State<GridEntryWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () async {
          logger.i("tapped");
          // logger.i(snapshot.data.$1.elementAt(index));
          Entry? updatedEntry = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InfoScreen(entry: widget.entry),
            ),
          );
          setState(() {
            widget.entry.isFavorited =
                updatedEntry?.isFavorited ?? widget.entry.isFavorited;
          });
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
                  height: MediaQuery.of(context).size.height / 6 * 0.8,
                  child: RoundedImageWithShadow(
                    imageUrl: widget.entry.imagePath ?? 'Asset',
                  ),
                ),
                if (widget.entry.isFavorited == true)
                  // icon in circle in bottom $2 corner
                  // allow it to be off the image without being cut off
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(100),
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
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: AutoSizeText(
                  widget.entry.title,
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

            if (widget.entry.releaseDate != "null")
              Flexible(
                // give some padding to the text
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: AutoSizeText(
                    widget.entry.releaseDate,
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
  }
}
