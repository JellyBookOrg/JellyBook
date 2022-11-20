import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:jellybook/screens/loginScreen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jellybook/models/entry.dart';
import 'package:jellybook/models/folder.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(EntryAdapter());
  Hive.registerAdapter(FolderAdapter());
  await Hive.openBox<Entry>('bookShelf');
  await Hive.openBox<Folder>('folders');

  // if running in debug mode then clear the hive box
  if (kDebugMode) {
    try {
      await Hive.box<Entry>('bookShelf').clear();
      await Hive.box<Folder>('folders').clear();
    } catch (e) {
      debugPrint(e.toString());
    }
    debugPrint("cleared hive boxes");
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
