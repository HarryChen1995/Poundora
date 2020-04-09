import "package:flutter/material.dart";
import 'package:poundora/pages/sign_up.dart';
import "package:poundora/pages/log_in.dart";
import "package:poundora/pages/home_page.dart";
void main()=>runApp(Poundora_App());
// Main App
class  Poundora_App extends StatelessWidget {
    @override
    Widget build(BuildContext context){
      return MaterialApp(
          title: "Poundora App",
          theme: ThemeData( 
            primaryColor : Colors.purple,
            textTheme: TextTheme(
              body1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)
            )
            ),
          initialRoute: "/login",
          routes: {
            "/login": (BuildContext context) => LogIn_Page(),
            "/signup": (BuildContext context) => Sign_Up_Page(),
            "/home" : (BuildContext context) => Home_Page()
          },
      );
    }
}
