import 'dart:convert';

import 'package:app/models/login_response.dart';
import 'package:app/views/wallet/list_of_wallets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/services/base_config.dart';

class LoginPage extends StatefulWidget {
  final String title;
  const LoginPage({Key? key, required this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPagePageState();
}

class _LoginPagePageState extends State<LoginPage> {
  bool rememberMe = false;
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  _LoginPagePageState() {
    init();
  }

  void init() async {
    var remember = await storage.read(key: "rememberMe") ?? "false";
    if (remember == "true") {
      setState(() {
        setFields();
      });
    }
  }

  void setFields() async {
    rememberMe = true;
    _loginController.text = await storage.read(key: "login") ?? "";
    _passwordController.text = await storage.read(key: "password") ?? "";
  }

  void displayDialog(
          BuildContext context, String title, String text) =>
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(title: Text(title), content: Text(text)));

  Future<LoginResponse?> attemptLogin(String login, String password) async {
    var uri = Uri.parse("$api/user/login");
    var body = json.encode({"login": login, "password": password});
    var res = await http.post(uri, body: body, headers: headers(""));
    if (res.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(res.body));
    }
    return null;
  }

  Future<int> attemptSignup(String login, String password) async {
    var uri = Uri.parse("$api/user/register");
    var body = json.encode({"login": login, "password": password});
    var res = await http.post(uri, body: body, headers: headers(""));
    return res.statusCode;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text("Account")),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _loginController,
                decoration: const InputDecoration(labelText: "Login"),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              CheckboxListTile(
                  title: const Text("Remember me"),
                  value: rememberMe,
                  onChanged: (value) {
                    setState(() {
                      rememberMe = value ?? false;
                    });
                  }),
              TextButton(
                child: const Text("Log In"),
                onPressed: () async {
                  var login = _loginController.text;
                  var password = _passwordController.text;

                  var jwt = await attemptLogin(login, password);
                  if (jwt != null) {
                    storage.write(key: "jwt", value: jwt.token);
                    if (rememberMe) {
                      storage.write(key: "login", value: login);
                      storage.write(key: "password", value: password);
                      storage.write(
                          key: "rememberMe", value: rememberMe.toString());
                    } else {
                      storage.delete(key: "rememberMe");
                      storage.delete(key: "login");
                      storage.delete(key: "password");
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ListOfWallets()));
                  } else {
                    displayDialog(context, "Error",
                        "No user with that credentials found");
                  }
                },
              ),
              TextButton(
                child: const Text("Sign Up"),
                onPressed: () async {
                  var login = _loginController.text;
                  var password = _passwordController.text;

                  var res = await attemptSignup(login, password);
                  if (res == 200) {
                    displayDialog(context, "Success", "Account created.");
                  } else {
                    displayDialog(context, "Error", "An error occured.");
                  }
                },
              )
            ],
          )));
}
