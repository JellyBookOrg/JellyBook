// The purpose of thsi file is to have a screen where the users
// can see all their comics and manage them

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as Http;
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:jellybook/screens/info_screen.dart';
import 'package:jellybook/providers/fetchBooks.dart';
import 'package:jellybook/providers/fetchCategories.dart';
import 'package:turn_page_transition/turn_page_transition.dart';
import 'package:jellybook/screens/settings_screen.dart';

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

// should be a futureBuilder
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {},
        ),
        title: Text('Home'),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.settings),
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         PageRouteBuilder(
        //           transitionDuration: Duration(milliseconds: 500),
        //           pageBuilder: (context, animation, secondaryAnimation) =>
        //               SettingsScreen(),
        //           transitionsBuilder:
        //               (context, animation, secondaryAnimation, child) {
        //             var begin = Offset(1.0, 0.0);
        //             var end = Offset.zero;
        //             var curve = Curves.ease;
        //
        //             var tween = Tween(begin: begin, end: end)
        //                 .chain(CurveTween(curve: curve));
        //
        //             return SlideTransition(
        //               position: animation.drive(tween),
        //               child: child,
        //             );
        //           },
        //         ),
        //       );
        //     },
        //   ),
        // ],
      ),
      body: FutureBuilder(
        future: getServerCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              itemCount: snapshot.data?.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        // TurnPageRoute(
                        //   turningPoint: 0.5,
                        //   transitionDuration: Duration(milliseconds: 500),
                        //   builder: (context) => InfoScreen(
                        //     title: snapshot.data![index]['name'] ?? "null",
                        //     imageUrl:
                        //         (snapshot.data![index]['imagePath'] ?? "null"),
                        //     description:
                        //         snapshot.data![index]['description'] ?? "null",
                        //     tags: snapshot.data![index]['tags'] ?? ["null"],
                        //     url: snapshot.data![index]['url'] ?? "null",
                        //     year:
                        //         snapshot.data![index]['releaseDate'] ?? "null",
                        //     stars: snapshot.data![index]['rating'] ?? -1,
                        //     path: snapshot.data![index]['path'] ?? "null",
                        //     comicId: snapshot.data![index]['id'] ?? "null",
                        //   ),
                        // ),
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  InfoScreen(
                            title: snapshot.data![index]['name'] ?? "null",
                            imageUrl:
                                (snapshot.data![index]['imagePath'] ?? "null"),
                            description:
                                snapshot.data![index]['description'] ?? "null",
                            tags: snapshot.data![index]['tags'] ?? ["null"],
                            url: snapshot.data![index]['url'] ?? "null",
                            year:
                                snapshot.data![index]['releaseDate'] ?? "null",
                            stars: snapshot.data![index]['rating'] ?? -1,
                            path: snapshot.data![index]['path'] ?? "null",
                            comicId: snapshot.data![index]['id'] ?? "null",
                          ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = Offset(1.0, 0.0);
                            var end = Offset.zero;
                            var curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            // add a shadow to the image
                            child: Image.network(
                              snapshot.data![index]['imagePath'],
                              width:
                                  MediaQuery.of(context).size.width / 4 * 0.8,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Flexible(
                          child: Text(snapshot.data![index]['name'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width /
                                    4 *
                                    0.115,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        if (snapshot.data![index]['releaseDate'] != "null")
                          Text(snapshot.data![index]['releaseDate'],
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width /
                                      4 *
                                      0.11,
                                  // set color to a very light grey
                                  color: Colors.grey)),
                        // check if screen is > 600
                        if (MediaQuery.of(context).size.width > 600)
                          Flexible(
                            child: SingleChildScrollView(
                              child: Html(
                                data: snapshot.data![index]['description'],
                                style: {
                                  "body": Style(
                                    fontSize: FontSize(
                                      MediaQuery.of(context).size.width /
                                          2 *
                                          0.03,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                },
                              ),
                            ),
                          ),
                        // add a icon button to the card
                      ],
                    ),
                  ),
                );
              },
            );
            // fixed version
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
