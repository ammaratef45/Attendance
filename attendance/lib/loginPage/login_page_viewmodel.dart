import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import './login_page.dart';

abstract class LoginPageViewModel extends State<LoginPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  LoginPageViewModel() {
    auth.currentUser().then((user) {
      if (user != null) {
        handleUser(user);
      }
    });
  }

  Future<FirebaseUser> signInUser() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;
    FirebaseUser firebaseUser = await auth.signInWithGoogle(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    return firebaseUser;
  }

  void handleUser(FirebaseUser user) {
    if (user == null) {
      Fluttertoast.showToast(
          msg: "Failed to login",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1);
    } else {
      FirebaseDatabase.instance
          .reference()
          .child(user.uid)
          .child("name")
          .set(user.displayName);
      FirebaseDatabase.instance
          .reference()
          .child(user.uid)
          .child("mail")
          .set(user.email);
      FirebaseDatabase.instance
          .reference()
          .child(user.uid)
          .child("photo")
          .set(user.photoUrl);
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }
}
