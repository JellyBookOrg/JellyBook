// the goal of this file is to create a screen that displays information about the selected book/comic

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_star/flutter_star.dart';
import 'package:jellybook/models/login.dart';
import 'package:jellybook/providers/deleteComic.dart';
import 'package:jellybook/providers/fixRichText.dart';
import 'package:jellybook/screens/downloaderScreen.dart';
import 'package:jellybook/screens/EditScreen.dart';
import 'package:jellybook/screens/readingScreen.dart';
import 'package:jellybook/widgets/roundedImageWithShadow.dart';
import 'package:like_button/like_button.dart';
import 'package:jellybook/providers/updateLike.dart';
import 'package:isar/isar.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:jellybook/models/entry.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jellybook/variables.dart';
import 'package:package_info_plus/package_info_plus.dart' as p_info;
import 'package:tentacle/tentacle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jellybook/providers/Author.dart';

class InfoScreen extends StatefulWidget {
  bool offline;
  Entry entry;

  InfoScreen({
    super.key,
    required this.entry,
    this.offline = false,
  });

  @override
  _InfoScreenState createState() => _InfoScreenState(
        entry: entry,
        offline: offline,
      );
}

class _InfoScreenState extends State<InfoScreen> {
  bool offline;
  Entry entry;
  _InfoScreenState({
    required this.entry,
    this.offline = false,
  });
  double imageWidth = 0;
  bool updatedImageWidth = false;

// check if it is liked or not by checking the database
  Future<bool> checkLiked(String id) async {
    final isar = Isar.getInstance();
    final entries = await isar?.entrys.where().idEqualTo(id).findFirst();
    return entries?.isFavorited ?? false;
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    await updateLike(entry.id);
    return !isLiked;
  }

  Future<void> setRead() async {
    if (entry.progress < 100) {
      entry.progress = 100;
    } else {
      entry.progress = 0;
    }
    final isar = Isar.getInstance();
    await isar?.writeTxn(() async {
      await isar.entrys.put(entry);
    });
  }

  Future<Set<Author>> getAuthors() async {
    Set<Author> authors = {};

    if (updatedImageWidth == false) {
      updatedImageWidth = true;
      imageWidth = MediaQuery.of(context).size.width * 0.2;
      setState(() {});
    }

    if (entry.writer != null) {
      final image = await getAuthorImage(entry.writer!);
      Author author = Author(
        name: entry.writer!,
        link: image,
      );
      authors.add(author);
      final index = authors
          .toList()
          .indexWhere((element) => element.name == entry.writer);
      authors
          .toList()[index]
          .addRole(AppLocalizations.of(context)?.writer ?? "Writer");
      logger.i("writer: ${entry.writer}");
    }

    if (entry.penciller != null) {
      final image = await getAuthorImage(entry.penciller!);
      Author author = Author(
        name: entry.penciller!,
        link: image,
      );
      authors.add(author);
      final index = authors
          .toList()
          .indexWhere((element) => element.name == entry.penciller);
      authors
          .toList()[index]
          .addRole(AppLocalizations.of(context)?.penciller ?? "Penciller");
      logger.i("penciller: ${entry.penciller}");
    }

    if (entry.inker != null) {
      final image = await getAuthorImage(entry.inker!);
      Author author = Author(
        name: entry.inker!,
        link: image,
      );
      authors.add(author);
      final index =
          authors.toList().indexWhere((element) => element.name == entry.inker);
      authors
          .toList()[index]
          .addRole(AppLocalizations.of(context)?.inker ?? "Inker");
      logger.i("inker: ${entry.inker}");
    }

    if (entry.colorist != null) {
      final image = await getAuthorImage(entry.colorist!);
      Author author = Author(
        name: entry.colorist!,
        link: image,
      );
      authors.add(author);
      final index = authors
          .toList()
          .indexWhere((element) => element.name == entry.colorist);
      authors
          .toList()[index]
          .addRole(AppLocalizations.of(context)?.colorist ?? "Colorist");
      logger.i("colorist: ${entry.colorist}");
    }

    if (entry.letterer != null) {
      final image = await getAuthorImage(entry.letterer!);
      Author author = Author(
        name: entry.letterer!,
        link: image,
      );
      authors.add(author);
      final index = authors
          .toList()
          .indexWhere((element) => element.name == entry.letterer);
      authors
          .toList()[index]
          .addRole(AppLocalizations.of(context)?.letterer ?? "Letterer");
      logger.i("letterer: ${entry.letterer}");
    }

    if (entry.coverArtist != null) {
      final image = await getAuthorImage(entry.coverArtist!);
      Author author = Author(
        name: entry.coverArtist!,
        link: image,
      );
      authors.add(author);
      final index = authors
          .toList()
          .indexWhere((element) => element.name == entry.coverArtist);
      authors
          .toList()[index]
          .addRole(AppLocalizations.of(context)?.coverArtist ?? "Cover Artist");
      logger.i("coverArtist: ${entry.coverArtist}");
    }

    if (entry.editor != null) {
      final image = await getAuthorImage(entry.editor!);
      Author author = Author(
        name: entry.editor!,
        link: image,
      );
      authors.add(author);
      final index = authors
          .toList()
          .indexWhere((element) => element.name == entry.editor);
      authors
          .toList()[index]
          .addRole(AppLocalizations.of(context)?.editor ?? "Editor");
      logger.i("editor: ${entry.editor}");
    }

    if (entry.publisher != null) {
      final image = await getAuthorImage(entry.publisher!);
      Author author = Author(
        name: entry.publisher!,
        link: image,
      );
      authors.add(author);
      final index = authors
          .toList()
          .indexWhere((element) => element.name == entry.publisher);
      authors
          .toList()[index]
          .addRole(AppLocalizations.of(context)?.publisher ?? "Publisher");
      logger.i("publisher: ${entry.publisher}");
    }

    if (entry.imprint != null) {
      final image = await getAuthorImage(entry.imprint!);
      Author author = Author(
        name: entry.imprint!,
        link: image,
      );
      authors.add(author);
      final index = authors
          .toList()
          .indexWhere((element) => element.name == entry.imprint);
      authors
          .toList()[index]
          .addRole(AppLocalizations.of(context)?.imprint ?? "Imprint");
      logger.i("imprint: ${entry.imprint}");
    }
    // check if any authors don't have a role and remove them
    for (int i = 0; i < authors.length; i++) {
      if (authors.toList()[i].roles.isEmpty) {
        authors.remove(authors.toList()[i]);
      }
    }
    // merge authors with the same name
    for (int i = 0; i < authors.length; i++) {
      for (int j = 0; j < authors.length; j++) {
        if (i != j && authors.toList()[i].name == authors.toList()[j].name) {
          authors.toList()[i].roles.addAll(authors.toList()[j].roles);
          authors.remove(authors.toList()[j]);
        }
      }
    }

    return authors;
  }

  Future<String> getAuthorImage(String author) async {
    final isar = Isar.getInstance();
    String server = await isar?.logins
            .where()
            .findFirst()
            .then((value) => value?.serverUrl ?? "") ??
        "";
    p_info.PackageInfo packageInfo = await p_info.PackageInfo.fromPlatform();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken')!;
    final version = packageInfo.version;
    const _client = "JellyBook";
    const _device = "Unknown Device";
    const _deviceId = "Unknown Device id";

    // final url = server + '/Users/' + userId + '/FavoriteItems/' + id;
    final headers = {
      'Accept': 'application/json',
      'Accept-Language': 'en-US,en;q=0.5',
      'Accept-Encoding': 'gzip, deflate',
      'Content-Type': 'application/json',
      "X-Emby-Authorization":
          "MediaBrowser Client=\"$_client\", Device=\"$_device\", DeviceId=\"$_deviceId\", Version=\"$version\", Token=\"$token\"",
      'Connection': 'keep-alive',
      'enableImageTypes': 'Primary,Backdrop,Banner,Thumb,Logo',
      'Origin': server,
      'Host': server.substring(server.indexOf("//") + 2, server.length),
      'Content-Length': '0',
    };

    final api = Tentacle(basePathOverride: server).getPersonsApi();
    final person = await api.getPerson(name: author, headers: headers);
    if (person.data!.imageTags == null || person.data!.imageTags!.isEmpty) {
      return "asset";
    }
    return "$server/Items/${person.data!.id!}/Images/Primary?fillHeight=200&fillWidth=200&quality=96&tag=${person.data!.imageTags!['Primary']!}";
  }

  @override
  void initState() {
    super.initState();
    checkLiked(entry.id).then((value) {
      entry.isFavorited = value;
    });
    logger.i("isarId: ${entry.isarId}");
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleImageSize(Size imageSize) {
    // Do something with the image size obtained from the callback
    logger.f('Image size: ${imageSize.width} x ${imageSize.height}');
    // wait until build is done then set state but do it only once
    if (!updatedImageWidth) {
      setState(() {
        imageWidth = imageSize.width;
        updatedImageWidth = true;
      });
    }
  }

  bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;

    return shortestSide > 600;
  }

  // actionRow
  Widget actionRow({double size = -1}) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size == -1 ? imageWidth : size,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: entry.downloaded
                    ? Theme.of(context).buttonTheme.colorScheme!.primary
                    : Colors.grey,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (entry.downloaded) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReadingScreen(
                        title: entry.title,
                        comicId: entry.id,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)?.downloadFirst ??
                            "You need to download the comic first",
                      ),
                    ),
                  );
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_arrow),
                  const SizedBox(width: 10),
                  Text(
                    AppLocalizations.of(context)?.read ?? "Read",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor:
                    entry.progress >= 100 ? Colors.greenAccent : Colors.white,
                shape: const CircleBorder(),
                padding: EdgeInsets.zero,
                fixedSize: const Size(40, 40),
              ),
              onPressed: () async {
                await setRead();
                setState(() {});
              },
              child: const Icon(
                Icons.check_circle_outline,
              ),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
                shape: const CircleBorder(),
                padding: EdgeInsets.zero,
                fixedSize: const Size(40, 40),
              ),
              onPressed: () async {
                await updateLike(entry.id);
                setState(() {
                  entry.isFavorited = !entry.isFavorited;
                });
              },
              child: LikeButton(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                isLiked: entry.isFavorited,
                likeCountPadding: EdgeInsets.zero,
                padding: EdgeInsets.zero,
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
                        : Theme.of(context).iconTheme.color ?? Colors.white,
                  );
                },
                onTap: (bool isLiked) async {
                  updateLike(entry.id);
                  return !isLiked;
                },
              ),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: // grey
                    Colors.grey[800],
                padding: EdgeInsets.zero,
                fixedSize: const Size(40, 40),
              ),
              child: !entry.downloaded
                  ? Icon(
                      Icons.download_for_offline_outlined,
                      color: !offline ? Colors.grey[200] : Colors.white,
                    )
                  : const Icon(
                      Icons.download_done,
                      color: Colors.greenAccent,
                    ),
              onPressed: () {
                if (!offline) {
                  // push to the downloader screen and on return check if it returns a value of true and assign that to isDownloaded
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DownloadScreen(
                        entry: entry,
                      ),
                    ),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        entry = value;
                      });
                    }
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)?.downloadOffline ??
                            "You are offline, please connect to the internet & reload this app to download this comic",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color ??
                              Colors.white,
                        ),
                      ),
                      backgroundColor: Theme.of(context).dialogBackgroundColor,
                      duration: const Duration(seconds: 5),
                    ),
                  );
                }
              },
            ),
          ),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: // grey
                    Colors.grey[800],
                padding: EdgeInsets.zero,
                fixedSize: const Size(40, 40),
              ),
              onPressed: () {},
              child: PopupMenuButton(
                onSelected: (value) async {
                  if (value == "delete") {
                    logger.d("deleting comic");
                    await deleteComic(entry.id, context);
                    setState(() {
                      entry.downloaded = false;
                    });
                    Navigator.pop(context, (entry));
                  }
                  if (value == "edit") {
                    logger.d("editing comic");
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditScreen(entry: entry, offline: offline),
                      ),
                    );
                    setState(() {
                      if (result != null) entry = result;
                    });
                    // }
                  }
                },
                child: const Icon(Icons.more_vert, color: Colors.white),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: "delete",
                      child: Row(
                        children: [
                          const Icon(Icons.delete_rounded),
                          const SizedBox(width: 10),
                          Text(
                            AppLocalizations.of(context)?.delete ?? "Delete",
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: "edit",
                      child: Row(
                        children: [
                          const Icon(Icons.edit),
                          const SizedBox(width: 10),
                          Text(AppLocalizations.of(context)?.edit ?? "Edit"),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            // update the page so that the liked comics are at the top
            bool isLiked = await checkLiked(entry.id);
            Navigator.pop(context, (entry));
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  const SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                      child: RoundedImageWithShadow(
                        imageUrl: entry.imagePath,
                        radius: 15,
                        ratio: 0.75,
                        onImageSizeAvailable: (size) {
                          setState(() {
                            imageWidth = size.width;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // have a SizedBox with as much height as possible to make the text be at the bottom
                        AutoSizeText(
                          entry.title,
                          maxLines: 2,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        if (entry.writer != null)
                          AutoSizeText(
                            maxLines: 1,
                            entry.writer!,
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (entry.releaseDate != "null")
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                // use auto size text to make the text responsive
                                child: AutoSizeText(
                                  entry.releaseDate,
                                  maxLines: 1,
                                  minFontSize: 15,
                                  // autosize the text
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                              ),
                            if (entry.rating >= 0)
                              FittedBox(
                                child: IgnorePointer(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: CustomRating(
                                      max: 5,
                                      score: entry.rating / 2,
                                      star: Star(
                                        fillColor: Color.lerp(Colors.red,
                                            Colors.yellow, entry.rating / 10)!,
                                        emptyColor:
                                            Colors.grey.withOpacity(0.5),
                                      ),
                                      onRating: (double score) {},
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (isTablet(context)) ...[
                          const SizedBox(
                            height: 10,
                          ),
                          actionRow(
                              size: MediaQuery.of(context).size.width / 4),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // put action row here if the screen isn't a tablet
            if (!isTablet(context)) actionRow(),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: MarkdownBody(
                data: fixRichText(entry.description),
                extensionSet: md.ExtensionSet(
                  md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                  <md.InlineSyntax>[
                    md.EmojiSyntax(),
                    ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                  ],
                ),
                selectable: false,
                shrinkWrap: true,
                styleSheet:
                    MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                  p: const TextStyle(
                    inherit: true,
                    fontSize: 15,
                    height: 1.5,
                  ),
                  pPadding: const EdgeInsets.all(5),
                  blockSpacing: 10,
                  code: const TextStyle(
                    inherit: true,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            if (entry.tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: entry.tags.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Chip(
                          label: Text(entry.tags[index]),
                        ),
                      );
                    },
                  ),
                ),
              ),
            FutureBuilder(
              future: getAuthors(),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.length > 0 &&
                    snapshot.data?.first != null) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      // align the text to the left
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          AppLocalizations.of(context)?.credits ?? "Credits",
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          spacing: 20,
                          runSpacing: 10,
                          children: List.generate(
                            snapshot.data!.length,
                            (index) {
                              double minWidth =
                                  MediaQuery.of(context).size.width / 5 - 20;

                              // Calculate the width for each item based on the number of items per row and the minimum width
                              // A card with the image of the author with their name below it and their role(s) next to it
                              return ListTile(
                                minLeadingWidth: 0,
                                contentPadding: const EdgeInsets.all(0),
                                // set up color for the card
                                tileColor: Theme.of(context).cardColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                // set up the shape of the card
                                leading: RoundedImageWithShadow(
                                  imageUrl:
                                      snapshot.data!.elementAt(index).link ??
                                          "",
                                  radius: 30,
                                  ratio: 1,
                                  errorWidgetAsset:
                                      "assets/images/ProfilePicture.png",
                                  onImageSizeAvailable: handleImageSize,
                                ),
                                title: SizedBox(
                                  width: minWidth - 10,
                                  child: AutoSizeText(
                                    snapshot.data!.elementAt(index).name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                subtitle: SizedBox(
                                  width: minWidth - 10,
                                  child: AutoSizeText(
                                    snapshot.data!
                                        .elementAt(index)
                                        .roles
                                        .join(", "),
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
