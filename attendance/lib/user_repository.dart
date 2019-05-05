import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  /// Determine if user is signed in or not
  Future<bool> isSignedIn() async => (await auth.currentUser()) != null;

  /// Sign user in
  Future<FirebaseUser> signInUser() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final FirebaseUser firebaseUser = await auth.signInWithGoogle(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    FirebaseDatabase.instance
        .reference()
        .child(firebaseUser.uid)
        .child('name')
        .set(firebaseUser.displayName);
    FirebaseDatabase.instance
        .reference()
        .child(firebaseUser.uid)
        .child('mail')
        .set(firebaseUser.email);
    FirebaseDatabase.instance
        .reference()
        .child(firebaseUser.uid)
        .child('photo')
        .set(firebaseUser.photoUrl);
    return firebaseUser;
  }
}
