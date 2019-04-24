import 'package:attendance/ProfilePage/profile_page.dart';
import 'package:attendance/backend/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// @todo #26 add country field.
// @todo #26 show error below the entry field if failed to
///  set the value to the user object.
abstract class ProfilePageViewModel extends State<ProfilePage> {
  ///Construct ProfileViewModel
  ProfilePageViewModel() {
    _auth.currentUser().then((FirebaseUser user) {
      _mUser = user;
      setState(() {
        if (_mUser.displayName != null) {
          name = _mUser.displayName;
        }
        if (_mUser.photoUrl != null) {
          imageUrl = _mUser.photoUrl;
        }
      });
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _mUser;

  ///Profile image URL
  String imageUrl = '';

  ///Profile Username
  String name = '';

  ///Native name field controller
  TextEditingController nativeNameController = TextEditingController();

  ///Native name field controller
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nativeNameController.addListener(_updateNativeName);
    phoneNumberController.addListener(_updatePhoneNumber);
  }

  @override
  void dispose() {
    super.dispose();
    nativeNameController.dispose();
    phoneNumberController.dispose();
  }

  void _updateNativeName() {
    User.instance().rename(nativeNameController.text);
  }

  void _updatePhoneNumber() {
    User.instance().changePhone(phoneNumberController.text);
  }
}
