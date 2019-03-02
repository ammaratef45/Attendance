import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './login_page_viewmodel.dart';

class LoginPageView extends LoginPageViewModel {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Login"),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new RaisedButton(
              child: new Text("Sign In"),
              onPressed: ()=>signInUser().then((FirebaseUser user)=>handleUser(user)),
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
