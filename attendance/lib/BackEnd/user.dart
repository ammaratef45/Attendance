import 'dart:convert';

class User {
  String _nativeName;
  String _phone;
  static User _user;
  static User instance() {
    if(_user==null) {
      _user = User();
    }
    return _user;
  }

  String get phone => _phone;
  String get nativeName => _nativeName;

  void rename(String newName) {
    _nativeName = newName;
  }

  void changePhone(String newPhone) {
    _phone = newPhone;
  }

  String requestBody() {
    Map body = Map();
    if(_nativeName != null) body['nativeName'] = _nativeName;
    if(_phone != null) body['phone'] = _phone;
    return json.encode(body);
  }

  // @todo #25 save the model to the API and save locally if failed to connect to the API
  void save() {}
  
}