import 'dart:async';
import 'dart:convert';

import 'package:attendance/AttendanceDatailsPage/attendance_details_page.dart';
import 'package:flutter/material.dart';
import 'package:attendance/backend/session.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
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
  }
  
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

      if(widget.model.key != session.key) {
        throw Exception('this is not the same session code');
      }
      final DateTime now = DateTime.now();
      widget.model.leave(now.toIso8601String());
      // @todo #59 add save functionality to attendance.
      //  then uncomment the line below.
      
      //widget.model.save();
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
    } on Exception catch (e) {
      setState(() => scanResult = 'Error: $e');
    }
  }

}