import 'dart:convert';

import 'package:attendance/backend/api.dart';
import 'package:attendance/backend/attendance.dart';
import 'package:attendance/db/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
// @todo #50 add gettinng info functionality.
/// User class
class User {
  /// initialization factory
  factory User() => _user;

  /// private initialization
  User._internal();

  String _nativeName;
  String _name;
  String _email;
  String _picURL;
  String _phone;
  static final User _user = User._internal();
  final API _api = API();
  final List<Attendance> _attended = <Attendance>[];

  /// instance getter
  static User instance() => _user;

  /// user's phone number
  String get phone => _phone;

  /// user's native name
  String get nativeName => _nativeName;

  /// user's name
  String get name => _name;

  /// user's email
  String get mail => _email;

  /// user's picUrl
  String get picUrl => _picURL;

  /// user's attended sessions.
  Future<List<Attendance>> attended({bool referesh=false}) async {
    if(referesh) {
      await _loadInfo();
    }
    return Future<List<Attendance>>.value(_attended);
  }

  Future<void> _loadInfo() async {
    final String wholeInfo = await _api.getInfo(await token());
    final Map<String, dynamic> attendances =
      json.decode(wholeInfo)['data']['attended'];
      _attended.clear();
    for(String key in attendances.keys) {
      _attended.add(Attendance(attendances[key]));
    }
  }

  /// rename the user (change native name)
  void rename(String newName) {
    final String trimmed = newName.trim();
    if (_isValidName(trimmed)) {
      _nativeName = trimmed;
    } else {
      throw const FormatException('invalid native name format');
    }
  }

  /// change user's phone number
  void changePhone(String newPhone) {
    final String trimmed = newPhone.trim();
    if (_isValidNumber(trimmed)) {
      _phone = trimmed;
    } else {
      throw const FormatException('invalid phone number format');
    }
  }

  /// change user's name
  void nameMe(String newName) {
    final String trimmed = newName.trim();
    _name = trimmed;
  }

  /// change user's email
  void assignEmail(String mail) {
    final String trimmed = mail.trim();
    _email = trimmed;
  }

  /// change user's email
  void changePicture(String picUrl) {
    final String trimmed = picUrl.trim();
    _picURL = trimmed;
  }

  bool _isValidName(String name) {
    if (name.length < 21) {
      return true;
    } else {
      return false;
    }
  }

  bool _isValidNumber(String number) {
    if (number.isNotEmpty) {
      final String firstDigit = number.substring(0, 1);

      if (number.length < 11 && firstDigit != '0' && firstDigit != '+') {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  /// get payload of request when saving the info
  String requestBody() {
    final Map<String, String> body = <String, String>{};
    if (_nativeName != null) {
      body['nativeName'] = _nativeName;
    }
    if (_phone != null) {
      body['phone'] = _phone;
    }
    if (_name != null) {
      body['name'] = _name;
    }
    if (_email != null) {
      body['mail'] = _email;
    }
    if (_picURL != null) {
      body['photo'] = _picURL;
    }
    return json.encode(body);
  }

  /// return body as a map
  Map<String, dynamic> toMap() =>
      <String, dynamic>{'nativeName': _nativeName, 'phone': _phone};

  /// get auth token
  static Future<String> token() async =>
      (await FirebaseAuth.instance.currentUser()).getIdToken(refresh: true);

  
  /// save data to api and local storage
  Future<void> save() async {
    for(Attendance attendance in _attended) {
      await attendance.save();
    }
    _persist();
    try {
      await _api.setUserInfo(this, await token());
      _markSaved();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  void _persist() {
    DBProvider.db.saveUser(this);
  }

  void _markSaved() {
    DBProvider.db.userIsSynced();
  }
}
