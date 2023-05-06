import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChangeNotifier extends ChangeNotifier {
  ThemeChangeNotifier(BuildContext context, SharedPreferences prefs) {
    _theme = ThemeData.dark();
    _theme = getTheme;
    _context = context;
  }

  late ThemeData _theme;
  // ThemeData _theme = ThemeData(
  //   primarySwatch: Colors.blue,
  //   visualDensity: VisualDensity.adaptivePlatformDensity,
  //   // useMaterial3: true,
  // );

  // late BuildContext _context;
  late BuildContext _context;

  // get the theme from shared preferences
  ThemeData get getTheme {
    print("getTheme() called ${_theme.toString()}");
    SharedPreferences.getInstance().then((prefs) {
      String theme = prefs.getString("theme") ?? "dark";
      print("getTheme() called $theme");
      switch (theme) {
        case "dark":
          _theme = ThemeData.dark();
          return ThemeData.dark();
        case "light":
          _theme = ThemeData.light();
          return ThemeData.light();
        case "amoled":
          _theme = oledTheme;
          return oledTheme;
        case "system":
          if (WidgetsBinding.instance.window.platformBrightness ==
              Brightness.light) {
            _theme = ThemeData.light();
            return ThemeData.light();
          } else {
            _theme = ThemeData.dark();
            return ThemeData.dark();
          }
        default:
          _theme = ThemeData.dark();
          return ThemeData.dark();
      }
    });
    return _theme;
  }

  Future<String> get getThemeName async {
    print("getTheme() called ${_theme.toString()}");
    String theme = "dark";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    theme = prefs.getString("theme") ?? "dark";
    print("getTheme() called $theme");
    switch (theme) {
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
    print("setTheme() called $theme");
    switch (theme) {
      case "dark":
        _theme = ThemeData.dark();
        break;
      case "light":
        _theme = ThemeData.light();
        break;
      case "amoled":
        _theme = oledTheme;
        break;
      case "system":
        if (WidgetsBinding.instance.window.platformBrightness ==
            Brightness.light) {
          _theme = ThemeData.light();
        } else {
          _theme = ThemeData.dark();
        }
        // _theme = ThemeData(
        //   primarySwatch: Colors.blue,
        //   visualDensity: VisualDensity.adaptivePlatformDensity,
        // );
        break;
      default:
        _theme = ThemeData.dark();
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
