/// model that represents the scan.
class Scan {
  /// constructor
  Scan({
    this.id,
    this.key,
    this.classKey,
    this.admin,
    this.arrive,
    this.leave
  });

  /// a map constructor
  factory Scan.fromMap(Map<String, dynamic> json) => Scan(
        id: json['id'],
        key: json['key'],
        classKey: json['classKey'],
        admin: json['admin'],
        arrive: json['arrive'],
        leave: json['leave']
      );
  // @todo #67 refactor to private with getters when needed.
  int id;
  String key;
  String classKey;
  String admin;
  String arrive;
  String leave;

  /// convert to a map.
  Map<String, dynamic> toMap()  =>
    <String, dynamic> {
      'id': id,
      'key': key,
      'classKey': classKey,
      'admin': admin,
      'arrive': arrive,
      'leave': leave,
    };

  /// get the time part of arriving
  String arriveTimePart() {
    final List<String> datetime = arrive.split('T');
    final List<String> dateParts =datetime[0].split('-');
    final List<String> timeParts =datetime[1].split(':');
    return '${dateParts[2]}/${dateParts[1]} at ${timeParts[0]}:${timeParts[1]}';
  }

  /// get the time part of leaving
  String leaveTimePart() {
    if(leave==null) {
      return '';
    }
    final List<String> datetime = leave.split('T');
    final List<String> dateParts =datetime[0].split('-');
    final List<String> timeParts =datetime[1].split(':');
    return '${dateParts[2]}/${dateParts[1]} at ${timeParts[0]}:${timeParts[1]}';
  }
}