import 'package:attendance/backend/attendance.dart';
import 'package:test/test.dart';

void main() {
  final Map<String, dynamic> attendanceData = <String, dynamic>{
    'key' : '-LXDFDibiC8EyKRg96Zv',
    'sessionDate' : '2019-01-27T09:40:45.883409',
    'arriveDate' : '2019-01-27T09:40:45.883409',
    'leaveDate' : '2019-01-27T09:40:45.883409',
    'className' : 'BIOCHEMICAL'
  };
  final Attendance attendance = Attendance.fromMap(attendanceData);
  group('instantiation', () {
    test('data is identical', () {
      expect(attendance.className, attendanceData['className']);
      expect(attendance.date, attendanceData['sessionDate']);
      expect(attendance.arriveDate, attendanceData['arriveDate']);
      expect(attendance.leaveDate, attendanceData['leaveDate']);
      expect(attendance.key, attendanceData['key']);
    });
  });
}