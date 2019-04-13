import 'dart:convert';

import 'package:attendance/BackEnd/API.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  String _nativeName;
  String _phone;
  static User _user;
  final API api = API();

  static User instance() {
    if (_user == null) {
      _user = User();
    }
    return _user;
  }

  String get phone => _phone;

  String get nativeName => _nativeName;

  // @todo #26 trim the inputs before validation for rename and changePhone
  void rename(String newName) {
    if (_isValidName(newName)) {
      _nativeName = newName;
    } else {
      throw new FormatException("invalid native name format");
    }
  }

  void changePhone(String newPhone) {
    if (_isValidNumber(newPhone)) {
      _phone = newPhone;
    } else {
      throw new FormatException("invalid phone number format");
    }
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
      String firstDigit = number.substring(0, 1);

      if (number.length < 11 && firstDigit != '0' && firstDigit != '+') {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  String requestBody() {
    Map<String, String> body = Map<String, String>();
    if (_nativeName != null) {
      body['nativeName'] = _nativeName;
    }
    if (_phone != null) {
      body['phone'] = _phone;
    }
    return json.encode(body);
  }

  Future<String> token() async {
    return (await FirebaseAuth.instance.currentUser()).getIdToken(refresh: true);
  }

  // @todo #26 Implement persist so that it saves the user to local db with
  //  a flag called saved detects if it's sent to api.
  // @todo #26 Implement markSaved so that it changes the falg saved to true.
  void save() {
    _persist();
    try {
      api.setUserInfo(this);
      _markSaved();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  void _persist() {

  }

  void _markSaved() {

  }

// @todo #30 check Singleton potential leak

}
