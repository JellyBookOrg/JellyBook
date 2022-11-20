// The purpose of this file is to have a screen where the users
// can see all their comics and manage them

import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'package:dio/dio.dart';
import 'package:jellybook/screens/infoScreen.dart';
import 'package:jellybook/providers/fetchBooks.dart';
import 'package:jellybook/screens/settingsScreen.dart';
import 'package:jellybook/providers/fetchCategories.dart';
import 'package:jellybook/screens/databaseViewer.dart';
import 'package:jellybook/providers/folderProvider.dart';
import 'package:jellybook/models/folder.dart';
import 'package:jellybook/screens/collectionScreen.dart';

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
        actions: [
          IconButton(
            icon: Icon(Icons.bug_report),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DatabaseViewer(),
                ),
              );
            },
          ),
        ],
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
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          // text align left side of the column
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "Collections",
                style: TextStyle(
                  // size is the size of a title
                  fontSize: 30,
                  // decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          FutureBuilder(
            future: getServerCategories(context, returnFolders: true),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                debugPrint("snapshot data: ${snapshot.data}");
                return Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 6 * 1.2,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: InkWell(
                            onTap: () {
                              debugPrint("tapped");
                              debugPrint(
                                  "snapshot data: ${snapshot.data[index]['id']}");
                              debugPrint(
                                  "snapshot data: ${snapshot.data[index]['name']}");
                              debugPrint(
                                  "snapshot data: ${snapshot.data[index]['image']}");
                              debugPrint(
                                  "snapshot data: ${snapshot.data[index]['bookIds']}");
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      collectionScreen(
                                    folderId: snapshot.data[index]['id'],
                                    name: snapshot.data[index]['name'],
                                    image: snapshot.data[index]['image'],
                                    bookIds: snapshot.data[index]['bookIds'],
                                  ),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
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
                                  height: 10 *
                                      MediaQuery.of(context).size.height /
                                      1000,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 10 *
                                          MediaQuery.of(context).size.width /
                                          1000,
                                      right: 10 *
                                          MediaQuery.of(context).size.width /
                                          1000),
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      snapshot.data![index]['name'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                4 *
                                                0.13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                // start all images at the same height rather than same offset
                                SizedBox(
                                  height: 5 *
                                      MediaQuery.of(context).size.height /
                                      1000,
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
                                      snapshot.data![index]['image'],
                                      height:
                                          MediaQuery.of(context).size.height /
                                              6 *
                                              0.8,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Container(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          // page break
          const Divider(
            height: 5,
            thickness: 5,
            indent: 0,
            endIndent: 0,
          ),
          const SizedBox(
            height: 10,
          ),
          // text align left side of the column
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "Library",
                style: TextStyle(
                  // size is the size of a title
                  fontSize: 30,
                  // decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          // vertical list of books
          FutureBuilder(
            future: getServerCategories(context, returnFolders: false),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                debugPrint("snapshot data: ${snapshot.data}");
                return Expanded(
                  // use grid view to make the list of books
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      return Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        InfoScreen(
                                  title:
                                      snapshot.data![index]['name'] ?? "null",
                                  imageUrl: (snapshot.data![index]
                                          ['imagePath'] ??
                                      "null"),
                                  description: snapshot.data![index]
                                          ['description'] ??
                                      "null",
                                  tags:
                                      snapshot.data![index]['tags'] ?? ["null"],
                                  url: snapshot.data![index]['url'] ?? "null",
                                  year: snapshot.data![index]['releaseDate'] ??
                                      "null",
                                  stars: snapshot.data![index]['rating'] ?? -1,
                                  path: snapshot.data![index]['path'] ?? "null",
                                  comicId:
                                      snapshot.data![index]['id'] ?? "null",
                                ),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
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
                                    height: MediaQuery.of(context).size.height /
                                        6 *
                                        0.8,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              // auto size text to fit the width of the card (max 2 lines)
                              Flexible(
                                child: Text(snapshot.data![index]['name'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      // auto size the text
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              4 *
                                              0.13,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              if (snapshot.data![index]['releaseDate'] !=
                                  "null")
                                Text(snapshot.data![index]['releaseDate'],
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                4 *
                                                0.12,
                                        // set color to a very light grey
                                        color: Colors.grey)),
                              // check if screen is > 600
                              if (MediaQuery.of(context).size.width > 600)
                                Flexible(
                                  child: SingleChildScrollView(
                                    child: Text(
                                        snapshot.data![index]['description'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2 *
                                              0.03,
                                        )),
                                  ),
                                ),
                              // add a icon button to the card
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: snapshot.data!.length,
                  ),
                );
              } else {
                return Container(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),

          // FutureBuilder(
          //   future: getServerCategories(context),
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       return GridView.builder(
          //         itemCount: snapshot.data?.length,
          //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //             crossAxisCount: 2),
          //         itemBuilder: (context, index) {
          //           return Card(
          //             child: InkWell(
          //               onTap: () {
          //                 Navigator.push(
          //                   context,
          //                   PageRouteBuilder(
          //                     pageBuilder:
          //                         (context, animation, secondaryAnimation) =>
          //                             InfoScreen(
          //                       title: snapshot.data![index]['name'] ?? "null",
          //                       imageUrl: (snapshot.data![index]['imagePath'] ??
          //                           "null"),
          //                       description: snapshot.data![index]
          //                               ['description'] ??
          //                           "null",
          //                       tags: snapshot.data![index]['tags'] ?? ["null"],
          //                       url: snapshot.data![index]['url'] ?? "null",
          //                       year: snapshot.data![index]['releaseDate'] ??
          //                           "null",
          //                       stars: snapshot.data![index]['rating'] ?? -1,
          //                       path: snapshot.data![index]['path'] ?? "null",
          //                       comicId: snapshot.data![index]['id'] ?? "null",
          //                     ),
          //                     transitionsBuilder: (context, animation,
          //                         secondaryAnimation, child) {
          //                       var begin = Offset(1.0, 0.0);
          //                       var end = Offset.zero;
          //                       var curve = Curves.ease;
          //
          //                       var tween = Tween(begin: begin, end: end)
          //                           .chain(CurveTween(curve: curve));
          //
          //                       return SlideTransition(
          //                         position: animation.drive(tween),
          //                         child: child,
          //                       );
          //                     },
          //                   ),
          //                 );
          //               },
          //               child: Column(
          //                 children: <Widget>[
          //                   SizedBox(
          //                     height: 10,
          //                   ),
          //                   Container(
          //                     decoration: BoxDecoration(
          //                       borderRadius: BorderRadius.circular(8),
          //                       boxShadow: [
          //                         BoxShadow(
          //                           color: Colors.black.withOpacity(0.4),
          //                           spreadRadius: 5,
          //                           blurRadius: 7,
          //                           offset: Offset(0, 3),
          //                         ),
          //                       ],
          //                     ),
          //                     child: ClipRRect(
          //                       borderRadius: BorderRadius.circular(8),
          //                       // add a shadow to the image
          //                       child: Image.network(
          //                         snapshot.data![index]['imagePath'],
          //                         width: MediaQuery.of(context).size.width /
          //                             4 *
          //                             0.8,
          //                         fit: BoxFit.fitWidth,
          //                       ),
          //                     ),
          //                   ),
          //                   const SizedBox(
          //                     height: 10,
          //                   ),
          //                   Flexible(
          //                     child: Text(snapshot.data![index]['name'],
          //                         textAlign: TextAlign.center,
          //                         style: TextStyle(
          //                           fontSize:
          //                               MediaQuery.of(context).size.width /
          //                                   4 *
          //                                   0.12,
          //                           fontWeight: FontWeight.bold,
          //                         )),
          //                   ),
          //                   const SizedBox(
          //                     height: 5,
          //                   ),
          //                   if (snapshot.data![index]['releaseDate'] != "null")
          //                     Text(snapshot.data![index]['releaseDate'],
          //                         style: TextStyle(
          //                             fontSize:
          //                                 MediaQuery.of(context).size.width /
          //                                     4 *
          //                                     0.12,
          //                             // set color to a very light grey
          //                             color: Colors.grey)),
          //                 ],
          //               ),
          //             ),
          //           );
          //         },
          //       );
          //       // fixed version
          //     } else {
          //       return const Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
