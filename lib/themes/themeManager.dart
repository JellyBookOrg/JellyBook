// The purpose of this file is to define the theme switcher for the app

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager with ChangeNotifier {
  ThemeManager(this._themeData);
// get the theme data from system
  ThemeData _themeData = ThemeMode.system == ThemeMode.dark
      ? ThemeData.dark(useMaterial3: true)
      : ThemeData.light(useMaterial3: true);


  ThemeData getTheme() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getString('theme') == 'system') {
        return ThemeMode.system;
      } else if (prefs.getString('theme') == 'dark') {
        return ThemeMode.dark;
      } else if (prefs.getString('theme') == 'light') {
        return ThemeMode.light;
      } else {
        return ThemeMode.dark;
      }
    });
    return _themeData;
  }

  String getThemeName() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getString('theme') == 'system') {
        return 'System';
      } else if (prefs.getString('theme') == 'dark') {
        return 'Dark';
      } else if (prefs.getString('theme') == 'light') {
        return 'Light';
      } else if (prefs.getString('theme') == 'amoled') {
        return 'Amoled';
      } else {
        return 'Dark';
      }
    });
    return 'Dark';
  }

  void setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
    // set the shared preferences
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('theme', theme.brightness.toString());
    });
  }
}
