// The purpose of this file is to define the theme switcher for the app

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager with ChangeNotifier {
  ThemeManager(this._themeData);
// get the theme data from system
  ThemeData _themeData =
      ThemeMode.system == ThemeMode.dark ? ThemeData.dark() : ThemeData.light();
  // ThemeMode _themeMode = ThemeMode.system;

  // get themeMode => _themeMode;

  ThemeData getTheme() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getString('theme') == 'system') {
        return ThemeMode.system;
      } else if (prefs.getString('theme') == 'dark') {
        return ThemeMode.dark;
      } else {
        return ThemeMode.light;
      }
    });
    return _themeData;
  }

  void setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
    // set the shared preferences
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('theme', theme.brightness.toString());
    });
  }

  // Future<void> setThemeMode(ThemeMode theme) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (theme == ThemeMode.dark) {
  //     prefs.setString("theme", "dark");
  //     _themeMode = ThemeMode.dark;
  //   } else if (theme == ThemeMode.light) {
  //     prefs.setString("theme", "light");
  //     _themeMode = ThemeMode.light;
  //   } else if (theme == ThemeMode.system) {
  //     prefs.setString("theme", "system");
  //     _themeMode = ThemeMode.system;
  //   }
  //   notifyListeners();
  // }
}
