import 'package:attendance/BackEnd/user.dart';
import 'package:test/test.dart';

void main() {
  User testUser = User.instance();
  String perfectName = 'someName';
  String perfectPhone = '1234567890';

  String jsonBody =
      '{' + '"nativeName":"$perfectName",' + '"phone":"$perfectPhone"' + '}';

  test('user object init correctly', () {
    expect(testUser, isNotNull);
  });

  group('Rename', () {
    test('should has no default values', () {
      testUser.rename('');

      expect(testUser.nativeName, isEmpty);
    });

    test('should be matched ', () {
      testUser.rename(perfectName);

      expect(testUser.nativeName, 'someName');
    });

    test('should be no longer than 20 chars', () {
      bool isFit;
      testUser.nativeName.length < 21 ? isFit = true : isFit = false;

      expect(isFit, true);
    });
  });

  group('changePhone', () {
    test('should has no default values', () {
      testUser.changePhone('');

      expect(testUser.phone, isEmpty);
    });

    test('should not start with leading zero ', () {
      testUser.changePhone(perfectPhone);
      bool hasLeadingZero;
      testUser.phone.substring(0, 1) != '0'
          ? hasLeadingZero = false
          : hasLeadingZero = true;

      expect(hasLeadingZero, false);
    });

    test('should not start with country code ', () {
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

    test('should be no longer than 10 chars', () {
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
