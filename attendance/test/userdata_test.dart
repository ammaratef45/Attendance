import 'dart:convert';

import 'package:attendance/backend/user.dart';
import 'package:test/test.dart';

void main() {
  final User _testUser = User.instance();
  const String _perfectName = 'someName';
  const String _perfectPhone = '1234567890';

  final Map<String, dynamic> data = <String, dynamic>{
    'nativeName': _perfectName,
    'phone': _perfectPhone
  };


  group('object inistantiation', () {
    test('object should not be null', () {
      expect(_testUser, isNotNull);
    });

    test('singleton should not leak ', () {
      final User instance1 = User();
      final User instance2 = User();

      expect(instance1.hashCode, equals(instance2.hashCode));
    });
  });

  group('Rename', () {
    test('should has no default values', () {
      expect(_testUser.nativeName, isNull);
    });

    test('should accept empty string', () {
      _testUser.rename('');

      expect(_testUser.nativeName, isEmpty);
    });

    test('should be matched ', () {
      _testUser.rename(_perfectName);

      expect(_testUser.nativeName, 'someName');
    });

    test('should reject names longer than 20 chars', () {
      try {
        _testUser.rename('This is a very long name');
      } on FormatException catch (ex) {
        expect(ex.message, 'invalid native name format');
      }
    });

    test('should accept names shorter than 21 chars', () {
      _testUser.rename(_perfectName);

      expect(_testUser.nativeName, _perfectName);
    });
  });

  group('changePhone', () {
    test('should has no default values', () {
      expect(_testUser.phone, isNull);
    });
    test('should accept empty string', () {
      _testUser.changePhone('');

      expect(_testUser.phone, isEmpty);
    });

    test('should reject numbers start with leading zero ', () {
      try {
        _testUser.changePhone('0123456789');
      } on FormatException catch (ex) {
        expect(ex.message, 'invalid phone number format');
      }
    });

    test('should accept numbers start with non-leading zero ', () {
      _testUser.changePhone(_perfectPhone);

      expect(_testUser.phone, _perfectPhone);
    });

    test('should reject numbers start with country code ', () {
      try {
        _testUser.changePhone('+012345678');
      } on FormatException catch (ex) {
        expect(ex.message, 'invalid phone number format');
      }
    });

    test('should accept numbers start with no country code ', () {
      _testUser.changePhone(_perfectPhone);

      expect(_testUser.phone, _perfectPhone);
    });

    test('should be matched ', () {
      expect(_testUser.phone, '1234567890');
    });

    test('should reject numbers longer than 10 chars', () {
      try {
        _testUser.changePhone('154234567890123456789');
      } on FormatException catch (ex) {
        expect(ex.message, 'invalid phone number format');
      }
    });

    test('should accept numbers shorter than 11 chars', () {
      _testUser.changePhone(_perfectPhone);

      expect(_testUser.phone, _perfectPhone);
    });
  });

  group('requestBody', () {
    test('should return non empty body', () {
      expect(_testUser.requestBody(), isNotEmpty);
    });

    test('should return valid body', () {
      expect(_testUser.requestBody(), json.encode(data));
    });
  });
}
