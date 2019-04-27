import 'dart:async';
import 'dart:convert';
import 'package:attendance/db/database.dart';
import 'package:attendance/backend/scan_model.dart';
import 'package:attendance/backend/session.dart';
import 'package:attendance/offline_page/offline_page.dart';
import 'package:attendance/scan_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_admob/firebase_admob.dart';

/// View model of the offline page
abstract class OfflinePageViewModel extends State<OfflinePage> {
  /// constructor
  OfflinePageViewModel() {
    FirebaseAdMob.instance.initialize(
      appId: 'ca-app-pub-5308838739950508~2647148134'
    );
    _myBanner
      ..load()
      ..show(
        anchorOffset: 60,
        anchorType: AnchorType.bottom,
      );
    getScans();
  }
  String _scanResult = "Scan Error: Make sure you're scanning the right code";
  /// List of offline scans that aren't registered
  List<Scan> scanedList = <Scan>[];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _mUser;
  final BannerAd _myBanner = BannerAd(
    adUnitId: 'ca-app-pub-5308838739950508/3820629006',
    size: AdSize.smartBanner,
    listener: (MobileAdEvent event) {
      print('BannerAd event is $event');
    },
  );

  /// show dialog (should be overriden in the view)
  void showMessageDialog(String title, String message) {}

  /// load scans form database
  Future<void> getScans() async {
    scanedList
    ..clear()
    ..addAll(await DBProvider.db.getAllScans());
    setState(() {
    });
  }
  /// scan a QR code.
  Future<void> scan() async {
    try {
      final String barcode = await BarcodeScanner.scan();
      Session session = Session.fromMap(json.decode(barcode));
      DateTime now = DateTime.now();
      Scan scan =Scan(key: session.key, classKey: session.classKey, admin: session.adminUID, arrive: now.toIso8601String());
      DBProvider.db.newScan(scan);
      getScans();
      this._scanResult = "Scanned Successfully";
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this._scanResult = 'You did not grant the camera permission!';
        });
      } else {
        setState(() => this._scanResult = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => print('Scan Cancelled'));
    } on Exception catch (e) {
      setState(() => print('Unknown error: $e'));
    }
    showMessageDialog("scan", this._scanResult);
  }

  Future<void> scanLeave(int index) async {
    try {
      String barcode = await BarcodeScanner.scan();
      Session session = Session.fromMap(json.decode(barcode));
      if(session.key!=scanedList[index].key) {
        throw InvalidSessionException("This is not the same session you attended");
      }
      DateTime now = DateTime.now();
      scanedList[index].leave = now.toIso8601String();
      DBProvider.db.addLeaveToScan(scanedList[index]);
      getScans();
      this._scanResult = "Scanned Successfully";
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this._scanResult = 'You did not grant the camera permission!';
        });
      } else {
        setState(() => this._scanResult = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this._scanResult = 'Scan cancelled');
    } on InvalidSessionException {
      setState(() => this._scanResult = "This is not the same session you attended");
    } on Exception catch (e) {
      setState(() => this._scanResult = 'Unknown error: $e');
    }
    showMessageDialog("scan", this._scanResult);
  }

  void deleteItem(int index) {
    DBProvider.db.deleteScan(scanedList[index].id);
    getScans();
  }

  Future<void> testConnection() async {
    String message = "You are not connected to internet";
    ConnectivityResult connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      message = "You are connected to mobile data";
    } else if (connectivityResult == ConnectivityResult.wifi) {
      message = "You are connected to wifi";
    }
    showMessageDialog("test", message);
  }

  // @todo #9 use /newsession instead of database as in online
  Future<void> registerMe(int index) async {
    String message = "";
    if(!(await isLoggedIn())) {
      message = "Not loggedin, login first";
    } else if(true /*isScanned(index)*/) {
      message = "You already registered this session, Delete this record";
    } else {
      DatabaseReference attendanceRef =  FirebaseDatabase.instance.reference().child("attendances").push();
      DatabaseReference sessionRef = FirebaseDatabase.instance.reference().child(scanedList[index].admin).child("classes")
              .child(scanedList[index].classKey).child("sessions").child(scanedList[index].key);
      Map<String, dynamic> map = Map<String, dynamic>();
      map["session"] = scanedList[index].key;
      map["sessionClass"] = scanedList[index].classKey;
      map["sessionAdmin"] = scanedList[index].admin;
      map["user"] = _mUser.uid;
      map["arriveTime"] = scanedList[index].arrive;
      map["leaveTime"] = scanedList[index].leave==null?"NULL":scanedList[index].leave;
      await attendanceRef.set(map);
      sessionRef.child("attended").push().set(attendanceRef.key);
      await FirebaseDatabase.instance.reference().child(_mUser.uid).child("attended").push().set(attendanceRef.key);
      DBProvider.db.deleteScan(scanedList[index].id);
      message = "Synced with the cloud successfully";
      getScans();
    }
    showMessageDialog("result", message);
  }

  Future<bool> isLoggedIn() async {
    _mUser = await _auth.currentUser();
    return _mUser!=null;
  }
  
}
