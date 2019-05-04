/// model of the attendance.
class Attendance {
  /// constructor
  Attendance.fromMap(Map<String, dynamic> map) {
    _key = map['key'];
    _date = map['sessionDate'];
    _arriveDate = map['arriveDate'];
    _leaveDate = map['leaveDate'];
    _className = map['className'];
  }

  String _date;
  /// get the date of the session
  String get date => _date;
  String _arriveDate;
  /// get the date of arriving
  String get arriveDate => _arriveDate;
  String _leaveDate;
  /// get the date of leaving
  String get leaveDate => _leaveDate;
  String _className;
  /// get the name of the class
  String get className => _className;
  String _key;
  /// get the key
  String get key => _key;
  /// check if the session is scanned for leaving
  bool isLeaved() => _leaveDate==null;

  /// set the leave date
  void leave(String date) {
    if(isLeaved()) {
      throw Exception('session is leaved already');
    }
    _leaveDate = date;
  }

  // @todo #67 use DB persistance or anyway to pass without the need of this.
  static Attendance selected;
}