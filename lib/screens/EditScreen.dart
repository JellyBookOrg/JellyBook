// the purpose of this file is to allow you to edit a entry in your library

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_star/flutter_star.dart';
import 'package:intl/intl.dart';
import 'package:jellybook/providers/fixRichText.dart';
import 'package:jellybook/widgets/ToggleEditPreviewButton.dart';
import 'package:jellybook/widgets/roundedImageWithShadow.dart';
import 'package:jellybook/providers/updateLike.dart';
import 'package:isar/isar.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:jellybook/models/entry.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jellybook/variables.dart';
import 'package:package_info_plus/package_info_plus.dart' as p_info;
import 'package:openapi/openapi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class EditScreen extends StatefulWidget {
  bool offline;
  Entry entry;

  EditScreen({
    super.key,
    required this.entry,
    this.offline = false,
  });

  @override
  _EditScreenState createState() => _EditScreenState(
        entry: entry,
        offline: offline,
      );
}

class _EditScreenState extends State<EditScreen> {
  bool editMode = true;
  bool offline;
  bool changed = false;
  Entry entry;
  _EditScreenState({
    required this.entry,
    this.offline = false,
  });
  double imageWidth = 0;
  bool updatedImageWidth = false;
  bool isEditingDescription = false;
  final picker = ImagePicker();
  TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  List<String> tags = [];
  TextEditingController _titleController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  TextEditingController _releaseDateController = TextEditingController();
  late String _tempImagePath;

// check if it is liked or not by checking the database
  Future<bool> checkLiked(String id) async {
    final isar = Isar.getInstance();
    final entries = await isar?.entrys.where().idEqualTo(id).findFirst();

    return entries?.isFavorited ?? false;
  }

  @override
  void initState() {
    super.initState();
    checkLiked(entry.id).then((value) {
      entry.isFavorited = value;
    });
    _tempImagePath = entry.imagePath;
    tags = List<String>.from(entry.tags);
    _titleController = TextEditingController(text: entry.title);
    _releaseDateController = TextEditingController(text: entry.releaseDate);
    _descriptionController = TextEditingController(text: entry.description);
    logger.i("isarId: ${entry.isarId}");
    logger.i("rating: ${entry.rating}");
    if (entry.rating < 0) {
      entry.rating = 0;
    }
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

  // pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File image = File(pickedFile.path);
      saveImageToDocumentsDirectory(image);
    }
  }

  Future<void> saveImageToDocumentsDirectory(File image) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final fileName = p.basename(image.path);
    final savedImage = await image.copy('${documentsDir.path}/$fileName');

    // Store the image path temporarily instead of directly assigning it to entry
    setState(() {
      _tempImagePath = savedImage.path;
    });
  }

  bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;

    return shortestSide > 600;
  }

  Future<void> saveToDevice() async {
    final isar = Isar.getInstance();
    entry.tags = tags;
    entry.description = _descriptionController.text;
    if (_tempImagePath != null) {
      entry.imagePath = _tempImagePath!;
    }

    await isar?.writeTxn(() async {
      await isar.entrys.put(entry);
    });
  }

  Future<void> saveToServer() async {
    final isar = Isar.getInstance();
    bool imageChanged = false;
    final entry2 =
        await isar!.entrys.where().idEqualTo(this.entry.id).findFirst();
    if (_tempImagePath != null) {
      entry.imagePath = _tempImagePath!;
    }
    if (entry2!.imagePath != entry.imagePath) {
      imageChanged = true;
    }
    entry.tags = tags;
    entry.description = _descriptionController.text;

    await saveToDevice();

    final prefs = await SharedPreferences.getInstance();
    p_info.PackageInfo packageInfo = await p_info.PackageInfo.fromPlatform();
    final server = prefs.getString('server')!;
    final token = prefs.getString('accessToken')!;
    final version = packageInfo.version;
    const _client = "JellyBook";
    const _device = "Unknown Device";
    const _deviceId = "Unknown Device id";

    final url = server + '/Items/' + entry.id;
    var headers = {
      'Accept': 'application/json',
      'Accept-Language': 'en-US,en;q=0.5',
      'Accept-Encoding': 'gzip, deflate',
      'Content-Type': 'application/json',
      "X-Emby-Authorization":
          "MediaBrowser Client=\"$_client\", Device=\"$_device\", DeviceId=\"$_deviceId\", Version=\"$version\", Token=\"$token\"",
      'Connection': 'keep-alive',
      'Origin': server,
      'Host': server.substring(server.indexOf("//") + 2, server.length),
    };
    final api = Openapi(basePathOverride: server).getItemUpdateApi();
    DateTime? dateTime;
    try {
      dateTime = DateTime.parse(entry.releaseDate);
    } catch (e) {
      try {
        dateTime = DateTime.parse(
          entry.releaseDate.replaceAll(' ', '-'),
        );
      } catch (e) {
        logger.e(e.toString());
      }
    }
    // body of the request
    try {
      final response = await api.updateItem(
        itemId: entry.id,
        updateItemRequest: UpdateItemRequest(
          (b) => {
            b.name = entry.title,
            b.overview = entry.description,
            if (dateTime != null) b.premiereDate = dateTime,
            b.tags = ListBuilder<String>(tags),
          },
        ),
        headers: headers,
      );
      logger.d(response.toString());
    } catch (e) {
      logger.e(e.toString());
      // display error message
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)?.error ?? "Error",
            ),
            content: Text(
              e.toString(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  AppLocalizations.of(context)?.ok ?? "Ok",
                ),
              ),
            ],
          );
        },
      );
    }
    if (imageChanged) {
      final api2 = Openapi(basePathOverride: server).getImageApi();
      // get the image encoded in base64
      File imagefile = File(entry.imagePath);
      MultipartFile file = await MultipartFile.fromFile(
        entry.imagePath,
        filename: entry.imagePath,
      );
      // get length of file
      headers = {
        'Accept': 'application/json',
        'Accept-Language': 'en-US,en;q=0.5',
        'Accept-Encoding': 'gzip, deflate',
        'Content-Type': 'multipart/form-data',
        "X-Emby-Authorization":
            "MediaBrowser Client=\"$_client\", Device=\"$_device\", DeviceId=\"$_deviceId\", Version=\"$version\", Token=\"$token\"",
        'Connection': 'keep-alive',
        'Origin': server,
        'Host': server.substring(server.indexOf("//") + 2, server.length),
        'Content-Length': '${file.length}',
      };
      try {
        final response = await api2.setItemImage(
          itemId: entry.id,
          imageType: ImageType.primary,
          headers: headers,
        );
        // tell if the image was uploaded or not
      } catch (e) {
        logger.e(e.toString());
      }
    }
    logger.d(url);
    // if (entries?.isFavorited == false) {
    //   try {
    //     final response = await api.unmarkFavoriteItem(
    //         userId: userId, itemId: id, headers: headers, url: server);
    //     logger.d(response.data.toString());
    //   } catch (e) {
    //     logger.e(e.toString());
    //   }
    // } else {
    //   try {
    //     final response = await api.markFavoriteItem(
    //         userId: userId, itemId: id, headers: headers, url: server);
    //     logger.d(response.data.toString());
    //   } catch (e) {
    //     logger.e(e.toString());
    //   }
    // }
  }

  void toggleEditDescription() {
    setState(() {
      isEditingDescription = !isEditingDescription;
    });
  }

  void _insertText(String textToInsertFront, String textToInsertBack) {
    final text = _descriptionController.text;
    final textSelection = _descriptionController.selection;
    // if highlighting text, then wrap the text in the markdown
    // if not, then just insert the markdown
    if (textSelection.start != textSelection.end) {
      final textBefore = text.substring(0, textSelection.start);
      final textAfter = text.substring(textSelection.end, text.length);
      final newText = '$textBefore$textToInsertFront'
          '${text.substring(textSelection.start, textSelection.end)}'
          '$textToInsertBack$textAfter';
      _descriptionController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: textBefore.length +
              textToInsertFront.length +
              textSelection.end -
              textSelection.start,
        ),
      );
    } else {
      final newText = '$text$textToInsertFront$textToInsertBack';
      _descriptionController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: text.length + textToInsertFront.length,
        ),
      );
    }
  }

  ButtonStyle _buttonStyle(bool isSelected) {
    return TextButton.styleFrom(
      foregroundColor: isSelected
          ? Theme.of(context).primaryTextTheme.labelLarge!.color
          : Colors.grey,
      // set the background color to a non-transparent color if selected and a different non-transparent color if not selected
      backgroundColor: isSelected
          ? Theme.of(context).primaryTextTheme.labelLarge?.background?.color ??
              Colors.purple.withOpacity(0.2)
          : Colors.grey.withOpacity(0.2),
    );
  }

  Widget _buildMarkdownToolbar() {
    return Container(
      // set the size of the container to be the same as the buttons
      height: 40,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.purple.withOpacity(0.2),
        // color: Theme.of(context).primaryColor.withOpacity(0.2),
      ),
      // Adjust the style accordingly
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // Bold button
          IconButton(
            icon: Icon(Icons.format_bold),
            onPressed: () => _insertText('**', '**'),
          ),
          // Italic button
          IconButton(
            icon: Icon(Icons.format_italic),
            onPressed: () => _insertText('_', '_'),
          ),
          // Link button
          IconButton(
            icon: Icon(Icons.link),
            onPressed: () => _insertText('[', '](url)'),
          ),
          // H1 button
          IconButton(
            icon: Icon(Icons.looks_one),
            onPressed: () => _insertText('# ', ''),
          ),
          // List button
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () => _insertText('\n- ', ''),
          ),
          // Code button
          IconButton(
            icon: Icon(Icons.code),
            onPressed: () => _insertText('`', '`'),
          ),
          // Add more buttons for italic, code blocks, etc.
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    // try to parse it into a date time
    // if it fails, then use the current date time
    DateTime dateTime;
    try {
      dateTime = DateTime.parse(entry.releaseDate);
    } catch (e) {
      try {
        dateTime = DateTime.parse(
          entry.releaseDate.replaceAll(' ', '-'),
        );
      } catch (e) {
        dateTime = DateTime.now();
      }
    }
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: dateTime,
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                // entry.releaseDate = newDate.toString();
                // only the month, day, and year
                entry.releaseDate = DateFormat('dd MM yyyy').format(newDate);
              });
            },
          ),
        );
      },
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
            Navigator.pop(context, entry);
          },
        ),
        // trailing button to toggle edit mode
        actions: [
          IconButton(
            // if edit mode is true, show a preview button, else show an edit button
            icon: Icon(
              editMode ? Icons.visibility : Icons.edit,
            ),
            onPressed: () {
              setState(() {
                editMode = !editMode;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: !editMode
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                          child: RoundedImageWithShadow(
                            imageUrl: _tempImagePath,
                            radius: 15,
                            ratio: 0.75,
                            size: Size(MediaQuery.of(context).size.width * 0.3,
                                MediaQuery.of(context).size.width * 0.3 * 1.5),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  // child: TextField(
                                  //   style: const TextStyle(
                                  //     fontSize: 20,
                                  //   ),
                                  //   controller: _titleController,
                                  //   focusNode: _titleFocusNode,
                                  //   onChanged: (value) {
                                  //     entry.title = value;
                                  //   },
                                  //   decoration: InputDecoration(
                                  //     hintText: 'Enter Title Here',
                                  //     border: InputBorder.none,
                                  //   ),
                                  // ),
                                  child: AutoSizeText(
                                    entry.title,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    ),
                                    // textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.55,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Release Date: ",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  const Spacer(flex: 1),
                                  // regular text instead of button
                                  Text(
                                    entry.releaseDate,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.55,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Rating: ",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  Spacer(flex: 1),
                                  IgnorePointer(
                                    child: CustomRating(
                                      max: 5,
                                      score: entry.rating / 2,
                                      star: Star(
                                        fillColor: Color.lerp(
                                          Colors.red,
                                          Colors.yellow,
                                          entry.rating / 10,
                                        )!,
                                        emptyColor:
                                            Colors.grey.withOpacity(0.5),
                                      ),
                                      onRating: (double score) {
                                        entry.rating = score * 2;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // allow users to edit the description in rich text
                    // add a button that displays the rich text, and when clicked it will display the markdown that you can edit
                    // 2 buttons at the bottom, one says save to device and the says save to server
                    // Expanded(
                    // text saying description
                    Text(
                      "Description:",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    MarkdownBody(
                      data: fixRichText(
                        _descriptionController.text,
                      ),
                      extensionSet: md.ExtensionSet(
                        md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                        <md.InlineSyntax>[
                          md.EmojiSyntax(),
                          ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    if (tags.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: tags.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Chip(
                                  label: Text(tags[index]),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                          child: Stack(
                            children: [
                              RoundedImageWithShadow(
                                imageUrl: _tempImagePath,
                                radius: 15,
                                ratio: 0.75,
                                size: Size(
                                    MediaQuery.of(context).size.width * 0.3,
                                    MediaQuery.of(context).size.width *
                                        0.3 *
                                        1.5),
                              ),
                              Positioned.fill(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => (
                                      _pickImage(),
                                      changed = true,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(
                                          0.5,
                                        ), // Semi-transparent gray overlay
                                        borderRadius: BorderRadius.circular(
                                          15,
                                        ), // Match the border radius of the image
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons
                                              .camera_alt, // Icon indicating that you can upload an image
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: TextField(
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                    controller: _titleController,
                                    focusNode: _titleFocusNode,
                                    onChanged: (value) {
                                      entry.title = value;
                                      changed = true;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            // Release date
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.55,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Release Date: ",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  Spacer(flex: 1),
                                  TextButton(
                                    onPressed: () {
                                      _showDatePicker(context);
                                      changed = true;
                                    },
                                    child: Text(
                                      entry.releaseDate,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            // Rating
                            // allign left
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.55,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Rating: ",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  Spacer(flex: 1),
                                  CustomRating(
                                    max: 5,
                                    score: entry.rating / 2,
                                    star: Star(
                                      fillColor: Color.lerp(Colors.red,
                                          Colors.yellow, entry.rating / 10)!,
                                      emptyColor: Colors.grey.withOpacity(0.5),
                                    ),
                                    onRating: (double score) {
                                      entry.rating = score * 2;
                                      changed = true;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // allow users to edit the description in rich text
                    // add a button that displays the rich text, and when clicked it will display the markdown that you can edit
                    // 2 buttons at the bottom, one says save to device and the says save to server
                    // Expanded(
                    // text saying description
                    Text(
                      "Description:",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _buildMarkdownToolbar(),
                    SizedBox(
                      height: 10,
                    ),
                    // OutlinedButton(
                    //     onPressed: () => setState(() {
                    //           isEditingDescription = !isEditingDescription;
                    //         }),
                    //     child: Text('Preview')),
                    TextField(
                      controller: _descriptionController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null, // Makes it expandable
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // Editing tags
                    TextField(
                      controller: _tagController,
                      decoration: InputDecoration(
                        labelText: 'Add a tag',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            // add the tag
                            setState(() {
                              changed = true;
                              if (_tagController.text.isNotEmpty) {
                                tags = List.from(tags)
                                  ..add(_tagController.text);
                              }
                              _tagController.clear();
                            });
                          },
                        ),
                      ),
                      onSubmitted: (value) {
                        setState(() {
                          if (value.isNotEmpty) {
                            tags = List.from(tags)..add(value);
                          }
                        });
                      },
                    ),
                    ReorderableListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          changed = true;
                          setState(() {
                            tags = List.from(
                              tags
                                ..insert(
                                  newIndex,
                                  tags.removeAt(oldIndex),
                                ),
                            );
                          });
                        });
                      },
                      children: List.generate(tags.length, (index) {
                        return ListTile(
                          key: ValueKey(tags[index]),
                          title: Text(tags[index]),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                tags = List.from(tags..removeAt(index));
                                changed = true;
                              });
                            },
                          ),
                        );
                      }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: saveToDevice,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: const Center(
                              child: Text("Save to device"),
                            ),
                          ),
                        ),
                        if (!offline)
                          TextButton(
                            onPressed: saveToServer,
                            // onPressed: saveToServer,
                            // child: Text("Save to server"),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.40,
                              child: const Center(
                                child: Text("Save to server"),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
