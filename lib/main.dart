import "package:flutter/material.dart";
import 'package:poundora/pages/sign_up.dart';
import "package:poundora/pages/log_in.dart";
import "package:poundora/pages/home_page.dart";
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(Poundora_App());

// Main App
class Poundora_App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Poundora App",
      theme: ThemeData(
          primaryColor: Colors.purple,
          textTheme: TextTheme(
              body1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold))),
      home: Initial_Page(),
      routes: {
        "/login": (BuildContext context) => LogIn_Page(),
        "/signup": (BuildContext context) => Sign_Up_Page(),
        "/home": (BuildContext context) => Home_Page()
      },
    );
  }
}

class Initial_State extends State<Initial_Page> {
  bool isLogin = false;
  void auto_login() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final String user_id = pref.getString("User_Id");
    if (user_id != null) {
      setState(() {
        isLogin = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    auto_login();
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin == true) {
      return Home_Page();
    }
    return LogIn_Page();
  }
}

class Initial_Page extends StatefulWidget {
  @override
  Initial_State createState() => Initial_State();
}
