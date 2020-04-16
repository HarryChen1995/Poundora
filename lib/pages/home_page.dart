import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";

import 'package:shared_preferences/shared_preferences.dart';

class Home_State extends State<Home_Page> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List _pages = [
    Text("home"),
    Text("Body Profile"),
    Text("Calories Log"),
    Text("Weight Chart")
  ];
  int _current_index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Poundora",
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.white)),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              color: Colors.white,
              tooltip: "Sign Out",
              onPressed: () async {
                final SharedPreferences pref =
                    await SharedPreferences.getInstance();
                pref.setString("User_Id", null);
                await _auth.signOut();
                Navigator.pushReplacementNamed(context, "/login");
              },
            )
          ],
        ),
        body: Center(child: _pages[_current_index]),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), title: Text("Home")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.accessibility), title: Text("Body Profile")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.pie_chart), title: Text("Calories Log")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.show_chart), title: Text("Weight Chart"))
            ],
            currentIndex: _current_index,
            selectedItemColor: Theme.of(context).primaryColor,
            onTap: (int index) {
              setState(() {
                _current_index = index;
              });
            }));
  }
}

class Home_Page extends StatefulWidget {
  @override
  Home_State createState() => Home_State();
}
