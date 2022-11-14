// The purpose of this file is to fetch the categories from the database

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as Http;
import 'dart:convert';
import 'package:jellybook/providers/fetchBooks.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<List<Map<String, dynamic>>> getServerCategories(context) async {
  debugPrint("getting server categories");
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('accessToken') ?? "";
  final url = prefs.getString('server') ?? "";
  final userId = prefs.getString('UserId') ?? "";
  final client = prefs.getString('client') ?? "JellyBook";
  final device = prefs.getString('device') ?? "";
  final deviceId = prefs.getString('deviceId') ?? "";
  final version = prefs.getString('version') ?? "1.0.6";
  debugPrint("got prefs");
  Map<String, String> headers =
      getHeaders(url, client, device, deviceId, version, token);
  final response = await Http.get(
    Uri.parse(url + "/Users/" + userId + "/Views"),
    headers: headers,
  );

  debugPrint("got response");
  debugPrint(response.statusCode.toString());
  debugPrint(response.body);
  final data = await json.decode(response.body);

  bool hasComics = true;
  if (hasComics) {
    String comicsId = '';
    String etag = '';
    List<String> categories = [];
    // add all data['Items'] to categories
    data['Items'].forEach((item) {
      categories.add(item['Name']);
    });
    List<String> selected = await chooseCategories(categories, context);
    List<Future<List<Map<String, dynamic>>>> comicsArray = [];
    debugPrint("selected: " + selected.toString());
    for (int i = 0; i < data['Items'].length; i++) {
      if (selected.contains(data['Items'][i]['Name'])) {
        comicsId = data['Items'][i]['Id'];
        etag = data['Items'][i]['Etag'];
        comicsArray.add(getComics(comicsId, etag));
      }
    }
    // once all the comics are fetched, combine them into one list
    List<Map<String, dynamic>> comics = [];
    for (int i = 0; i < comicsArray.length; i++) {
      comics.addAll(await comicsArray[i]);
    }
    debugPrint("Returning comics");
    return comics;
  } else {
    debugPrint('No comics found');
  }
  return [];
}

Future<List<String>> chooseCategories(List<String> categories, context) async {
  List<String> selected = [];

  debugPrint("Getting categories");

  // pop up a dialog to choose categories
  // use stateful builder to rebuild the dialog when the list changes
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Choose Categories'),
            content: Container(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(categories[index]),
                    value: selected.contains(categories[index]),
                    onChanged: (bool? value) {
                      if (value == true &&
                          !selected.contains(categories[index])) {
                        selected.add(categories[index]);
                        // debugPrint(selected.toString() + " added");
                      } else if (value == false &&
                          selected.contains(categories[index])) {
                        selected.remove(categories[index]);
                        // debugPrint(selected.toString() + " removed");
                      }
                      setState(() {});
                    },
                  );
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Done'),
                onPressed: () {
                  if (selected != null && selected.isNotEmpty) {
                    Navigator.of(context).pop();
                  } else {
                    debugPrint("No categories selected");
                    // snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No categories selected'),
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
  return selected;
}
