// The purpose of this file is to define the themes for the app

import 'package:flutter/material.dart';

// Dark theme
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
);

// Light theme
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
);

// OLED theme
// This theme is designed for OLED screens
ThemeData oled = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  backgroundColor: Colors.black,
  scaffoldBackgroundColor: Colors.black,
  cardColor: Colors.black,
  textTheme: TextTheme(
    headline1: TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    headline2: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    headline3: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    headline4: TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
    headline5: TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
    headline6: TextStyle(
      color: Colors.white,
      fontSize: 10,
      fontWeight: FontWeight.bold,
    ),
    bodyText1: TextStyle(
      color: Colors.white,
      fontSize: 14,
    ),
    bodyText2: TextStyle(
      color: Colors.white,
      fontSize: 12,
    ),
    subtitle1: TextStyle(
      color: Colors.white,
      fontSize: 10,
    ),
    subtitle2: TextStyle(
      color: Colors.white,
      fontSize: 8,
    ),
  ),
);
