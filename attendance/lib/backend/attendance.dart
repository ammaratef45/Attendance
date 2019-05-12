import 'dart:convert';

import 'package:attendance/backend/api.dart';
import 'package:attendance/backend/session.dart';
import 'package:attendance/backend/user.dart';

/// model of the attendance.
class Attendance {
  /// constructor
  Attendance(String key) {
    _key = key;
  }
  /// constructor with map
  Attendance.fromMap(Map<String, dynamic> map) {
    _key = map['key'];
    _arriveDate = map['arriveDate'];
    _leaveDate = map['leaveDate'];
    _className = map['className'];
  }

  String _arriveDate;
  /// get the date of arriving
  String get arriveDate => _arriveDate;
  String _leaveDate;
  /// get the date of leaving
  String get leaveDate => _leaveDate;
  String _className;
  /// get the name of the class
  String get className => _className;
  String _key;
  /// get the key
  String get key => _key;
  /// check if the session is scanned for leaving
  bool isLeft() => _leaveDate != null;
  final API _api = API();

  Session _session;

  /// session attended here.
  Session get session => _session;

  /// set the leave date
  void leave(String date) {
    if(isLeft()) {
      throw Exception('session is leaved already');
    }
    _leaveDate = date;
  }

  // @todo #102 implement the saving in API.
  /// save any changes made to the object.
  Future<void> save() async {
    _persist();
    try {
      // await _api.setUserInfo(this, await token());
      _markSaved();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  // @todo #102 implement the persistence of data in DB module.
  void _persist() {
    //DBProvider.db.saveAttendance(this);
  }

  void _markSaved() {
    //DBProvider.db.userIsSynced();
  }

  /// get the body of the API request for leave session
  String leaveRequestBody() {
    final Map<String, String> map = <String, String>{
      'key' : _key,
      'time' : _leaveDate
    };
    return json.encode(map);
  }

  /// get the body of session as a map string
  String requestBody() {
    final Map<String, String> map = <String, String>{
      'arriveTime' : _arriveDate,
      'leaveTime' : _leaveDate,
      'session' : _session.key,
      'sessionAdmin' : _session.adminUID,
      'sessionClass' : _session.classKey
    };
    return json.encode(map);
  }

  /// load info of attendance from backend
  Future<void> loadInfo() async {
    final String res = await _api.getAttendance(await User.token(), _key);
    final Map<String, dynamic> map = json.decode(res)['data'];
    _arriveDate = map['arriveTime'];
    if(map['leaveTime'] != 'NULL') {
      _leaveDate = map['leaveTime'];
    }
    _className = map['sessionClass'];
  }
  
}