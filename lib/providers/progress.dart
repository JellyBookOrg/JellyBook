// the purpose of this file is to save and fetch the progress of the user

import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveProgress(int page, String comicId) async {
  var prefs = await SharedPreferences.getInstance();
  // double progress = page / pageNums;
  // prefs.setDouble(comicId + "_progress", progress);
  prefs.setInt(comicId + "_pageNum", page);
  print("saved progress");
  print("page num: $page");
}

Future<int> getProgress(String comicId) async {
  var prefs = await SharedPreferences.getInstance();
  int pageNum = prefs.getInt(comicId + "_pageNum") ?? 0;
  // double progress = prefs.getDouble(comicId + "_progress") ?? 0.0;
  print("page returned: $pageNum");
  return pageNum;
}
