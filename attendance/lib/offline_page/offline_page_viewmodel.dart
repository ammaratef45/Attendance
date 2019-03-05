import './offline_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import '../model/session_model.dart';
import '../model/scan_model.dart';
import '../DB/Database.dart';
import '../scan_exceptions.dart';

abstract class OfflinePageViewModel extends State<OfflinePage> {
  String scanResult;
  List<Scan> scanedList=[];

  OfflinePageViewModel() {
    getScans();
  }

  showMessageDialog(String title, String message) {}

  getScans() async {
    scanedList.clear();
    scanedList.addAll(await DBProvider.db.getAllScans());
    setState(() {
    });
  }
  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      SessionModel session = SessionModel(barcode);
      var now = new DateTime.now();
      Scan scan =Scan(key: session.key, classKey: session.classKey, admin: session.admin, arrive: now.toIso8601String());
      DBProvider.db.newScan(scan);
      getScans();
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

  Future scanLeave(int index) async {
    try {
      String barcode = await BarcodeScanner.scan();
      SessionModel session = SessionModel(barcode);
      if(session.key!=scanedList[index].key) throw InvalidSessionException("This is not the same session you attended");
      var now = new DateTime.now();
      scanedList[index].leave = now.toIso8601String();
      DBProvider.db.addLeave(scanedList[index]);
      getScans();
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
    } on InvalidSessionException {
      setState(() => this.scanResult = "This is not the same session you attended");
    } catch (e) {
      setState(() => this.scanResult = 'Unknown error: $e');
    }
    showMessageDialog("scan", this.scanResult);
  }

  deleteItem(int index) {
    DBProvider.db.deleteScan(scanedList[index].id);
    getScans();
  }
}