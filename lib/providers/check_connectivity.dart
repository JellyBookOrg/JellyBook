// The purpose of this file is to check if the server is reachable
// This will be used on first connection along with every time you load the app

import 'package:flutter/material.dart';

// this should return a bool
class CheckConnectivity extends ChangeNotifier {
  static Future<bool> checkServer(String url) async {
    bool _isReachable = false;
    try {
      // try to ping website
    } catch (e) {
      debugPrint(e.toString());
    }
    return _isReachable;
  }
}
