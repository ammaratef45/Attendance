import 'dart:async';
import 'dart:convert';

import 'package:attendance/backend/attendance.dart';
import 'package:attendance/backend/session.dart';
import 'package:attendance/backend/user.dart';
import 'package:attendance/homePage/home_page.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:attendance/dialogs.dart';

///Business logic
abstract class HomePageViewModel extends State<HomePage> {
  ///Construct Home page Viewmodel
  HomePageViewModel() {
    auth.currentUser().then((FirebaseUser user) {
      _mUser = user;
      setState(() {
        if (_mUser.email != null) {
          mail = _mUser.email;
        }
        if (_mUser.displayName != null) {
          name = _mUser.displayName;
        }
        if (_mUser.photoUrl != null) {
          imageUrl = _mUser.photoUrl;
        }
        _fillData();
      });
    });
  }

  ///l items
  List<Attendance> litems = <Attendance>[];

  ///u items
  List<Attendance> uitems = <Attendance>[];

  ///FB Auth object
  final FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseUser _mUser;

  ///User mail address
  String mail = '';

  ///User image url
  String imageUrl = '';

  ///User fullname
  String name = '';

  ///perform sign out
  void signOut() {
    auth.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  ///open details
  Future<void> openDetails(Attendance model) async {
    await Navigator.of(context).pushNamed('/details', arguments: model);
    await _fillData();
  }

  /// perform scan
  Future<void> scan() async {
    String scanResult = "Scan Error: Make sure you're scanning the right code";
    try {
      final String barcode = await BarcodeScanner.scan();
      final String uid = _mUser.uid;
      final Session session = Session.fromMap(json.decode(barcode));
      // @todo #48 save locally and call api /newsession instead of using firebase database
      final DatabaseReference sessionRef = FirebaseDatabase.instance
          .reference()
          .child(session.adminUID)
          .child('classes')
          .child(session.classKey)
          .child('sessions')
          .child(session.key);
      final DatabaseReference attendanceRef =
      FirebaseDatabase.instance.reference().child('attendances').push();
      final DateTime now = DateTime.now();
      final Map<String, dynamic> map = <String, dynamic>{};
      map['session'] = session.key;
      map['sessionClass'] = session.classKey;
      map['sessionAdmin'] = session.adminUID;
      map['user'] = uid;
      map['arriveTime'] = now.toIso8601String();
      map['leaveTime'] = 'NULL';
      await attendanceRef.set(map);
      await sessionRef.child('attended').push().set(attendanceRef.key);
      await FirebaseDatabase.instance
          .reference()
          .child(uid)
          .child('attended')
          .push()
          .set(attendanceRef.key);
      setState(() {
        scanResult = 'scanned successfully';
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        scanResult = 'You did not grant the camera permission!';
      } else {
        scanResult = 'Unknown error: $e';
      }
    } on FormatException {
      print('Scan Cancelled');
    } on Exception catch (e) {
      scanResult = 'Error: $e';
    }
    await Dialogs.messageDialog(context, 'result', scanResult);
  }

  // @todo #102 remove litems and uitems and get them from user as future.
  Future<void> _fillData() async {
    litems.clear();
    uitems.clear();
    for(Attendance m in await User().attended()){
      if (m.leaveDate == 'NULL') {
        uitems.add(m);
      } else {
        litems.add(m);
      }
    }
    setState(() {
      
    });
  }
}
