import 'dart:convert';
class SessionModel {
  String key;
  String classKey;
  String admin;
  SessionModel(value) {
    Map<String, dynamic> map = json.decode(value);
    this.classKey = map["classkey"];
    this.key = map["myKey"];
    this.admin = map["admin"];
  }
}