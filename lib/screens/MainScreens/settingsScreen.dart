// The purpose of this file is to allow the user to change the settings of the app

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

/* The following are the settings that the user can change
   - the theme of the app (System, Light, Dark, Amoled, Custom)
   - the language of the app (English will be the only one for now)
   - page transition (page turn, slide)
   - Enable experimental features
   */

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    Settings.init();
    getPackageInfo();
  }

  String version = '';

  Future<void> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontSize: 20)),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            const SizedBox(
              height: 40,
            ),
            // should be comprised of widgets
            themeSettings(),
            const SizedBox(
              height: 20,
            ),
            languageSettings(),
            const SizedBox(
              height: 20,
            ),
            pageTransitionSettings(),
            const SizedBox(
              height: 20,
            ),
            experimentalFeaturesSettings(),
            SizedBox(
              // depends on screen size
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            aboutSettings(),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  // theme settings (future builder to get the current theme and then change it)
  Widget themeSettings() => DropDownSettingsTile(
        settingKey: 'theme',
        title: 'Theme',
        selected: Settings.getValue<String>('theme') ?? 'System',
        leading: const Icon(Icons.color_lens),
        values: <String, String>{
          'System': 'System',
          'Light': 'Light',
          'Dark': 'Dark',
          'Amoled': 'Amoled',
          'Custom': 'Custom',
        },
        onChange: (value) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('theme', value.toString());
        },
      );

  // language settings
  Widget languageSettings() => DropDownSettingsTile(
        settingKey: 'language',
        title: 'Language',
        selected: Settings.getValue<String>('language') ?? 'English',
        leading: Icon(Icons.language),
        values: <String, String>{
          'English': 'English',
        },
        onChange: (value) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('language', value.toString());
        },
      );

  // page transition settings
  Widget pageTransitionSettings() => DropDownSettingsTile(
        settingKey: 'pageTransition',
        title: 'Page Transition',
        selected: Settings.getValue<String>('pageTransition') ?? 'Page Turn',
        leading: Icon(Icons.pageview),
        values: <String, String>{
          'Page Turn': 'Page Turn',
          'Slide': 'Slide',
        },
        onChange: (value) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('pageTransition', value.toString());
        },
      );

  // experimental features settings
  Widget experimentalFeaturesSettings() => SwitchSettingsTile(
        settingKey: 'experimentalFeatures',
        title: 'Experimental Features',
        leading: Icon(Icons.bug_report),
        onChange: (value) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('experimentalFeatures', value);
        },
      );

  // about settings (should contain the version number and the link to the github repo, and author)
  Widget aboutSettings() => Container(
        // future builder to get the version number
        child: FutureBuilder(
          future: getPackageInfo(),
          builder: (context, snapshot) {
            return Column(
              children: [
                // version number (should be a future builder)
                Text(
                  'Version: ' + (version.isNotEmpty ? version : 'Unknown'),
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Made by Kara Wilson",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                // insert https://github.com/Kara-Zor-El/JellyBook
                InkWell(
                  child: Text(
                    "https://github.com/Kara-Zor-El/JellyBook",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                    ),
                  ),
                  onTap: () async {
                    try {
                      if (await canLaunchUrl(
                        Uri.parse("https://github.com/Kara-Zor-El/JellyBook"),
                      )) {
                        await launchUrl(
                          Uri.parse("https://github.com/Kara-Zor-El/JellyBook"),
                        );
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  },
                ),
              ],
            );
          },
        ),
      );
}
