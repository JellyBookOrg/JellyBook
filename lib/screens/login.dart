// This Files purpose is to have a login screen where the user can login into the server
import 'package:flutter/material.dart';
import 'package:jellybook/providers/login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jellybook/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final storage = FlutterSecureStorage();
  final _url = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _passwordVisible = false;
  bool _loading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    // check_url();
    _passwordVisible = false;
  }

  // FocusNodes
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();

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
                  decoration: const InputDecoration(
                    labelText: "Server Address",
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
                  decoration: const InputDecoration(
                    labelText: "Username",
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
                    labelText: "Password",
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
                height: 15,
              ),
              Container(
                // width dynamically sized of the button
                width: MediaQuery.of(context).size.width - 50,
                height: 50,
                child: ElevatedButton(
                  focusNode: _focusNode4,
                  onPressed: () async {
                    setState(() {
                      _loading = true;
                    });
                    debugPrint(_url.text);
                    debugPrint(_username.text);
                    debugPrint(_password.text);
                    Login.loginStatic(
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
                  child: const Text("Connect",
                      style: TextStyle(
                        fontSize: 20,
                      )),
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
