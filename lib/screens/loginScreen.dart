// This Files purpose is to have a login screen where the user can login into the server
import 'package:flutter/material.dart';
import 'package:jellybook/providers/login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jellybook/screens/homeScreen.dart';
import 'package:jellybook/screens/offlineBookReader.dart';
import 'package:logger/logger.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
// optional inputs of url, username, and password (use empty string if not provided)
  final String? url;
  final String? username;
  final String? password;
  LoginScreen({this.url = "", this.username = "", this.password = ""});

  @override
  _LoginScreenState createState() => _LoginScreenState(
        url: url,
        username: username,
        password: password,
      );
}

class _LoginScreenState extends State<LoginScreen> {
  // optional inputs of url, username, and password (use empty string if not provided)
  final String? url;
  final String? username;
  final String? password;
  _LoginScreenState({
    required this.url,
    required this.username,
    required this.password,
  });

  final storage = FlutterSecureStorage();
  final _url = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _passwordVisible = false;
  bool _loading = false;
  String _error = '';
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    // check_url();
    _passwordVisible = false;
    // check if url and username are provided
    if (url != "" && url != null && username != "" && username != null) {
      _loading = true;
      logger.d("url: " + url!);
      logger.d("username: " + username!);
      logger.d("password: " + password!);
      LoginProvider.loginStatic(
        url!,
        username!,
        password!,
      ).then((value) {
        if (value == "true") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        } else {
          setState(() {
            _error = value;
            _loading = false;
          });
        }
      });
    }
  }

  // FocusNodes
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "JellyBook",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              // make it work on android TV
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
                child: TextFormField(
                  controller: _url,
                  focusNode: _focusNode1,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.pageLoginAddress,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
                child: TextFormField(
                  controller: _username,
                  focusNode: _focusNode2,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.pageLoginUsername,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
                child: TextFormField(
                  controller: _password,
                  focusNode: _focusNode3,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.pageLoginPassword,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                // width dynamically sized of the button
                width: MediaQuery.of(context).size.width - 50,
                height: 50,
                child: ElevatedButton(
                  focusNode: _focusNode4,
                  onPressed: () async {
                    setState(() {
                      _loading = true;
                    });
                    logger.d("url: " + _url.text);
                    logger.d("username: " + _username.text);
                    logger.d("password: " + _password.text);
                    LoginProvider.loginStatic(
                      _url.text,
                      _username.text,
                      _password.text,
                    ).then((value) {
                      if (value == "true") {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      } else {
                        setState(() {
                          _error = value;
                          _loading = false;
                        });
                      }
                    });
                  },
                  // make it say Connect and have a icon
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.login),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Connect", style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // offline mode button
              SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                height: 50,
                child: ElevatedButton(
                  focusNode: _focusNode5,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  onPressed: () async {
                    setState(() {
                      _loading = true;
                    });
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => OfflineBookReader()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.cloud_off_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Offline Reader", style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 15,
              ),
              // if (_error != '')
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
                child: Text(
                  _error,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
