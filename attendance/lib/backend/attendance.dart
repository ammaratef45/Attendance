/// model of the attendance.
class Attendance {
  /// constructor
  Attendance.fromMap(Map<String, dynamic> map) {
    key = map['key'];
    date = map['sessionDate'];
    arriveDate = map['arriveDate'];
    leaveDate = map['leaveDate'];
    className = map['className'];
  }

  // @todo #67 refactor to private with getters
  String date;
  String arriveDate;
  String leaveDate;
  String className;
  String key;

  // @todo #67 use DB persistance or anyway to pass without the need of this.
  static Attendance selected;
}