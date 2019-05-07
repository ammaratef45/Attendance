import 'package:attendance/backend/scan.dart';
import 'package:test/test.dart';
// @todo #45 add more tests to scan functionality
void main() {
  group('initialization', () {
    const int _id = 12;
    const String _key = 'key';
    const String _classKey = 'classKey';
    const String _admin = 'admin';
    const String _arrive = 'arrive';
    const String _leave = 'leave';
    final Scan scan = Scan.fromMap(<String, dynamic>{
      'id' : _id,
      'key' : _key,
      'classKey' : _classKey,
      'admin' : _admin,
      'arrive' : _arrive,
      'leave' : _leave
    });
    test('correct params', () {
      expect(scan.id, _id);
      expect(scan.key, _key);
      expect(scan.classKey, _classKey);
      expect(scan.admin, _admin);
      expect(scan.arrive, _arrive);
      expect(scan.leave, _leave);
    });
  });
  
}