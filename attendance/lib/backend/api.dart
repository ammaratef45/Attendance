import 'dart:async';
import 'dart:convert';
import 'package:attendance/backend/session.dart';
import 'package:attendance/backend/user.dart';
import 'package:http/http.dart' as http;

/// class that can execute api calls
class API {
  /// constructor
  API() {
    _client = http.Client();
  }

  Map<String, String> _buildHeaders(String token) =>
    <String, String>{
      'x-token':  token,
      'Content-Type': 'application/json'
    };
  
  http.Request _buildRequest(
    String url,
    String token,
    String body
  ) =>
    http.Request('POST', Uri.parse(url))
    ..headers.addAll(_buildHeaders(token))
    ..body = body
    ..followRedirects = false;

  static const String _baseUrl = 'https://attendance-app-api.herokuapp.com/';
  //static const String _baseUrl = 'http://localhost:3000/';
  http.Client _client;

  /// call verify endpoint that changes user info if provided
  Future<String> setUserInfo(User user, String token) async {
    const String url = '${_baseUrl}verify';
    final http.Request request =
      _buildRequest(url, token, user.requestBody());
    final http.StreamedResponse response = await _client.send(request);
    final int statusCode = response.statusCode;
    final String responseData =
      await response.stream.transform(utf8.decoder).join();
    if(statusCode == 200) {
      return responseData;
    }
    throw Exception('status code is not 200\n$responseData');
  }

  /// call verify endpoint that changes user info if provided
  Future<String> leaveSession(Session session, String token) async {
    const String url = '${_baseUrl}sessionleave';
    final http.Request request =
      _buildRequest(url, token, session.leaveRequestBody());
    final http.StreamedResponse response = await _client.send(request);
    final int statusCode = response.statusCode;
    final String responseData =
      await response.stream.transform(utf8.decoder).join();
    if(statusCode == 200) {
      return responseData;
    }
    throw Exception('status code is not 200\n$responseData');
  }

  /// call verify endpoint that changes user info if provided
  Future<String> addSession(Session session, String token) async {
    const String url = '${_baseUrl}newSession';
    final http.Request request =
      _buildRequest(url, token, session.sessionBody());
    final http.StreamedResponse response = await _client.send(request);
    final int statusCode = response.statusCode;
    final String responseData =
      await response.stream.transform(utf8.decoder).join();
    if(statusCode == 200) {
      return responseData;
    }
    return statusCode.toString() + responseData;
    //throw Exception('status code is not 200\n$responseData');
  }
  
}