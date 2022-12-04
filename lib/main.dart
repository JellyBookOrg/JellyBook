import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:jellybook/screens/loginScreen.dart';
import 'package:isar/isar.dart';
import 'package:jellybook/models/entry.dart';
import 'package:jellybook/models/folder.dart';
import 'package:jellybook/models/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isar = await Isar.open([EntrySchema, FolderSchema, LoginSchema]);

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

  // check if there are any logins in the database
  var logins = await isar.logins.where().findAll();
  if (logins.isNotEmpty) {
    debugPrint("login url: " + logins[0].serverUrl);
    debugPrint("login username: " + logins[0].username);
    debugPrint("login password: " + logins[0].password);
    runApp(MyApp(
        url: logins[0].serverUrl,
        username: logins[0].username,
        password: logins[0].password));
  } else {
    runApp(MyApp());
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String? url;
  final String? username;
  final String? password;

  MyApp({this.url = "", this.username = "", this.password = ""});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      title: 'Jellybook',
      home: LoginScreen(
        url: url,
        username: username,
        password: password,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
