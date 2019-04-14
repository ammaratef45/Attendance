import 'dart:convert';

import 'package:attendance/backend/api.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// User class
class User {
  /// initialization factory
  factory User() => _user;

  /// private initialization
  User._internal();

  String _nativeName;
  String _phone;
  static final User _user = User._internal();
  final API _api = API();

  /// instance getter
  static User instance() => _user;

  /// user's phone number
  String get phone => _phone;

  /// user's native name
  String get nativeName => _nativeName;

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
    return json.encode(body);
  }

  /// get the id token
  Future<String> token() async =>
    (await FirebaseAuth.instance.currentUser())
        .getIdToken(refresh: true);

  // @todo #26 Implement persist so that it saves the user to local db with
  //  a flag called saved detects if it's sent to api.
  // @todo #26 Implement markSaved so that it changes the falg saved to true.
  /// save data to api and local storage
  void save() {
    _persist();
    try {
      _api.setUserInfo(this);
      _markSaved();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  void _persist() {}

  void _markSaved() {}
}
