/// The session model
class Session {
  /// Empty constructor.
  Session();
  /// Constructor from 
  Session.fromMap(Map<String, dynamic>  map) {
    _classKey = map['classkey'];
    _key = map['myKey'];
    _adminUID = map['admin'];
  }
  
  String _key;
  String _classKey;
  String _adminUID;
  String _date;

  /// Key of the session in Firebase
  String get key => _key;
  /// Key of session's class in Firebase
  String get classKey => _classKey;
  /// UID of the session's admin
  String get adminUID => _adminUID;
  /// session's date
  String get date => _date;
}