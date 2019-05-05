import 'package:attendance/backend/session.dart';
import 'package:test/test.dart';

void main() {
  final Map<String, dynamic> sessionData = <String, dynamic>{
    'classkey': '-LXD9_P6tB6r-_RwAg01',
    'myKey': '-LXDEjd1md3CfRY6zkLw',
    'admin': 'GUfzhtGu1vVFJaYIvxi1yIa49Oy1'
  };
  final Session session = Session.fromMap(sessionData);
  group('instantiation', () {
    test('data is identical', () {
      expect(session.adminUID, sessionData['admin']);
      expect(session.classKey, sessionData['classkey']);
      expect(session.key, sessionData['myKey']);
    });
  });
}
