import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChangeNotifier extends ChangeNotifier {
  ThemeChangeNotifier(BuildContext context, SharedPreferences prefs) {
    _theme = ThemeData.dark(useMaterial3: true);
    _theme = getTheme;
    _context = context;
  }

  late ThemeData _theme;

  // late BuildContext _context;
  late BuildContext _context;

  // get the theme from shared preferences
  ThemeData get getTheme {
    SharedPreferences.getInstance().then((prefs) {
      String theme = prefs.getString("theme") ?? "dark";
      switch (theme) {
        case "dark":
          _theme = ThemeData.dark(useMaterial3: true);
        case "light":
          _theme = ThemeData.light(useMaterial3: true);
        case "amoled":
          _theme = oledTheme;
        case "system":
          _theme = Theme.of(_context).brightness == Brightness.light
              ? ThemeData.light(useMaterial3: true)
              : ThemeData.dark(useMaterial3: true);
        default:
          _theme = ThemeData.dark(useMaterial3: true);
      }
    });

    return _theme;
  }

  Future<String> get getThemeName async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String theme = prefs.getString("theme") ?? "dark";
    switch (theme.toLowerCase()) {
      case "dark":
        return "Dark";
      case "light":
        return "Light";
      case "amoled":
        return "Amoled";
      case "system":
        return "System";
      default:
        return "Dark";
    }
  }

  set setTheme(String theme) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("theme", theme);
      notifyListeners();
    });
    // print("setTheme() called $theme");
    switch (theme) {
      case "dark":
        _theme = ThemeData.dark(useMaterial3: true);
        break;
      case "light":
        _theme = ThemeData.light(useMaterial3: true);
        break;
      case "amoled":
        _theme = oledTheme;
        break;
      case "system":
        _theme = Theme.of(_context).brightness == Brightness.light
            ? ThemeData.light(useMaterial3: true)
            : ThemeData.dark(useMaterial3: true);
        // _theme = ThemeData(
        //   primarySwatch: Colors.blue,
        //   visualDensity: VisualDensity.adaptivePlatformDensity,
        // );
        break;
      default:
        _theme = ThemeData.dark(useMaterial3: true);
    }
  }

  // oled theme
  final ThemeData oledTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    primarySwatch: Colors.blue,
    primaryColor: Colors.black,
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.white),
      displayMedium: TextStyle(color: Colors.white),
      displaySmall: TextStyle(color: Colors.white),
    ),
    cardTheme: const CardTheme(
      color: Colors.black,
      shadowColor: Colors.white,
    ),
    cardColor: Colors.black,
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.blue,
      colorScheme: ColorScheme.dark(),
      textTheme: ButtonTextTheme.primary,
    ),
    listTileTheme: const ListTileThemeData(
      tileColor: Colors.transparent,
      iconColor: Colors.white,
      textColor: Colors.white,
    ),
    dividerColor: Colors.white,
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.black,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.white,
    ),
  );
}
