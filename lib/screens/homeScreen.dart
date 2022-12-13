// The purpose of this file is to have a screen where the users
// can see all their comics and manage them

import 'package:flutter/material.dart';
import 'package:jellybook/providers/fetchCategories.dart';
import 'package:jellybook/models/login.dart';
import 'package:isar/isar.dart';
import 'package:auto_size_text/auto_size_text.dart';

// Screens imports
import 'package:jellybook/screens/MainScreens/mainMenu.dart';
import 'package:jellybook/screens/MainScreens/settingsScreen.dart';
import 'package:jellybook/screens/MainScreens/downloadsScreen.dart';
import 'package:jellybook/screens/collectionScreen.dart';
import 'package:jellybook/screens/infoScreen.dart';
import 'package:jellybook/screens/loginScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /*
           Heres what this should look like:
           - should be a grid view of cards
           - each comic should have its own card
           - the cards should have:
                - a photo
                - the title
                - the release data if known
                - a more info button
                - a progress bar if book has been started
           - At the bottom will be a bar witch will contain the following sections:
                - a library section
                - a search section
                - a settings section
        */

  Future<void> logout() async {
    final isar = Isar.getInstance();
    var logins = await isar!.logins.where().findAll();
    var loginIds = logins.map((e) => e.isarId).toList();
    await isar.writeTxn(() async {
      isar.logins.deleteAll(loginIds);
      debugPrint('deleted ${loginIds.length} logins');
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  int _selectedIndex = 0;
  final List<Widget> screens = [
    MainMenu(),
    DownloadsScreen(),
    // CollectionScreen(),
    // InfoScreen(),
    SettingsScreen(),
  ];

// should be a futureBuilder
  @override
  Widget build(BuildContext context) {
    // have the body be the selected screen
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        // child: BottomNavigationBar(
        //   type: BottomNavigationBarType.fixed,
        //   showSelectedLabels: false,
        //   showUnselectedLabels: false,
        //   selectedItemColor: Colors.pink,
        //   unselectedItemColor: Colors.grey,
        //   iconSize: 24,
        //   // make active one bold
        //   selectedIconTheme: const IconThemeData(
        //     size: 30,
        //   ),
        //   currentIndex: _selectedIndex,
        //   onTap: (index) {
        //     setState(() {
        //       _selectedIndex = index;
        //     });
        //   },
        //   items: const <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.home),
        //       label: 'Home',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.search),
        //       label: 'Search',
        //     ),
        //     // Downloaded Screen
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.download),
        //       label: 'Downloads',
        //     ),
        //     // continue reading screen
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.book),
        //       label: 'Continue Reading',
        //     ),
        //     // Settings Screen
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.settings),
        //       label: 'Settings',
        //     ),
        //   ],
        // ),
        // use a row to make the bottom navigation bar
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Home Screen
            IconButton(
              icon: const Icon(Icons.home),
              // make the color a gradient between #AA5CC3 and #00A4DC if selected
              color:
                  _selectedIndex == 0 ? const Color(0xFFAA5CC3) : Colors.grey,
              iconSize: _selectedIndex == 0 ? 30 : 24,
              splashColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
            // Search Screen
            IconButton(
              iconSize: _selectedIndex == 1 ? 30 : 24,
              color:
                  _selectedIndex == 1 ? const Color(0xFFAA5CC3) : Colors.grey,
              splashColor: Colors.transparent,
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
            ),
            // Downloaded Screen
            IconButton(
              icon: const Icon(Icons.download),
              color:
                  _selectedIndex == 2 ? const Color(0xFFAA5CC3) : Colors.grey,
              iconSize: _selectedIndex == 2 ? 30 : 24,
              splashColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  _selectedIndex = 2;
                });
              },
            ),
            // continue reading screen
            IconButton(
              icon: const Icon(Icons.book),
              color:
                  _selectedIndex == 3 ? const Color(0xFFAA5CC3) : Colors.grey,
              iconSize: _selectedIndex == 3 ? 30 : 24,
              splashColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  _selectedIndex = 3;
                });
              },
            ),
            // Settings Screen
            IconButton(
              icon: const Icon(Icons.settings),
              color:
                  _selectedIndex == 4 ? const Color(0xFFAA5CC3) : Colors.grey,
              iconSize: _selectedIndex == 4 ? 30 : 24,
              splashColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  _selectedIndex = 4;
                  // go to settings screen
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
