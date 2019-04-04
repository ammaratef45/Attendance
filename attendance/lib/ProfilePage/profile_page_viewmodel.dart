import 'package:attendance/ProfilePage/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class ProfilePageViewModel extends State<ProfilePage> {
  final auth = FirebaseAuth.instance;
  FirebaseUser mUser;
  String imageUrl = "";
  String name = "";
  String nativeName = "";
  String phoneNumber = "";
  final nativeNameController = TextEditingController();
  final phoneNumberController = TextEditingController();

  ProfilePageViewModel() {
    auth.currentUser().then((user) {
      mUser = user;
      setState(() {
        if (mUser.displayName != null) name = mUser.displayName;
        if (mUser.photoUrl != null) imageUrl = mUser.photoUrl;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    nativeNameController.addListener(_updateNativeName);
    phoneNumberController.addListener(_updatephoneNumber);
  }

  @override
  void dispose() {
    super.dispose();
    nativeNameController.dispose();
    phoneNumberController.dispose();
  }

  _updateNativeName() {
    nativeName = nativeNameController.text;
    print("Native name is: : ${nativeNameController.text}");
  }

  _updatephoneNumber() {
    phoneNumber = phoneNumberController.text;
    print("Native name is: : ${phoneNumberController.text}");
  }
}
