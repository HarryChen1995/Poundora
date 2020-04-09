import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_database/firebase_database.dart";

class Sign_Up_State extends State<Sign_Up_Page> {
  final _first_name = TextEditingController();
  final _last_name  = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmed_password = TextEditingController();
  final _signupKey = GlobalKey<FormState>();

  final  _auth = FirebaseAuth.instance;
  final  _db = FirebaseDatabase.instance.reference();

  bool checkName(String value){ 
    return value.trim().contains(RegExp(r"[^a-zA-Z]"));
  }
  bool checkEmail(String value){
    return value.trim().contains(RegExp( r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'));
  }
  bool checkPassword(String value){
    return value.length < 5;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _signupKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Register",
                  style: TextStyle(fontSize: 35)),
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child:  TextFormField(
                              controller: _first_name,
                              decoration: InputDecoration(
                                icon: Icon(Icons.person),
                                hintText: "First Name"
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please Enter Your First Name";
                                }
                                if (checkName(value)){
                                  return "Invalid First Name";
                                }
                                return null;
                              },
                            )
                          ),
                                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child:TextFormField(
                              controller: _last_name,
                              decoration: InputDecoration(
                                icon: Icon(Icons.person),
                                hintText: "Last Name"
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please Enter Your Last Name";
                                }
                                if (checkName(value)){
                                  return "Invalid Last Name";
                                }
                                return null;
                              },
                            )
                          ),
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child:TextFormField(
                              controller: _email,
                              keyboardType:TextInputType.emailAddress,
                              decoration: InputDecoration(
                                icon: Icon(Icons.email),
                                hintText: "Email"
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please Enter Your Email";
                                }
                                if (!checkEmail(value)){
                                  return "Invalid Email";
                                }
                                return null;
                              },
                            )
                          ),
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child:TextFormField(
                              controller: _password,
                              decoration: InputDecoration(
                                icon: Icon(Icons.lock),
                                hintText: "Password",
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please Enter Your Password";
                                }
                                if (checkPassword(value.trim())){
                                  return "Password Must Be Greater Than 5 Characters";
                                }
                                return null;
                              },
                            )
                          ),
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child:TextFormField(
                              controller: _confirmed_password,
                              decoration: InputDecoration(
                                icon: Icon(Icons.lock),
                                hintText: "Confirm Password",
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please Confirm Your Password";
                                }
                                if (value != _password.text){
                                  return "Passwords Dont Match";
                                }
                                return null;
                              },
                            )
                          ),
                  RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(30)),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (_signupKey.currentState.validate()) {
                          _auth.createUserWithEmailAndPassword(email: _email.text, password: _confirmed_password.text)
                          .then((result){
                            _db.child("Users").child(result.user.uid).set(
                              {
                                "firstname": _first_name.text,
                                "lastname": _last_name.text,
                                "email": _email.text
                              }
                            ).then((result){
                              _first_name.clear();
                              _last_name.clear();
                              _password.clear();
                              _email.clear();
                              _confirmed_password.clear();
                              Navigator.pushReplacementNamed(context, "/login");
                            });
                          });
                        }
                      },
                      child: Text("Sign Up", style: TextStyle(color: Colors.white),)),
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Go Back", style: TextStyle(color: Theme.of(context).primaryColor)))
                ])));
  }
}

class Sign_Up_Page extends StatefulWidget {
  @override
  Sign_Up_State createState() => Sign_Up_State();
}
