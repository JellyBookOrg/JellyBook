// The purpose of thsi file is to have a screen where the users
// can see all their comics and manage them

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as Http;
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:jellybook/providers/check_connectivity.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:jellybook/screens/info_screen.dart';

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

/* Example curl:
     curl 'http://[REDACTED]/Users/[REDACTED]/Views' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:107.0) Gecko/20100101 Firefox/107.0' -H 'Accept: application/json' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate' -H 'X-Emby-Authorization: MediaBrowser Client="Jellyfin Web", Device="Firefox", DeviceId="[REDACTED]", Version="10.8.5", Token="[REDACTED]"' -H 'Connection: keep-alive'
        */

Future<List<Map<String, dynamic>>> getServerCategories() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final url = prefs.getString('server');
  final userId = prefs.getString('UserId');
  final client = prefs.getString('client');
  final device = prefs.getString('device');
  final deviceId = prefs.getString('deviceId');
  final version = prefs.getString('version');
  final response = await Http.get(
    Uri.parse('$url/Users/$userId/Views'),
    headers: {
      'Accept': 'application/json',
      'Accept-Language': 'en-US,en;q=0.5',
      'Accept-Encoding': 'gzip, deflate',
      'X-Emby-Authorization':
          'MediaBrowser Client="$client", Device="$device", DeviceId="$deviceId", Version="$version", Token="$token"',
      'Connection': 'keep-alive',
    },
  );
  final data = await json.decode(response.body);
  bool hasComics = true;
  if (hasComics) {
    String comicsId = '';
    String etag = '';
    data['Items'].forEach((item) {
      if (item['Name'] == 'Comics') {
        comicsId = item['Id'];
        etag = item['Etag'];
      }
    });
    Future<List<Map<String, dynamic>>> comics = getComics(
      comicsId,
      etag,
    );
    debugPrint("Returning comics");
    return comics;
  } else {
    debugPrint('No comics found');
  }
  return [];
}

// get comics
Future<List<Map<String, dynamic>>> getComics(
    String comicsId, String etag) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final url = prefs.getString('server');
  final userId = prefs.getString('UserId');
  final client = prefs.getString('client');
  final device = prefs.getString('device');
  final deviceId = prefs.getString('deviceId');
  final version = prefs.getString('version');
  prefs.setString('comicsId', comicsId);
  final response = Http.get(
    Uri.parse('$url/Users/$userId/Items' +
        '?StartIndex=0' +
        '&Fields=PrimaryImageAspectRatio,SortName,Path,SongCount,ChildCount,MediaSourceCount,Tags,Overview' +
        '&Filters=IsNotFolder' +
        '&ImageTypeLimit=1' +
        '&ParentId=$comicsId' +
        '&Recursive=true' +
        '&SortBy=SortName' +
        '&SortOrder=Ascending'),
    headers: {
      'Accept': 'application/json',
      'Connection': 'keep-alive',
      'Accept-Language': 'en-US,en;q=0.5',
      'Accept-Encoding': 'gzip, deflate',
      'X-Emby-Authorization':
          'MediaBrowser Client="$client", Device="$device", DeviceId="$deviceId", Version="$version", Token="$token"',
    },
  );
  var responseData;
  await response.then((value) {
    debugPrint(value.body);
    responseData = json.decode(value.body);
  });

  List<Map<String, dynamic>> comics = [];
  for (var i = 0; i < responseData['Items'].length; i++) {
    if (responseData['Items'][i]['Type'] == 'Book') {
      comics.add({
        'id': responseData['Items'][i]['Id'] ?? '',
        'name': responseData['Items'][i]['Name'] ?? '',
        'imagePath':
            "$url/Items/${responseData['Items'][i]['Id']}/Images/Primary?fillHeight=316&fillWidth=200&quality=90&Tag=${responseData['Items'][i]['ImageTags']['Primary']}",
        if (responseData['Items'][i]['ImageTags']['Primary'] == null)
          'imagePath': "https://via.placeholder.com/200x316?text=No+Cover+Art",
        'releaseDate': responseData['Items'][i]['ProductionYear'].toString(),
        'path': responseData['Items'][i]['Path'] ?? '',
        'description': responseData['Items'][i]['Overview'] ?? '',
        'url': url ?? '',
        if (responseData['Items'][i]['CommunityRating'] != null)
          'rating': responseData['Items'][i]['CommunityRating'].toDouble(),
        'tags': responseData['Items'][i]['Tags'] ?? [],
      });
      debugPrint(responseData['Items'][i]['Name']);
    }
  }
  return comics;
}
