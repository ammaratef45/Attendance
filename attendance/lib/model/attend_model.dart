class AttendModel {
  String date;
  String arriveDate;
  String leaveDate;
  String className;
  String key;

  static AttendModel selected;
  AttendModel(key, cName, sDate, aDate, lDate) {
    this.key = key;
    this.date = sDate;
    this.arriveDate = aDate;
    this.leaveDate = lDate;
    this.className = cName;
  }
}