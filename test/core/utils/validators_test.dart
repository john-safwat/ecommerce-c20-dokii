import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/core/l10n/app_localizations_en.dart';
import 'package:route_ecommerce/core/utils/validators.dart';

void main() {
  late Validator validator;
  late AppLocalizationsEn locale;

  setUp(() {
    validator = Validator();
    locale = AppLocalizationsEn();
  });

  group('Validator.nameValidation', () {
    test('returns required error when null or empty', () {
      expect(validator.nameValidation(null, locale), locale.nameRequired);
      expect(validator.nameValidation('   ', locale), locale.nameRequired);
    });

    test('returns invalid format error when digits or symbols are present', () {
      expect(
        validator.nameValidation('John123', locale),
        locale.invalidNameFormat,
      );
    });

    test('returns null for valid Latin and Arabic names', () {
      expect(validator.nameValidation('John Doe', locale), isNull);
      expect(validator.nameValidation('أحمد محمد', locale), isNull);
    });
  });

  group('Validator.phoneValidation', () {
    test('returns required error when null or empty', () {
      expect(validator.phoneValidation(null, locale), locale.phoneRequired);
      expect(validator.phoneValidation('  ', locale), locale.phoneRequired);
    });

    test('returns invalid format error for non-Egyptian numbers', () {
      expect(
        validator.phoneValidation('01912345678', locale),
        locale.invalidPhoneFormat,
      );
      expect(
        validator.phoneValidation('01012345', locale),
        locale.invalidPhoneFormat,
      );
    });

    test('returns null for valid Egyptian mobile numbers', () {
      expect(validator.phoneValidation('01012345678', locale), isNull);
      expect(validator.phoneValidation('01112345678', locale), isNull);
      expect(validator.phoneValidation('01212345678', locale), isNull);
      expect(validator.phoneValidation('01512345678', locale), isNull);
    });
  });

  group('Validator.emailValidation', () {
    test('returns required error when empty', () {
      expect(validator.emailValidation('', locale), locale.emailRequired);
    });

    test('returns invalid format error for malformed email', () {
      expect(
        validator.emailValidation('not-an-email', locale),
        locale.invalidEmailFormat,
      );
    });

    test('returns null for valid email', () {
      expect(validator.emailValidation('user@example.com', locale), isNull);
    });
  });

  group('Validator.passwordValidation', () {
    test('returns required error when empty', () {
      expect(validator.passwordValidation('', locale), locale.passwordRequired);
    });

    test('returns invalid error when weak', () {
      expect(
        validator.passwordValidation('weakpass', locale),
        locale.passwordInvalid,
      );
    });

    test('returns null for strong password', () {
      expect(validator.passwordValidation('Strong@123', locale), isNull);
    });
  });
}
