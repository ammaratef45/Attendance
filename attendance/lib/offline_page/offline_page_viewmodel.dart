import 'dart:async';
import 'dart:convert';
import 'package:attendance/db/database.dart';
import 'package:attendance/backend/scan.dart';
import 'package:attendance/backend/session.dart';
import 'package:attendance/offline_page/offline_page.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
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
      final Session session = Session.fromMap(json.decode(barcode));
      final DateTime now = DateTime.now();
      final Scan scan =Scan.fromMap(
        <String, dynamic> {
          'key': session.key,
          'classKey': session.classKey,
          'admin': session.adminUID,
          'arrive': now.toIso8601String()
        }
      );
      await DBProvider.db.addScan(scan);
      await getScans();
      _scanResult = 'Scanned Successfully';
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          _scanResult = 'You did not grant the camera permission!';
        });
      } else {
        setState(() => _scanResult = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => print('Scan Cancelled'));
    } on Exception catch (e) {
      setState(() => print('Unknown error: $e'));
    }
    showMessageDialog('scan', _scanResult);
  }

  /// scan page for leaving
  Future<void> scanLeave(int index) async {
    try {
      final String barcode = await BarcodeScanner.scan();
      final Session session = Session.fromMap(json.decode(barcode));
      if(session.key!=scanedList[index].key) {
        throw Exception('This is not the same session you attended');
      }
      final DateTime now = DateTime.now();
      scanedList[index].leavedAt(now.toIso8601String());
      await DBProvider.db.updateScan(scanedList[index]);
      await getScans();
      _scanResult = 'Scanned Successfully';
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          _scanResult = 'You did not grant the camera permission!';
        });
      } else {
        setState(() => _scanResult = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => _scanResult = 'Scan cancelled');
    } on Exception catch (e) {
      setState(() => _scanResult = 'Error: $e');
    }
    showMessageDialog('scan', _scanResult);
  }

  /// delete item from scans
  void deleteItem(int index) {
    DBProvider.db.deleteScan(scanedList[index].id);
    getScans();
  }

  /// test if connected
  Future<void> testConnection() async {
    String message = 'You are not connected to internet';
    final ConnectivityResult connectivityResult =
      await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      message = 'You are connected to mobile data';
    } else if (connectivityResult == ConnectivityResult.wifi) {
      message = 'You are connected to wifi';
    }
    showMessageDialog('test', message);
  }

  /// register this to the backend.
  Future<void> registerMe(int index) async {
    String message = '';
    if(!(await isLoggedIn())) {
      message = 'Not loggedin, login first';
    } else {
      await scanedList[index].save();
      await DBProvider.db.deleteScan(scanedList[index].id);
      message = 'Synced with the cloud successfully';
      await getScans();
    }
    showMessageDialog('result', message);
  }

  /// check if user is loggedin
  Future<bool> isLoggedIn() async {
    _mUser = await _auth.currentUser();
    return _mUser!=null;
  }
  
}
