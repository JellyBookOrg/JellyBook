import 'package:flutter/material.dart';
import 'package:jellybook/screens/loginScreen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jellybook/models/entry.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(EntryAdapter());
  await Hive.openBox<Entry>('bookShelf');

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
