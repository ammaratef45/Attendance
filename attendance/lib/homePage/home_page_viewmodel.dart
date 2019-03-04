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

abstract class HomePageViewModel extends State<HomePage> {
  String scanResult = "";
  List<AttendModel> litems = [];
  List<AttendModel> uitems = [];
  final auth = FirebaseAuth.instance;
  FirebaseUser mUser;
  String mail = "";
  String imageUrl = "";
  String name = "";
  HomePageViewModel() {
    auth.currentUser().then((user) {
      mUser = user;
      setState(() {
        if(mUser.email!=null) mail = mUser.email;
        if(mUser.displayName!=null) name = mUser.displayName;
        if(mUser.photoUrl!=null) imageUrl = mUser.photoUrl;
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

  Future scan() async {
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
      var now = new DateTime.now();
      await attendanceRef.set({
        "session": session.key,
        "sessionClass": session.classKey,
        "sessionAdmin": session.admin,
        "user": uid,
        "arriveTime": now.toIso8601String(),
        "leaveTime": "NULL"
      });
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
      setState(() => this.scanResult = 'Scan cancelled');
    } on AlreadyScannedSessionException catch(e){
      setState(() {
        this.scanResult = e.cause;
      });
    } catch (e) {
      setState(() => this.scanResult = 'Unknown error: $e');
    }
  }

  Future<bool> isScanned(DatabaseReference session, FirebaseUser user) async {
    DataSnapshot attendencies = await session.child("attended").once();
    Map<dynamic, dynamic> value = attendencies.value;
    if(value==null || value.isEmpty) return false;
    for(var key in value.keys) {
      DataSnapshot ref = await FirebaseDatabase.instance.reference().child("attendances").child(value[key]).once();
      if(ref.value["user"] == user.uid) {
        debugPrint(user.uid);
        debugPrint(ref.value["user"]);
        return true;
      }
    }
    return false;
  }

  Future fillData() async {
    litems.clear();
    uitems.clear();
    FirebaseDatabase.instance.reference().child(mUser.uid).child("attended").onChildAdded.listen((event) async {
      var key = event.snapshot.value;
      DatabaseReference itemRef = FirebaseDatabase.instance.reference().child("attendances").child(key);
      DataSnapshot item = await itemRef.once();
      DatabaseReference classRef = FirebaseDatabase.instance.reference().child(item.value["sessionAdmin"]).
        child("classes").child(item.value["sessionClass"]);
      DataSnapshot classSnap = await classRef.once();
      var name = classSnap.value["name"];
      DataSnapshot sessionSnap = await classRef.child("sessions").child(item.value["session"]).once();
      var date = json.decode(sessionSnap.value["qrval"])["date"];
      var attendTime = item.value["arriveTime"];
      var leaveTime = item.value["leaveTime"];
      setState(() {
        AttendModel m = AttendModel(key, name, date, attendTime, leaveTime);
        if(m.leaveDate=="NULL") uitems.add(m);
        else litems.add(m);
      });
    });
  }
  
}