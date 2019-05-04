import 'dart:async';
import 'dart:convert';

import 'package:attendance/AttendanceDatailsPage/attendance_details_page.dart';
import 'package:flutter/material.dart';
import 'package:attendance/backend/attendance.dart';
import 'package:attendance/backend/session.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:attendance/scan_exceptions.dart';
import 'package:firebase_admob/firebase_admob.dart';
/// view model of attendance page
abstract class AttendanceDetailsPageViewModel
extends State<AttendanceDetailsPage> {
  /// constructor
  AttendanceDetailsPageViewModel() {
    FirebaseAdMob
    .instance.initialize(appId: 'ca-app-pub-5308838739950508~2647148134');
    _myBanner
      ..load()
      ..show(
        anchorOffset: 60,
        anchorType: AnchorType.bottom,
      );
    _model = Attendance.selected;
    className = _model.className;
    session = _model.date;
    arriveDate = 'Arrived: ${_model.arriveDate}';
    leaveDate = 'Leaved: ${_model.leaveDate}';
    if(_model.leaveDate == 'NULL') {
      isLeaved = false;
    }
  }
  /// check if session scanned for leaving
  bool isLeaved = true;
  Attendance _model;
  /// name of the current class
  String className;
  /// name of the current session
  String session;
  /// date of arriving
  String arriveDate;
  /// date of leaving
  String leaveDate;
  /// result of scanning
  String scanResult;
  final BannerAd _myBanner = BannerAd(
    adUnitId: 'ca-app-pub-5308838739950508/6605562688',
    size: AdSize.smartBanner,
    listener: (MobileAdEvent event) {
      print('BannerAd event is $event');
    },
  );
  
  /// sacn
  Future<void> scan() async {
    try {
      final String barcode = await BarcodeScanner.scan();
      final Session session = Session.fromMap(json.decode(barcode));
      // @todo #51 save locally and call api.leaveSession and
      //  remove firebase admin usage
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      final String uid = user.uid;
      final DatabaseReference attendanceRef =
        FirebaseDatabase.instance
        .reference().child('attendances').child(_model.key);
      final DataSnapshot oldModel = await attendanceRef.once();
      if(oldModel.value['session'] != session.key) {
        throw InvalidSessionException('this is not the same session code');
      }
      final DateTime now = DateTime.now();
      final Map<String, dynamic> map = <String, dynamic>{
        'session' : session.key,
        'sessionClass' : session.classKey,
        'sessionAdmin' : session.adminUID,
        'user' : uid,
        'arriveTime' : _model.arriveDate,
        'leaveTime' : now.toIso8601String()
      };
      await attendanceRef.set(map);
      await FirebaseDatabase.instance
        .reference().child(uid).child('attended').push().set(attendanceRef.key);
      setState(() {
      isLeaved = true;
      scanResult = '';
      _model.leave(now.toIso8601String());
      leaveDate = 'Leaved: ${_model.leaveDate}';
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          scanResult = 'You did not grant the camera permission!';
        });
      } else {
        setState(() => scanResult = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => scanResult = 'Scan cancelled');
    } on InvalidSessionException catch(e){
      setState(() {
        scanResult = e.cause;
      });
    } on Exception catch (e) {
      setState(() => scanResult = 'Unknown error: $e');
    }
  }

}