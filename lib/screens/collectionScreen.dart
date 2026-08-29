// The purpose of this file is to create a list of entries from a selected folder

// import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
import 'package:jellybook/models/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_star/flutter_star.dart';
import 'package:jellybook/models/folder.dart';
import 'package:jellybook/screens/infoScreen.dart';
import 'package:jellybook/providers/fixRichText.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jellybook/variables.dart';
import 'package:jellybook/widgets/roundedImageWithShadow.dart';

class collectionScreen extends StatefulWidget {
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

  @override
  _collectionScreenState createState() => _collectionScreenState(
      folderId: folderId, name: name, image: image, bookIds: bookIds);
}

class _collectionScreenState extends State<collectionScreen> {
  final String folderId;
  final String name;
  final String image;
  final List<String> bookIds;

  _collectionScreenState({
    required this.folderId,
    required this.name,
    required this.image,
    required this.bookIds,
  });

  final isar = Isar.getInstance();
  // make a list of entries from the the list of bookIds
  Future<List<Entry>> getEntries() async {
    List<Entry> entryList = await isar!.entrys
        .where()
        .filter()
        .anyOf(bookIds, (q, String id) => q.idEqualTo(id))
        .findAll();
    // print all the ones that have EntryType.folder
    entryList.forEach((element) {
      if (element.type == EntryType.folder) {
        logger.f(element.title);
      }
    });
    return entryList;
    // checkeach field of the entry to make sure it is not null
  }

  Future<List<Entry>> get entries async {
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
                  onTap: () async {
                    if (snapshot.data[index].type != EntryType.folder) {
                      var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InfoScreen(
                            entry: snapshot.data[index],
                          ),
                        ),
                      );
                      if (result != null) {
                        snapshot.data[index].isFavorited =
                            result.$1 ?? snapshot.data[index].isFavorited;
                        snapshot.data[index].downloaded =
                            result.$2 ?? snapshot.data[index].downloaded;
                        await isar?.writeTxn(() async {
                          await isar?.entrys.put(snapshot.data[index]);
                        });
                      }
                    } else {
                      var folder = isar!.folders
                          .where()
                          .filter()
                          .idEqualTo(snapshot.data[index].id)
                          .findFirstSync();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => collectionScreen(
                            folderId: folder!.id,
                            name: folder.name,
                            image: folder.image,
                            bookIds: folder.bookIds,
                          ),
                        ),
                      );
                    }
                  },
                  title: Text(snapshot.data[index].title),
                  leading: RoundedImageWithShadow(
                    imageUrl: snapshot.data[index].imagePath,
                    radius: 5,
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (snapshot.data[index].rating >= 0)
                        IgnorePointer(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: CustomRating(
                                  max: 5,
                                  score: snapshot.data[index].rating / 2,
                                  star: Star(
                                    fillColor: Color.lerp(
                                        Colors.red,
                                        Colors.yellow,
                                        snapshot.data[index].rating / 10)!,
                                    emptyColor: Colors.grey.withOpacity(0.5),
                                  ),
                                  onRating: (double score) {},
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: Text(
                                  "${(snapshot.data[index].rating / 2).toStringAsFixed(2)} / 5.00",
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (snapshot.data[index].rating < 0 &&
                          snapshot.data[index].description != '')
                        Flexible(
                          child: MarkdownBody(
                            data: fixRichText(snapshot.data[index].description),
                            extensionSet: md.ExtensionSet(
                              md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                              <md.InlineSyntax>[
                                md.EmojiSyntax(),
                                ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                              ],
                            ),
                            // prevent overflow
                            //   style: const TextStyle(
                            //     fontStyle: FontStyle.italic,
                            //     fontSize: 15,
                            //     color: Colors.grey,
                            //   ),
                            // ),
                            // overflow: TextOverflow.ellipsis,
                            // maxLines: 1,
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)?.noResultsFound ??
                        'No results found in this folder',
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
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)?.unknownError ??
                        "An unknown error has occured.",
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
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
