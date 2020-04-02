import "package:flutter/material.dart";
class Pages_State extends State<Pages>{
  List _pages = [ Text("home"), Text("Body Profile"), Text("Calories Log"), Text("Weight Chart")];
  int _current_index = 0;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Poundora", 
          style: TextStyle(fontSize: 30.0, 
          fontWeight: FontWeight.bold, 
          color:Colors.white
          ))
        ),
      body: Center(
          child: _pages[_current_index]
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility),
            title: Text("Body Profile")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            title: Text("Calories Log")
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            title: Text("Weight Chart")
          )
        ],
        currentIndex: _current_index,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap:(int index){
          setState(() {
            _current_index = index;
          });
        }
      )
    );
  }

}
class Pages extends StatefulWidget{
  @override 
  Pages_State  createState() => Pages_State();
}
