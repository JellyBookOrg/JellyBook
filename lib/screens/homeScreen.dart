// The purpose of this file is to have a screen where the users
// can see all their comics and manage them

import 'package:flutter/material.dart';
import 'package:jellybook/models/login.dart';
import 'package:isar/isar.dart';

// Screens imports
import 'package:jellybook/screens/MainScreens/mainMenu.dart';
import 'package:jellybook/screens/MainScreens/settingsScreen.dart';
import 'package:jellybook/screens/MainScreens/downloadsScreen.dart';
import 'package:jellybook/screens/MainScreens/continueReadingScreen.dart';
import 'package:jellybook/screens/loginScreen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

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
    ContinueReadingScreen(),
    SettingsScreen(),
  ];

// should be a futureBuilder
  @override
  Widget build(BuildContext context) {
    // have the body be the selected screen
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      body: screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 8, bottom: 15),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            activeColor: Colors.white,
            tabBorderRadius: 15,
            tabBackgroundGradient: LinearGradient(
              colors: [
                const Color(0xFFAA5CC3).withOpacity(0.75),
                const Color(0xFF00A4DC).withOpacity(0.75),
              ],
            ),
            haptic: true,
            iconSize: 24,
            gap: 8,
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 7),
            duration: Duration(milliseconds: 600),
            tabBackgroundColor: Theme.of(context).primaryColor,
            color: Colors.white,
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.download,
                text: 'Downloads',
              ),
              GButton(
                icon: Icons.book,
                text: 'Reading',
              ),
              // GButton(
              //   icon: Icons.settings,
              //   text: 'Settings',
              // ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
        // child: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: <Widget>[
        //     // Home Screen
        //     IconButton(
        //       icon: const Icon(Icons.home),
        //       color:
        //           _selectedIndex == 0 ? const Color(0xFFAA5CC3) : Colors.grey,
        //       iconSize: _selectedIndex == 0 ? 30 : 24,
        //       splashColor: Colors.transparent,
        //       onPressed: () {
        //         setState(() {
        //           _selectedIndex = 0;
        //         });
        //       },
        //     ),
        //     // // Search Screen
        //     // IconButton(
        //     //   iconSize: _selectedIndex == 1 ? 30 : 24,
        //     //   color:
        //     //       _selectedIndex == 1 ? const Color(0xFFAA5CC3) : Colors.grey,
        //     //   splashColor: Colors.transparent,
        //     //   icon: const Icon(Icons.search),
        //     //   onPressed: () {
        //     //     setState(() {
        //     //       _selectedIndex = 1;
        //     //     });
        //     //   },
        //     // ),
        //     // Downloaded Screen
        //     IconButton(
        //       icon: const Icon(Icons.download),
        //       color:
        //           _selectedIndex == 1 ? const Color(0xFFAA5CC3) : Colors.grey,
        //       iconSize: _selectedIndex == 1 ? 30 : 24,
        //       splashColor: Colors.transparent,
        //       onPressed: () {
        //         setState(() {
        //           _selectedIndex = 1;
        //         });
        //       },
        //     ),
        //     // continue reading screen
        //     IconButton(
        //       icon: const Icon(Icons.book),
        //       color:
        //           _selectedIndex == 2 ? const Color(0xFFAA5CC3) : Colors.grey,
        //       iconSize: _selectedIndex == 2 ? 30 : 24,
        //       splashColor: Colors.transparent,
        //       onPressed: () {
        //         setState(() {
        //           _selectedIndex = 2;
        //         });
        //       },
        //     ),
        //     // Settings Screen
        //     // IconButton(
        //     //   icon: const Icon(Icons.settings),
        //     //   color:
        //     //       _selectedIndex == 3 ? const Color(0xFFAA5CC3) : Colors.grey,
        //     //   iconSize: _selectedIndex == 3 ? 30 : 24,
        //     //   splashColor: Colors.transparent,
        //     //   onPressed: () {
        //     //     setState(() {
        //     //       _selectedIndex = 3;
        //     //       // go to settings screen
        //     //     });
        //     //   },
        //     // ),
        //   ],
        // ),
      ),
    );
  }
}
