import 'package:attendance/backend/attendance.dart';
import 'package:test/test.dart';

void main() {
  final Map<String, dynamic> _attendanceData = <String, dynamic>{
    'key' : '-LXDFDibiC8EyKRg96Zv',
    'sessionDate' : '2019-01-27T09:40:45.883409',
    'arriveDate' : '2019-01-27T09:40:45.883409',
    'leaveDate' : '2019-01-27T09:40:45.883409',
    'className' : 'BIOCHEMICAL'
  };
  final Attendance _attendance = Attendance.fromMap(_attendanceData);
  final Map<String, dynamic> _attendanceNotLeftData = <String, dynamic>{}
  ..addAll(_attendanceData)
  ..remove('leaveDate');
  final Attendance _notLeftAttendance =
    Attendance.fromMap(_attendanceNotLeftData);
  group('instantiation', () {
    test('data is identical', () {
      expect(_attendance.className, _attendanceData['className']);
      expect(_attendance.session.date, _attendanceData['sessionDate']);
      expect(_attendance.arriveDate, _attendanceData['arriveDate']);
      expect(_attendance.leaveDate, _attendanceData['leaveDate']);
      expect(_attendance.key, _attendanceData['key']);
    });
    test('key only initialization', () {
      final Attendance att = Attendance(_attendanceData['key']);
      expect(att.className, null);
      expect(att.session.date, null);
      expect(att.arriveDate, null);
      expect(att.leaveDate, null);
      expect(att.key, _attendanceData['key']);
    });
  }, skip: true);

  group('leaving', () {
    test('is left', () {
      expect(_notLeftAttendance.isLeft(), false);
      expect(_attendance.isLeft(), true);
    });
    test('leaving working', () {
      _notLeftAttendance.leave('2019-01-27T09:40:45.883409');
      expect(_notLeftAttendance.leaveDate, '2019-01-27T09:40:45.883409');
      expect(_notLeftAttendance.isLeft(), true);
    });
    test('leaved will refuse to be leaved again', () {
      try {
        _attendance.leave('2019-01-27T09:40:45.883409');
        expect(1, 0);
      // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        expect(e.toString(), 'Exception: session is leaved already');
      }
    });
  });
}