import "package:flutter/material.dart";
import "log_in.dart";
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
          home: FirebaseDemoScreen()
      );
    }
}
