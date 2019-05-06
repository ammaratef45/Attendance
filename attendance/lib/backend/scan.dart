import 'package:attendance/backend/api.dart';
import 'package:attendance/backend/session.dart';
import 'package:attendance/backend/user.dart';
import 'package:attendance/db/database.dart';

/// model that represents the scan.
class Scan {

  /// a map constructor
  Scan.fromMap(Map<String, dynamic> json) {
    _id = json['id'];
    _key = json['key'];
    _classKey = json['classKey'];
    _admin = json['admin'];
    _arrive = json['arrive'];
    _leave = json['leave'];
  }
  int _id;
  /// the id of the scan in the database.
  int get id => _id;
  String _key;
  /// scanned session key.
  String get key => _key;
  String _classKey;
  /// key of class of scanned session
  String get classKey => _classKey;
  String _admin;
  /// the uid of session's admin
  String get admin => _admin;
  String _arrive;
  /// the time of arrival scanned
  String get arrive => _arrive;
  String _leave;
  // @todo #75 instead of null make a property indicates if scanned for leave.
  /// the time of leaving scan
  String get leave => _leave;
  final API _api = API();

  /// convert to a map.
  Map<String, dynamic> toMap()  =>
    <String, dynamic> {
      'id': _id,
      'key': _key,
      'classKey': _classKey,
      'admin': _admin,
      'arrive': _arrive,
      'leave': _leave,
    };

  /// get the time part of arriving
  String arriveTimePart() {
    final List<String> datetime = _arrive.split('T');
    final List<String> dateParts = datetime[0].split('-');
    final List<String> timeParts = datetime[1].split(':');
    return '${dateParts[2]}/${dateParts[1]} at ${timeParts[0]}:${timeParts[1]}';
  }

  /// get the time part of leaving
  String leaveTimePart() {
    if(_leave==null) {
      return '';
    }
    final List<String> datetime = _leave.split('T');
    final List<String> dateParts =datetime[0].split('-');
    final List<String> timeParts =datetime[1].split(':');
    return '${dateParts[2]}/${dateParts[1]} at ${timeParts[0]}:${timeParts[1]}';
  }

  /// change the leaved time
  void leavedAt(String iso8601string) {
    if(_leave==null) {
      _leave = iso8601string;
    } else {
      throw Exception('session already left');
    }
  }

  /// save data to api
  Future<void> save() async {
    _persist();
    try {
      await _api.addSession(
        Session.fromMap(<String, dynamic>{
          'classkey' : classKey,
          'myKey' : key,
          'admin' : admin
        }),
        await User.token()
      );
      _markSaved();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  void _persist() {
    DBProvider.db.newScan(this);
  }

  // @todo #45 add synced flag to the scen table.
  void _markSaved() {
    //DBProvider.db.scanIsSynced();
  }
  
}

