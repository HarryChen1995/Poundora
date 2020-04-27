import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_database/firebase_database.dart";
import "dart:async";

class progress_bar extends LinearProgressIndicator
    implements PreferredSizeWidget {
  progress_bar({
    Key key,
    double value,
    Color backgroundColor,
    Animation<Color> valueColor,
  }) : super(
          key: key,
          value: value,
          backgroundColor: backgroundColor,
          valueColor: valueColor,
        ) {
    preferredSize = Size(double.infinity, 0.1);
  }

  @override
  Size preferredSize;
}

class Sign_Up_State extends State<Sign_Up_Page> {
  final _first_name = TextEditingController();
  final _last_name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmed_password = TextEditingController();
  final _current_weight = TextEditingController();
  final _weight_goal = TextEditingController();
  final _height = TextEditingController();
  final _signupKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseDatabase.instance.reference();
  bool _isloading;
  String _gender;
  showErrorMessage(BuildContext context, String err) {
    Widget ok = FlatButton(
      child:
          Text("OK", style: TextStyle(color: Theme.of(context).primaryColor)),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Sign Up Failed", style: TextStyle(color: Colors.red)),
      content: Text(err, style: TextStyle(color: Colors.red)),
      actions: [
        ok,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showVerifyEmail(BuildContext context) {
    Widget ok = FlatButton(
      child:
          Text("OK", style: TextStyle(color: Theme.of(context).primaryColor)),
      onPressed: () {
        Navigator.pushReplacementNamed(context, "/login");
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Please Verify Your Email"),
      content: Text("A link of verfication has sent to your email"),
      actions: [
        ok,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<AuthResult> SignUp(String email, String password) async {
    AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return result;
  }

  Widget isLoading(BuildContext context) {
    if (_isloading) {
      return progress_bar(
          backgroundColor: Colors.white,
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor));
    }
    return null;
  }

  bool checkHeight(String value) {
    return value.trim().contains(RegExp(r"^[1-9]\d*(\.\d+)?$"));
  }

  bool checkWeight(String value) {
    return value.trim().contains(RegExp(r"^[1-9]\d*(\.\d+)?$"));
  }

  bool checkName(String value) {
    return value.trim().contains(RegExp(r"[^a-zA-Z]"));
  }

  bool checkEmail(String value) {
    return value.trim().contains(RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'));
  }

  bool checkPassword(String value) {
    return value.length <= 6;
  }

  @override
  void initState() {
    _isloading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Register",
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            bottom: isLoading(context)),
        body: Form(
            key: _signupKey,
            child: ListView(children: <Widget>[
              SizedBox(height: 20),
              Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                    controller: _first_name,
                    decoration: InputDecoration(
                        icon: Icon(Icons.person), hintText: "First Name"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please Enter Your First Name";
                      }
                      if (checkName(value)) {
                        return "Invalid First Name";
                      }
                      return null;
                    },
                  )),
              SizedBox(height: 20),
              Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                    controller: _last_name,
                    decoration: InputDecoration(
                        icon: Icon(Icons.person), hintText: "Last Name"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please Enter Your Last Name";
                      }
                      if (checkName(value)) {
                        return "Invalid Last Name";
                      }
                      return null;
                    },
                  )),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: DropdownButtonFormField(
                    value: _gender,
                    icon: Icon(Icons.arrow_downward),
                    iconEnabledColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                        icon: Icon(Icons.person), hintText: "Gender"),
                    validator: (value) {
                      if (value == null) {
                        return "Please Select Your Gender";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                    items: <String>["Male", "Female"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()),
              ),
              SizedBox(height: 20),
              Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                    controller: _current_weight,
                    decoration: InputDecoration(
                      icon: Icon(Icons.accessibility),
                      hintText: "Current Weight (lb)",
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please Enter Your Current Weight";
                      }
                      if (!checkWeight(value)) {
                        return "Please Enter Valid Current Weight";
                      }
                      return null;
                    },
                  )),
              SizedBox(height: 20),
              Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                    controller: _weight_goal,
                    decoration: InputDecoration(
                      icon: Icon(Icons.accessibility),
                      hintText: "Weight Goal (lb)",
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please Enter Your Weight Goal";
                      }
                      if (!checkWeight(value)) {
                        return "Please Enter Valid Weight Goal";
                      }
                      if (double.parse(value) >=
                          double.parse(_current_weight.text)) {
                        return "Your Weight Goal Should Be Less Than Current Weight";
                      }
                      return null;
                    },
                  )),
              SizedBox(height: 20),
              Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                    controller: _height,
                    decoration: InputDecoration(
                      icon: Icon(Icons.accessibility),
                      hintText: "Height (feet and inches)",
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please Enter Your Height";
                      }
                      if (!checkHeight(value)) {
                        return "Please Enter Valid Height";
                      }
                      return null;
                    },
                  )),
              SizedBox(height: 20),
              Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        icon: Icon(Icons.email), hintText: "Email"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please Enter Your Email";
                      }
                      if (!checkEmail(value)) {
                        return "Invalid Email";
                      }
                      return null;
                    },
                  )),
              SizedBox(height: 20),
              Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
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
                      if (checkPassword(value.trim())) {
                        return "Password Must Be Greater Than 6 Characters";
                      }
                      return null;
                    },
                  )),
              SizedBox(height: 20),
              Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
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
                      if (value != _password.text) {
                        return "Passwords Dont Match";
                      }
                      return null;
                    },
                  )),
              SizedBox(height: 20),
              Container(
                  padding: EdgeInsets.fromLTRB(150, 0, 150, 0),
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      color: Theme.of(context).primaryColor,
                      onPressed: () async {
                        if (_signupKey.currentState.validate()) {
                          setState(() {
                            _isloading = true;
                          });
                          try {
                            AuthResult result = await SignUp(
                                _email.text, _confirmed_password.text);
                            await result.user.sendEmailVerification();
                            setState(() {
                              _isloading = false;
                            });
                            showVerifyEmail(context);
                            await _db
                                .child("Users")
                                .push()
                                .set({
                              "first_name": _first_name.text,
                              "last_name": _last_name.text,
                              "email": _email.text,
                              "gender": _gender,
                              "current_weight": int.parse(_current_weight.text),
                              "weight_goal": int.parse(_weight_goal.text),
                              "height": double.parse(_height.text),
                              "user_id": result.user.uid
                            });
                            _first_name.clear();
                            _last_name.clear();
                            _password.clear();
                            _email.clear();
                            _confirmed_password.clear();
                            _current_weight.clear();
                            _weight_goal.clear();
                            _height.clear();
                          } catch (e) {
                            setState(() {
                              _isloading = false;
                              _signupKey.currentState.reset();
                            });
                            showErrorMessage(context, e.message);
                          }
                        }
                      },
                      child: Text("Submit",
                          style: TextStyle(color: Colors.white))))
            ])));
  }
}

class Sign_Up_Page extends StatefulWidget {
  @override
  Sign_Up_State createState() => Sign_Up_State();
}
