import 'dart:io';

import 'package:attendance/backend/api.dart';
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
}
