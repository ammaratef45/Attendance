import 'package:attendance/BackEnd/user.dart';
import 'package:test/test.dart';

void main() {
  User testUser = User.instance();
  String perfectName = 'someName';
  String perfectPhone = '1234567890';

  String jsonBody =
      '{' + '"nativeName":"$perfectName",' + '"phone":"$perfectPhone"' + '}';

  group('object inistantiation', () {
    test('object should not be null', () {
      expect(testUser, isNotNull);
    });

    test('singleton should not leak ', () {
      User instance1 = new User();
      User instance2 = new User();

      expect(instance1.hashCode, equals(instance2.hashCode));
    });
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
      testUser.rename('This is a very long name');
      bool isFit;
      testUser.nativeName.length < 21 ? isFit = true : isFit = false;

      expect(isFit, true);
    });

    test('should accept names shorter than 21 chars', () {
      testUser.rename(perfectName);
      bool isFit;
      testUser.nativeName.length < 21 ? isFit = true : isFit = false;

      expect(isFit, true);
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
      testUser.changePhone('0123456789');
      bool hasLeadingZero;
      testUser.phone.substring(0, 1) != '0'
          ? hasLeadingZero = false
          : hasLeadingZero = true;

      expect(hasLeadingZero, false);
    });

    test('should accept numbers start with non-leading zero ', () {
      testUser.changePhone(perfectPhone);
      bool hasLeadingZero;
      testUser.phone.substring(0, 1) != '0'
          ? hasLeadingZero = false
          : hasLeadingZero = true;

      expect(hasLeadingZero, false);
    });

    test('should reject numbers start with country code ', () {
      testUser.changePhone('+2012345678');
      bool hasCountryCode;
      testUser.phone.substring(0, 1) != '+'
          ? hasCountryCode = false
          : hasCountryCode = true;
      testUser.phone.substring(0, 2) != '00'
          ? hasCountryCode = false
          : hasCountryCode = true;

      expect(hasCountryCode, false);
    });

    test('should accept numbers start with no country code ', () {
      testUser.changePhone(perfectPhone);
      bool hasCountryCode;
      testUser.phone.substring(0, 1) != '+'
          ? hasCountryCode = false
          : hasCountryCode = true;
      testUser.phone.substring(0, 2) != '00'
          ? hasCountryCode = false
          : hasCountryCode = true;

      expect(hasCountryCode, false);
    });

    test('should be matched ', () {
      expect(testUser.phone, '1234567890');
    });

    test('should reject numbers longer than 10 chars', () {
      testUser.changePhone('123456789123456789');
      bool isFit;
      testUser.phone.length < 11 ? isFit = true : isFit = false;

      expect(isFit, true);
    });

    test('should accept numbers shorter than 11 chars', () {
      testUser.changePhone(perfectPhone);
      bool isFit;
      testUser.phone.length < 11 ? isFit = true : isFit = false;

      expect(isFit, true);
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
