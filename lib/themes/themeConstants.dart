// The purpose of this file is to define the themes for the app

import 'package:flutter/material.dart';

// Dark theme
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  popupMenuTheme: PopupMenuThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50.0),
    ),
    color: Colors.grey[800],
  ),
);

// Light theme
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  popupMenuTheme: PopupMenuThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50.0),
    ),
    color: Colors.grey[800],
  ),
);

// OLED theme
// This theme is designed for OLED screens
ThemeData oled = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  scaffoldBackgroundColor: Colors.black,
  cardColor: Colors.black,
  popupMenuTheme: PopupMenuThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50.0),
    ),
    color: Colors.grey[800],
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: Colors.white,
      fontSize: 14,
    ),
    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 12,
    ),
    labelMedium: TextStyle(
      color: Colors.white,
      fontSize: 10,
    ),
    labelSmall: TextStyle(
      color: Colors.white,
      fontSize: 8,
    ),
  ),
);
