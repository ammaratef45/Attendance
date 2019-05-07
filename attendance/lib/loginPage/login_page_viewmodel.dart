import 'dart:async';
import 'package:attendance/backend/user.dart';
import 'package:attendance/loginPage/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
/// view-model of login page
abstract class LoginPageViewModel extends State<LoginPage> {
  /// constructor
  LoginPageViewModel() {
    _auth.currentUser().then((FirebaseUser user) {
      if (user != null) {
        handleUser(user);
      }
    });
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn =  GoogleSignIn();

  /// call signIn routine
  Future<FirebaseUser> signInUser() async {
    final GoogleSignInAccount googleSignInAccount =
      await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
    final FirebaseUser firebaseUser = await _auth.signInWithGoogle(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    return firebaseUser;
  }

  /// handle signed in user
  void handleUser(FirebaseUser user) {
    if (user == null) {
      Fluttertoast.showToast(
          msg: 'Failed to login',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1);
    } else {
      User()
      ..nameMe(user.displayName)
      ..assignEmail(user.email)
      ..changePicture(user.photoUrl)
      ..save();
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }
}
