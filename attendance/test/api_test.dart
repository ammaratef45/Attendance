import 'dart:io';

import 'package:attendance/backend/api.dart';
import 'package:attendance/backend/session.dart';
import 'package:attendance/backend/user.dart';
import 'package:test/test.dart';

Future<String> token() async{
  final ProcessResult p = 
    await Process.run(
      '/usr/bin/python',
      <String>[
        'firebase_token_generator.py',
        'GUfzhtGu1vVFJaYIvxi1yIa49Oy1'
      ]
    );
    final String t = p.stdout.toString().trim();
    print(p.stderr);
    return t;
}

void main() {
  final API api = API();
  group('setUserInfo', () {
    final Future<String> t = token();
    final User user = User()
    ..rename('Ammar Atef')
    ..changePhone('1153300223');
    test('set valid info', () async {
      final String res = await api.setUserInfo(user, await t);
      expect(
        res,
        '{"success":"true","message":"You are a verified user","data":null}'
      );
    });
  });

  group('session calls', () {
    final Future<String> t = token();
    // @todo #51 mock a session for this test and make it work.
    Session s;
    test('leave success', () async {
      final String res = await api.leaveSession(s, await t);
      expect(
        res,
        '{"success":"true","message":"updated","data":null}'
      );
    });
    test('leave fails due to forgetting token', () async {
      try {
        await api.leaveSession(s, '');
        throw Exception('should not success');
      // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        expect(
          e,
          '{"success":"false",'
          '"message":"Token is not provided in x-token header",'
          '"data":null}'
        );
      }
    });
    test('leave fails due to wrong token', () async {
      try {
        await api.leaveSession(s, 'superSecretToken');
        throw Exception('should not success');
      // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        expect(
          e,
          contains(
            'status code is not 200\n'
            '{"success":"false",'
          )
        );
      }
    });
  }, skip: true);
}
