import './home_page.dart';
import 'package:flutter/material.dart';
import '../model/attend_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../model/session_model.dart';
import 'package:barcode_scan/barcode_scan.dart';
import '../scan_exceptions.dart';
import 'dart:async';


abstract class HomePageViewModel extends State<HomePage> {
  String scanResult = "Scan Error: Make sure you're scanning the right code";
  List<AttendModel> litems = List<AttendModel>();
  List<AttendModel> uitems = List<AttendModel>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser mUser;
  String mail = "";
  String imageUrl = "";
  String name = "";
  HomePageViewModel() {
    auth.currentUser().then((FirebaseUser user) {
      mUser = user;
      setState(() {
        if(mUser.email!=null) {
          mail = mUser.email;
        }
        if(mUser.displayName!=null) {
          name = mUser.displayName;
        }
        if(mUser.photoUrl!=null) {
          imageUrl = mUser.photoUrl;
        }
        fillData();
      });
    });
  }
  void signOut() {
    auth.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void openDetails(AttendModel model) async {
    AttendModel.selected = model;
    await Navigator.of(context).pushNamed('/details');
    fillData();
  }

  Future<void> scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      String uid = mUser.uid;
      SessionModel session = SessionModel(barcode);
      DatabaseReference sessionRef = FirebaseDatabase.instance.reference().child(session.admin).child("classes")
              .child(session.classKey).child("sessions").child(session.key);
      if(await isScanned(sessionRef, mUser)) {
        throw new AlreadyScannedSessionException("already scanned atendance to this session");
      }
      DatabaseReference attendanceRef =  FirebaseDatabase.instance.reference().child("attendances").push();
      DateTime now = new DateTime.now();
      Map<String, dynamic> map = Map<String, dynamic>();
      map["session"] = session.key;
      map["sessionClass"] = session.classKey;
      map["sessionAdmin"] = session.admin;
      map["user"] = uid;
      map["arriveTime"] = now.toIso8601String();
      map["leaveTime"] = "NULL";
      await attendanceRef.set(map);
      sessionRef.child("attended").push().set(attendanceRef.key);
      await FirebaseDatabase.instance.reference().child(uid).child("attended").push().set(attendanceRef.key);
      setState(() {
        this.scanResult = "scanned successfully";
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
      setState(() => print('Scan Cancelled'));
    } on AlreadyScannedSessionException catch(e){
      setState(() {
        this.scanResult = e.cause;
      });
    } on Exception catch (e) {
      setState(() => print('Unknown error: $e'));
    }
  }

  Future<bool> isScanned(DatabaseReference session, FirebaseUser user) async {
    DataSnapshot attendencies = await session.child("attended").once();
    Map<dynamic, dynamic> value = attendencies.value;
    if(value==null || value.isEmpty) {
      return false;
    }
    for(String key in value.keys) {
      DataSnapshot ref = await FirebaseDatabase.instance.reference().child("attendances").child(value[key]).once();
      if(ref.value["user"] == user.uid) {
        debugPrint(user.uid);
        debugPrint(ref.value["user"]);
        return true;
      }
    }
    return false;
  }

  Future<void> fillData() async {
    litems.clear();
    uitems.clear();
    FirebaseDatabase.instance.reference().child(mUser.uid).child("attended").onChildAdded.listen((Event event) async {
      String key = event.snapshot.value;
      DatabaseReference itemRef = FirebaseDatabase.instance.reference().child("attendances").child(key);
      DataSnapshot item = await itemRef.once();
      DatabaseReference classRef = FirebaseDatabase.instance.reference().child(item.value["sessionAdmin"]).
        child("classes").child(item.value["sessionClass"]);
      DataSnapshot classSnap = await classRef.once();
      String name = classSnap.value["name"];
      DataSnapshot sessionSnap = await classRef.child("sessions").child(item.value["session"]).once();
      String date = json.decode(sessionSnap.value["qrval"])["date"];
      String attendTime = item.value["arriveTime"];
      String leaveTime = item.value["leaveTime"];
      setState(() {
        AttendModel m = AttendModel(key, name, date, attendTime, leaveTime);
        if(m.leaveDate=="NULL") {
          uitems.add(m);
        }
        else {
          litems.add(m);
        }
      });
    });
  }
  
}