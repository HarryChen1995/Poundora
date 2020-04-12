import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";

class LogIn_State extends State<LogIn_Page> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _loginKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool _isloading;
  Widget isLoading() {
    if (_isloading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  showErrorMessage(BuildContext context, String err) {
    Widget ok = FlatButton(
      child:
          Text("OK", style: TextStyle(color: Theme.of(context).primaryColor)),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Log In Failed", style: TextStyle(color: Colors.red)),
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

  @override
  void initState() {
    _isloading = false;
    super.initState();
  }

  Future<String> sign_in(String email, String password) async {
    AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return result.user.uid;
  }

  void login() async {
    if (_loginKey.currentState.validate()) {
      setState(() {
        _isloading = true;
      });
      try {
        String uid = await sign_in(_email.text, _password.text);
        _email.clear();
        _password.clear();
        setState(() {
          _isloading = false;
        });
        Navigator.pushReplacementNamed(context, "/home");
      } catch (e) {
        setState(() {
          _isloading = false;
          _loginKey.currentState.reset();
        });
        showErrorMessage(context, e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _loginKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage("assets/icon/logo.jpg")),
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
                          return null;
                        },
                      )),
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: TextFormField(
                        controller: _password,
                        decoration: InputDecoration(
                            icon: Icon(Icons.lock), hintText: "Password"),
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter Your Password";
                          }
                          return null;
                        },
                      )),
                  isLoading(),
                  RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      color: Theme.of(context).primaryColor,
                      onPressed: login,
                      child: Text("Log In",
                          style: TextStyle(color: Colors.white))),
                  FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/signup");
                      },
                      child: Text("Sign Up",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)))
                ])));
  }
}

class LogIn_Page extends StatefulWidget {
  @override
  LogIn_State createState() => LogIn_State();
}
