// The purpose of this file is to fetch the categories from the database

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as Http;
import 'dart:convert';
import 'package:jellybook/providers/fetchBooks.dart';
import 'package:flutter/foundation.dart';

// database imports
import 'package:jellybook/models/entry.dart';

Future<List<Map<String, dynamic>>> getServerCategories() async {
  debugPrint("getting server categories");
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('accessToken') ?? "";
  final url = prefs.getString('server') ?? "";
  final userId = prefs.getString('UserId') ?? "";
  final client = prefs.getString('client') ?? "JellyBook";
  final device = prefs.getString('device') ?? "";
  final deviceId = prefs.getString('deviceId') ?? "";
  final version = prefs.getString('version') ?? "1.0.5";
  debugPrint("got prefs");
  Map<String, String> headers =
      getHeaders(url, client, device, deviceId, version, token);
  final response = await Http.get(
    Uri.parse(url + "/Users/" + userId + "/Views"),
    headers: headers,
  );

  // final response = await Http.get(
  //   Uri.parse('$url/Users/$userId/Views'),
  //   headers: headers,
  // );
  debugPrint("got response");
  debugPrint(response.statusCode.toString());
  debugPrint(response.body);
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
