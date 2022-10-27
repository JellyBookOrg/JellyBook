import 'package:flutter/material.dart';
import 'package:jellybook/screens/login.dart';

void main() {
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
