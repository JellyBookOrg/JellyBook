// The purpose of this file is to have a screen with all the downloaded books with easy access to delete them

import 'package:flutter/material.dart';
import 'package:jellybook/screens/collectionScreen.dart';
import 'package:jellybook/screens/infoScreen.dart';
import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
import 'package:jellybook/models/entry.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:jellybook/widgets/roundedImageWithShadow.dart';
import 'package:jellybook/providers/fixRichText.dart';
import 'package:flutter_star/flutter_star.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jellybook/variables.dart';

class DownloadsScreen extends StatefulWidget {
  @override
  _DownloadsScreenState createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  Future<List<Entry>> getEntries() async {
    final isar = Isar.getInstance();
    final entryList =
        await isar!.entrys.where().filter().downloadedEqualTo(true).findAll();
    return entryList;
  }

  Future<List<Entry>> get entries async {
    return await getEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                AppLocalizations.of(context)?.downloads ?? "Downloads",
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
            future: entries,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData &&
                  snapshot.data.length > 0 &&
                  snapshot.connectionState == ConnectionState.done) {
                return Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          onTap: () {
                            if (snapshot.data[index].type != EntryType.folder) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InfoScreen(
                                    entry: snapshot.data[index],
                                  ),
                                ),
                              );
                            } else if (snapshot.data[index].type ==
                                EntryType.folder) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => collectionScreen(
                                    folderId: snapshot.data[index].id,
                                    name: snapshot.data[index].title,
                                    image: snapshot.data[index].imagePath,
                                    bookIds: snapshot.data[index].bookIds,
                                  ),
                                ),
                              );
                            }
                          },
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                        AppLocalizations.of(context)?.delete ??
                                            "Delete"),
                                    content: Text(AppLocalizations.of(context)
                                            ?.deleteConfirm ??
                                        "Are you sure you want to delete this book/comic?"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(AppLocalizations.of(context)
                                                ?.cancel ??
                                            "Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text("Delete"),
                                        onPressed: () {
                                          final isar = Isar.getInstance();
                                          isar?.writeTxn(() async {
                                            await isar.entrys.delete(
                                                snapshot.data[index].isarId);
                                          });
                                          snapshot.data.removeAt(index);
                                          setState(() {});
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          title: Text(snapshot.data[index].title),
                          leading: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: RoundedImageWithShadow(
                              imageUrl: snapshot.data[index].imagePath,
                              radius: 8,
                            ),
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
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: CustomRating(
                                          max: 5,
                                          score:
                                              snapshot.data[index].rating / 2,
                                          star: Star(
                                            fillColor: Color.lerp(
                                                Colors.red,
                                                Colors.yellow,
                                                snapshot.data[index].rating /
                                                    10)!,
                                            emptyColor:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? Colors.grey[800]!
                                                        .withOpacity(0.5)
                                                    : Colors.grey[300]!
                                                        .withOpacity(0.5),
                                            // emptyColor: Colors.grey.withOpacity(0.5),
                                          ),
                                          onRating: (double score) {},
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 0, 0, 0),
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
                                  child: RichText(
                                    text: TextSpan(
                                      text: fixRichText(
                                          snapshot.data[index].description),
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                );
              } else if (snapshot.hasData &&
                  snapshot.data.length == 0 &&
                  snapshot.connectionState == ConnectionState.done) {
                return Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)?.noBooksFound ??
                              "No books were found to be downloaded",
                          textAlign: TextAlign.center,
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
                  ),
                );
              } else if (snapshot.hasError) {
                logger.e(snapshot.error.toString());
                return Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)?.unknownError ??
                              "An error has occured",
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
