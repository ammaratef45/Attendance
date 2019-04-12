import 'dart:convert';

class User {
  String _nativeName;
  String _phone;
  static User _user;

  static User instance() {
    if (_user == null) {
      _user = User();
    }
    return _user;
  }

  String get phone => _phone;

  String get nativeName => _nativeName;

  bool isValidName(String name) {
    if (name.length < 21) {
      return true;
    } else {
      return false;
    }
  }

  void rename(String newName) {
    if (isValidName(newName)) {
      _nativeName = newName;
    } else {
      throw new FormatException("invalid native name format");
    }
  }

  bool isValidNumber(String number) {
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

  void changePhone(String newPhone) {
    if (isValidNumber(newPhone)) {
      _phone = newPhone;
    } else {
      throw new FormatException("invalid phone number format");
    }
  }

  String requestBody() {
    Map body = Map();
    if (_nativeName != null) body['nativeName'] = _nativeName;
    if (_phone != null) body['phone'] = _phone;
    return json.encode(body);
  }

  // @todo #25 save the model to the API and save locally if failed to connect to the API
  void save() {}

// @todo #30 check Singleton potential leak

}
