import 'package:attendance/BackEnd/user.dart';
import 'package:test/test.dart';

void main() {
  User testUser = User.instance();
  String perfectName = 'someName';
  String perfectPhone = '1234567890';

  String jsonBody =
      '{' + '"nativeName":"$perfectName",' + '"phone":"$perfectPhone"' + '}';

  // @todo #31 activate commented tests after implementing validation methods
  
  group('object inistantiation', () {
    test('object should not be null', () {
      expect(testUser, isNotNull);
    });
/*
    test('singleton should not leak ', () {
      User instance1 = new User();
      User instance2 = new User();

      expect(instance1.hashCode, equals(instance2.hashCode));
    });*/
  });

  group('Rename', () {
    test('should has no default values', () {
      expect(testUser.nativeName, isNull);
    });

    test('should accept empty string', () {
      testUser.rename('');

      expect(testUser.nativeName, isEmpty);
    });

    test('should be matched ', () {
      testUser.rename(perfectName);

      expect(testUser.nativeName, 'someName');
    });

    test('should reject names longer than 20 chars', () {
      try {
        testUser.rename('This is a very long name');
      } catch (ex) {
        expect(ex.message, 'invalid native name format');
      }
    });

    test('should accept names shorter than 21 chars', () {
      testUser.rename(perfectName);

      expect(testUser.nativeName, perfectName);
    });
  });

  group('changePhone', () {
    test('should has no default values', () {
      expect(testUser.phone, isNull);
    });
    test('should accept empty string', () {
      testUser.changePhone('');

      expect(testUser.phone, isEmpty);
    });

    test('should reject numbers start with leading zero ', () {
      try {
        testUser.changePhone('0123456789');
      } catch (ex) {
        expect(ex.message, 'invalid phone number format');
      }
    });

    test('should accept numbers start with non-leading zero ', () {
      testUser.changePhone(perfectPhone);

      expect(testUser.phone, perfectPhone);
    });

    test('should reject numbers start with country code ', () {
      try {
        testUser.changePhone('+012345678');
      } catch (ex) {
        expect(ex.message, 'invalid phone number format');
      }
    });

    test('should accept numbers start with no country code ', () {
      testUser.changePhone(perfectPhone);

      expect(testUser.phone, perfectPhone);
    });

    test('should be matched ', () {
      expect(testUser.phone, '1234567890');
    });

    test('should reject numbers longer than 10 chars', () {
      try {
        testUser.changePhone('01234567890123456789');
      } catch (ex) {
        expect(ex.message, 'invalid phone number format');
      }
    });

    test('should accept numbers shorter than 11 chars', () {
      testUser.changePhone(perfectPhone);

      expect(testUser.phone, perfectPhone);
    });
  });

  group('requestBody', () {
    test('should return non empty body', () {
      expect(testUser.requestBody(), isNotEmpty);
    });

    test('should return valid body', () {
      expect(testUser.requestBody(), jsonBody);
    });
  });
}
