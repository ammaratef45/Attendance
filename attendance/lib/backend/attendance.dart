/// model of the attendance.
class AttendModel {
  // @todo #67 refactor to take a map
  /// constructor
  AttendModel(
    String key,
    String cName,
    String sDate,
    String aDate,
    String lDate
  ) {
    this.key = key;
    this.date = sDate;
    this.arriveDate = aDate;
    this.leaveDate = lDate;
    this.className = cName;
  }

  // @todo #67 refactor to private with getters
  String date;
  String arriveDate;
  String leaveDate;
  String className;
  String key;

  // @todo #67 use DB persistance or anyway to pass without the need of this.
  static AttendModel selected;
}