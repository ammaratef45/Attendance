import 'package:attendance/BackEnd/user.dart';
import 'package:attendance/ProfilePage/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class ProfilePageViewModel extends State<ProfilePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser mUser;
  String imageUrl = "";
  String name = "";
  TextEditingController nativeNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  ProfilePageViewModel() {
    auth.currentUser().then((FirebaseUser user) {
      mUser = user;
      setState(() {
        if (mUser.displayName != null) {
          name = mUser.displayName;
        }
        if (mUser.photoUrl != null) {
          imageUrl = mUser.photoUrl;
        }
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

  void _updateNativeName() {
    User.instance().rename(nativeNameController.text);
    print("Native name is: : ${nativeNameController.text}");
  }

  void _updatephoneNumber() {
    User.instance().changePhone(phoneNumberController.text);
    print("Native name is: : ${phoneNumberController.text}");
  }
}
