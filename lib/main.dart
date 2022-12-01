import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:jellybook/screens/loginScreen.dart';
import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:jellybook/models/entry.dart';
import 'package:jellybook/models/folder.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isar = await Isar.open([EntrySchema, FolderSchema]);

  // Isar.open([bookShelf, folders], inspector: true);
  //
  // Hive.registerAdapter(EntryAdapter());
  // Hive.registerAdapter(FolderAdapter());
  // await Hive.openBox<Entry>('bookShelf');
  // await Hive.openBox<Folder>('folders');
  //
  if (kDebugMode) {
    try {
      // delete all entries in the database
      // get a list of all the entries ids
      var entries = await isar.entrys.where().findAll();
      var entryIds = entries.map((e) => e.isarId).toList();
      await isar.writeTxn(() async {
        isar.entrys.deleteAll(entryIds);
        debugPrint("deleted ${entryIds.length} entries");
      });
      // delete all folders in the database
      // get a list of all the folders ids
      var folders = await isar.folders.where().findAll();
      var folderIds = folders.map((e) => e.isarId).toList();
      await isar.writeTxn(() async {
        isar.folders.deleteAll(folderIds);
        debugPrint("deleted ${folderIds.length} folders");
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    debugPrint("cleared Isar boxes");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      title: 'Jellybook',
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
