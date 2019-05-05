import 'dart:convert';

/// The session model
class Session {
  /// Empty constructor.
  Session();

  /// Constructor from
  Session.fromMap(Map<String, dynamic> map) {
    _classKey = map['classkey'];
    _key = map['myKey'];
    _adminUID = map['admin'];
  }

  String _key;
  String _classKey;
  String _adminUID;

  /// Key of the session in Firebase
  String get key => _key;

  /// Key of session's class in Firebase
  String get classKey => _classKey;

  /// UID of the session's admin
  String get adminUID => _adminUID;

  // @todo #51 implement this methos
  /// get the body of the API request for leave session
  String leaveRequestBody() => 'what?';

  // @todo #48 add unit tests for this method.
  //  refactor it to take data from member variables.
  //  to be able to do this add the local variables first.
  /// get the body of session as a map string
  String sessionBody() {
    final Map<String, String> map = <String, String>{
      'arriveTime': 'm',
      'leaveTime': 'm',
      'session': 'm',
      'sessionAdmin': 'm',
      'sessionClass': 'm',
      'user': 'm'
    };
    return json.encode(map);
  }
}
