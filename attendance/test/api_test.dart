import 'dart:io';

import 'package:attendance/backend/api.dart';
import 'package:attendance/backend/session.dart';
import 'package:attendance/backend/user.dart';
import 'package:test/test.dart';

Future<String> token() async{
  final ProcessResult p = 
    await Process.run(
      '/usr/bin/python',
      //'python',
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

  group('test adding session', () {
    final Future<String> t = token();
    // @todo #48 mock data of the session.
    final Session s = Session();
    test('test added session', () async {
      final String res = await api.addSession(s, await t);
      expect(res, 
        '{"success":"true",'
        '"message":"inserted",'
        '"data":null}'
      );
    });
    test('leave fails due to forgetting token', () async {
      try {
        await api.addSession(s, '');
        throw Exception('should not success');
      // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        expect(
          e.toString(),
          contains(
            '{"success":"false",'
            '"message":"Token is not provided in x-token header",'
            '"data":null}'
          )
        );
      }
    });
    test('leave fails due to wrong token', () async {
      try {
        await api.addSession(s, 'superSecretToken');
        throw Exception('should not success');
      // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        expect(
          e.toString(),
          contains(
            'status code is not 200\n'
            '{"success":"false",'
          )
        );
      }
    });
  });

  group('test getting info', () {
    final Future<String> t = token();
    
    test('test added session', () async {
      final String res = await api.getInfo(await t);
      expect(
        res,
        contains(
          '{"success":"true",'
          '"message":"These are your profile data in the server",' 
        )
      );
    });
    test('leave fails due to forgetting token', () async {
      try {
        await api.getInfo('');
        throw Exception('should not success');
      // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        expect(
          e.toString(),
          contains(
            '{"success":"false",'
            '"message":"Token is not provided in x-token header",'
            '"data":null}'
          )
        );
      }
    });
    test('leave fails due to wrong token', () async {
      try {
        await api.getInfo('superSecretToken');
        throw Exception('should not success');
      // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        expect(
          e.toString(),
          contains(
            'status code is not 200\n'
            '{"success":"false",'
          )
        );
      }
    });
  });
}
