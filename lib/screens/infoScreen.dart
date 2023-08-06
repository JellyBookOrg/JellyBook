// the goal of this file is to create a screen that displays information about the selected book/comic

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_star/flutter_star.dart';
import 'package:jellybook/models/login.dart';
import 'package:jellybook/providers/deleteComic.dart';
import 'package:jellybook/providers/fixRichText.dart';
import 'package:jellybook/screens/downloaderScreen.dart';
import 'package:jellybook/screens/readingScreen.dart';
import 'package:jellybook/widgets/roundedImageWithShadow.dart';
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
import 'package:package_info_plus/package_info_plus.dart' as p_info;
import 'package:openapi/openapi.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  /// get the authors from the entry (List of Author, Role)
  Future<List<(String, String, String)>> getAuthors() async {
    List<(String, String, String)> authors = [];
    if (updatedImageWidth == false) {
      imageWidth = MediaQuery.of(context).size.width * 0.3;
      updatedImageWidth = true;
    }
    if (entry.writer != null) {
      final image = await getAuthorImage(entry.writer!);
      authors.add((
        entry.writer!,
        AppLocalizations.of(context)?.writer ?? "Writer",
        image
      ));
      logger.i("writer: ${entry.writer}");
    }
    if (entry.penciller != null) {
      final image = await getAuthorImage(entry.penciller!);
      authors.add((
        entry.penciller!,
        AppLocalizations.of(context)?.penciller ?? "Penciller",
        image
      ));
      logger.i("penciller: ${entry.penciller}");
    }
    if (entry.inker != null) {
      final image = await getAuthorImage(entry.inker!);
      authors.add((
        entry.inker!,
        AppLocalizations.of(context)?.inker ?? "Inker",
        image
      ));
      logger.i("inker: ${entry.inker}");
    }
    if (entry.colorist != null) {
      final image = await getAuthorImage(entry.colorist!);
      authors.add((
        entry.colorist!,
        AppLocalizations.of(context)?.colorist ?? "Colorist",
        image
      ));
      logger.i("colorist: ${entry.colorist}");
    }
    if (entry.letterer != null) {
      final image = await getAuthorImage(entry.letterer!);
      authors.add((
        entry.letterer!,
        AppLocalizations.of(context)?.letterer ?? "Letterer",
        image
      ));
      logger.i("letterer: ${entry.letterer}");
    }
    if (entry.coverArtist != null) {
      final image = await getAuthorImage(entry.coverArtist!);
      authors.add((
        entry.coverArtist!,
        AppLocalizations.of(context)?.coverArtist ?? "Cover Artist",
        image
      ));
      logger.i("coverArtist: ${entry.coverArtist}");
    }
    if (entry.editor != null) {
      final image = await getAuthorImage(entry.editor!);
      authors.add((
        entry.editor!,
        AppLocalizations.of(context)?.editor ?? "Editor",
        image
      ));
      logger.i("editor: ${entry.editor}");
    }
    if (entry.publisher != null) {
      final image = await getAuthorImage(entry.publisher!);
      authors.add((
        entry.publisher!,
        AppLocalizations.of(context)?.publisher ?? "Publisher",
        image
      ));
      logger.i("publisher: ${entry.publisher}");
    }
    if (entry.imprint != null) {
      final image = await getAuthorImage(entry.imprint!);
      authors.add((
        entry.imprint!,
        AppLocalizations.of(context)?.imprint ?? "Imprint",
        image
      ));
      logger.i("imprint: ${entry.imprint}");
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

    final api = Openapi(basePathOverride: server).getPersonsApi();
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
  }

  void handleImageSize(Size imageSize) {
    // Do something with the image size obtained from the callback
    logger.wtf('Image size: ${imageSize.width} x ${imageSize.height}');
    // wait until build is done then set state but do it only once
    if (imageWidth == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          imageWidth = imageSize.width;
        });
      });
    }
  }

  // actionRow
  Widget actionRow() {
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: imageWidth,
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
                              "You need to download the comic first"),
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
          ElevatedButton(
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
          ElevatedButton(
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
          ElevatedButton(
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
                    color: !offline
                        ? Theme.of(context).iconTheme.color
                        : Colors.white,
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
                      comicId: entry.id,
                    ),
                  ),
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      entry.downloaded = value;
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
                            color:
                                Theme.of(context).textTheme.bodyLarge?.color ??
                                    Colors.white)),
                    backgroundColor: Theme.of(context).dialogBackgroundColor,
                    duration: const Duration(seconds: 5),
                  ),
                );
              }
            },
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
                              AppLocalizations.of(context)?.delete ?? "Delete"),
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
            Navigator.pop(context, Pair(isLiked, entry.downloaded));
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
                        onImageSizeAvailable: handleImageSize,
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
                                child: Text(
                                  entry.releaseDate,
                                  // autosize the text
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey[400]),
                                ),
                              ),
                            if (entry.rating >= 0)
                              IgnorePointer(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: CustomRating(
                                    max: 5,
                                    score: entry.rating / 2,
                                    star: Star(
                                      fillColor: Color.lerp(Colors.red,
                                          Colors.yellow, entry.rating / 10)!,
                                      emptyColor: Colors.grey.withOpacity(0.5),
                                    ),
                                    onRating: (double score) {},
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actionRow(),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: MarkdownBody(
                data: fixRichText(entry.description),
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
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: entry.tags.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Chip(
                        label: Text(entry.tags[index]),
                      ),
                    );
                  },
                ),
              ),
            FutureBuilder(
              future: getAuthors(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
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
                              // Calculate the number of items to display in each row based on the available width
                              int itemsPerRow =
                                  (MediaQuery.of(context).size.width / 200 -
                                          (snapshot.data!.length - 1) * 20)
                                      .floor();

                              // Set a minimum item width to ensure at least 3 items per row on a normal smartphone
                              double minWidth =
                                  MediaQuery.of(context).size.width / 3 - 20;

                              // Calculate the width for each item based on the number of items per row and the minimum width
                              double itemWidth =
                                  (MediaQuery.of(context).size.width -
                                          (itemsPerRow - 1) * 20) /
                                      itemsPerRow;
                              itemWidth = itemWidth.clamp(
                                  minWidth,
                                  double
                                      .infinity); // Ensure it's at least minWidth

                              // A image of the author with their name below it and their role below that
                              return Column(
                                children: [
                                  ClipOval(
                                    child: FancyShimmerImage(
                                      imageUrl: snapshot.data![index].$3,
                                      boxFit: BoxFit.fitWidth,
                                      width: itemWidth - 7,
                                      height: itemWidth - 7,
                                      errorWidget: // rounded image asset
                                          const Image(
                                        image: AssetImage(
                                          "assets/images/ProfilePicture.png",
                                        ),
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                  ),
                                  // make these text fields auto size so that they don't overflow and width should less than the image
                                  SizedBox(
                                    width: itemWidth - 10,
                                    child: AutoSizeText(
                                      snapshot.data![index].$1,
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    width: itemWidth - 10,
                                    child: AutoSizeText(
                                      snapshot.data![index].$2,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
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
