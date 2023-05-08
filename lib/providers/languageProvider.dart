// the purpose of this file is to write a extension to the Localizations class to set a new locale

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleChangeNotifier extends ChangeNotifier {
  LocaleChangeNotifier(BuildContext context, SharedPreferences prefs) {
    _locale = Locale(prefs.getString("localeString") ?? "en");
  }
  Locale _locale = Locale("en");

  // async function to get the locale from shared preferences
  Locale get locale {
    SharedPreferences.getInstance().then((prefs) {
      return Locale(prefs.getString("localeString") ?? "en");
    });
    return _locale;
  }

  set setLocale(String localeString) {
    _locale = Locale(localeString);
    // save the locale to shared preferences
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("localeString", localeString);
      notifyListeners();
    });
    notifyListeners();
  }
}
