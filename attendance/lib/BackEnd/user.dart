import 'dart:convert';

class User {
  String nativeName;
  String phone;

  String requestBody() {
    Map body = Map();
    if(nativeName != null) body['nativeName'] = nativeName;
    if(phone != null) body['phone'] = phone;
    return json.encode(body);
  }
  
  
  
}