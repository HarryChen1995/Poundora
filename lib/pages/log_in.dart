import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:shared_preferences/shared_preferences.dart";

class LogIn_State extends State<LogIn_Page> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _loginKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool _isloading;
  Widget isLoading(BuildContext context) {
    if (_isloading) {
      return Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor)));
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

  showRequireVerifyEmail(BuildContext context) {
    Widget ok = FlatButton(
      child:
          Text("OK", style: TextStyle(color: Theme.of(context).primaryColor)),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Log In Failed", style: TextStyle(color: Colors.red)),
      content: Text(
          "Your account is not verified! The verfication link had sent to your email. please verify your account, then come back and retry",
          style: TextStyle(color: Colors.red)),
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

  Future<AuthResult> sign_in(String email, String password) async {
    AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return result;
  }

  void login() async {
    if (_loginKey.currentState.validate()) {
      setState(() {
        _isloading = true;
      });
      try {
        AuthResult result = await sign_in(_email.text, _password.text);
        setState(() {
          _isloading = false;
        });
        if (result.user.isEmailVerified) {
          _email.clear();
          _password.clear();
          final SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString("User_Id", result.user.uid);
          Navigator.pushReplacementNamed(context, "/home");
        } else {
          showRequireVerifyEmail(context);
        }
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
  void initState() {
    _isloading = false;
    super.initState();
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
                      radius: 80,
                      backgroundColor: Colors.white12,
                      backgroundImage: AssetImage("assets/icon/icon.png")),
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
                  isLoading(context),
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
