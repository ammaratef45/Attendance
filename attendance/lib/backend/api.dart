import 'dart:async';
import 'dart:convert';
import 'package:attendance/backend/user.dart';
import 'package:http/http.dart' as http;

/// class that can execute api calls
class API {
  /// constructor
  API() {
    _client = http.Client();
  }

  static const String _baseUrl = 'https://attendance-app-api.herokuapp.com/';
  http.Client _client;

  /// call verify endpoint that changes user info if provided
  Future<String> setUserInfo(User user) async {
    final Map<String, String> headers =  <String, String>{
      'x-token':  await user.token(),
      'Content-Type': 'application/json'
    };
    const String url = '${_baseUrl}verify';
    final http.Request request = http.Request('POST', Uri.parse(url))
    ..headers.addAll(headers)
    ..body = user.requestBody()
    ..followRedirects = false;
    final http.StreamedResponse response = await _client.send(request);
    final int statusCode = response.statusCode;
    final String responseData =
      await response.stream.transform(utf8.decoder).join();
    if(statusCode == 200) {
      return responseData;
    }
    throw Exception('status code is not 200\n$responseData');
  }
  
}