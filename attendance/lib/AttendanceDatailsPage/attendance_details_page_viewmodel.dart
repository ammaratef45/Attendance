import './attendance_details_page.dart';
import 'package:flutter/material.dart';
import '../model/attend_model.dart';
import '../model/session_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../scan_exceptions.dart';
import 'package:firebase_admob/firebase_admob.dart';

abstract class AttendanceDetailsPageViewModel extends State<AttendanceDetailsPage> {
   bool isLeaved = true;
   AttendModel model;
   String className;
   String session;
   String arriveDate;
   String leaveDate;
   String scanResult;
   BannerAd myBanner = BannerAd(
    adUnitId: "ca-app-pub-5308838739950508/6605562688",
    size: AdSize.smartBanner,
    listener: (MobileAdEvent event) {
      print("BannerAd event is $event");
    },
  );
  AttendanceDetailsPageViewModel() {
    FirebaseAdMob.instance.initialize(appId: "ca-app-pub-5308838739950508~2647148134");
    myBanner
      ..load()
      ..show(
        anchorOffset: 60.0,
        anchorType: AnchorType.bottom,
      );
    model = AttendModel.selected;
    className = model.className;
    session = model.date;
    arriveDate = "Arrived: " + model.arriveDate;
    leaveDate = "Leaved: " + model.leaveDate;
    if(model.leaveDate == "NULL") {
      isLeaved = false;
    }
  }

   void scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      SessionModel session = SessionModel(barcode);
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      String uid = user.uid;
      DatabaseReference attendanceRef = FirebaseDatabase.instance.reference().child("attendances").child(model.key);
      DataSnapshot oldModel = await attendanceRef.once();
      if(oldModel.value["session"] != session.key) {
        throw InvalidSessionException("this is not the same session code");
      }
      DateTime now = new DateTime.now();
      Map<String, dynamic> map = Map<String, dynamic>();
      map["session"] = session.key;
      map["sessionClass"] = session.classKey;
      map["sessionAdmin"] = session.admin;
      map["user"] = uid;
      map["arriveTime"] = model.arriveDate;
      map["leaveTime"] = now.toIso8601String();
      await attendanceRef.set(map);
      await FirebaseDatabase.instance.reference().child(uid).child("attended").push().set(attendanceRef.key);
      setState(() {
        isLeaved = true;
        scanResult = "";
        model.leaveDate = now.toIso8601String();
        leaveDate = "Leaved: " + model.leaveDate;
      });
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
    } on InvalidSessionException catch(e){
      setState(() {
        this.scanResult = e.cause;
      });
    } on Exception catch (e) {
      setState(() => this.scanResult = 'Unknown error: $e');
    }
  }

}