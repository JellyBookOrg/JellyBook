// The purpose of this file is to provide a audio picker for the user to select an audio file to play along side the book they are reading

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:jellybook/models/entry.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jellybook/widgets/roundedImageWithShadow.dart';

class AudioPicker extends StatefulWidget {
  AudioPicker();

  _AudioPickerState createState() => _AudioPickerState();
}

class _AudioPickerState extends State<AudioPicker> {
  final isar = Isar.getInstance();
  String path = '';

  // get all downloaded audio files
  Future<List<Entry>> getAudioFiles() async {
    List<Entry> entries = await isar!.entrys
        .filter()
        .typeEqualTo(EntryType.audiobook)
        .and()
        .downloadedEqualTo(true)
        .findAll();

    return entries;
  }

  @override
  void initState() {
    super.initState();
    getAudioFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.selectAudioFile ??
            'Select Audio File'),
      ),
      body: FutureBuilder(
        future: getAudioFiles(),
        builder: (BuildContext context, AsyncSnapshot<List<Entry>> snapshot) {
          if (snapshot.hasData) {
            debugPrint('snapshot has data');
            if (snapshot.data.toString() == "[]") {
              // have a popup saying that you must download audiobooks first
              return AlertDialog(
                title: Text(
                    AppLocalizations.of(context)?.noAudiobooksDownloaded ??
                        'No Audiobooks Downloaded'),
                content: Text(AppLocalizations.of(context)
                        ?.pleaseDownloadAudiobookFirst ??
                    'Please download an audiobook first'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)?.ok ?? 'Ok'),
                  ),
                ],
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  // create image on left side of list tile
                  leading: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black.withOpacity(0.5)
                              : Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(2, 3),
                        ),
                      ],
                    ),
                    child: RoundedImageWithShadow(
                      imageUrl: snapshot.data![index].imagePath,
                      ratio: 1,
                    ),
                  ),

                  title: Text(snapshot.data![index].title),
                  onTap: () {
                    Navigator.pop(context, snapshot.data![index].filePath);
                  },
                );
              },
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
