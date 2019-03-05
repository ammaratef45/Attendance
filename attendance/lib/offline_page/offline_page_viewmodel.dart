import './offline_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import '../model/session_model.dart';
import '../model/scan_model.dart';
import '../DB/Database.dart';

abstract class OfflinePageViewModel extends State<OfflinePage> {
  String scanResult;
  List<Scan> scanedList=[];

  OfflinePageViewModel() {
    getScans();
  }

  showMessageDialog(String title, String message) {}

  getScans() async {
    scanedList.clear();
    await DBProvider.db.getAllScans().then((res) {
      scanedList.addAll(res);
      debugPrint(scanedList.toString());
    });
  }
  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      SessionModel session = SessionModel(barcode);
      var now = new DateTime.now();
      Scan scan =Scan(key: session.key, classKey: session.classKey, admin: session.admin, arrive: now.toIso8601String());
      DBProvider.db.newScan(scan);
      setState(() {
        getScans();
      });
      this.scanResult = "Scanned Successfully";
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.scanResult = 'You did not grant the camera permission!';
        });
      } else {
        setState(() => this.scanResult = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.scanResult = 'Scan cancelled');
    } catch (e) {
      setState(() => this.scanResult = 'Unknown error: $e');
    }
    showMessageDialog("scan", this.scanResult);
  }
}