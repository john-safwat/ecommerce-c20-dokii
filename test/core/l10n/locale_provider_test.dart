import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/core/l10n/locale_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocaleProvider', () {
    test('initializes with default "en" when no locale is persisted', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final provider = LocaleProvider(prefs);

      expect(provider.locale, equals(const Locale('en')));
      expect(provider.isEnglish, isTrue);
      expect(provider.isArabic, isFalse);
    });

    test('initializes with persisted locale when available', () async {
      SharedPreferences.setMockInitialValues({'app_locale': 'ar'});
      final prefs = await SharedPreferences.getInstance();
      final provider = LocaleProvider(prefs);

      expect(provider.locale, equals(const Locale('ar')));
      expect(provider.isArabic, isTrue);
      expect(provider.isEnglish, isFalse);
    });

    test(
      'setLocale updates locale, persists to prefs, and notifies listeners',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final provider = LocaleProvider(prefs);

        var notified = false;
        provider.addListener(() {
          notified = true;
        });

        await provider.setLocale(const Locale('ar'));

        expect(provider.locale, equals(const Locale('ar')));
        expect(provider.isArabic, isTrue);
        expect(provider.isEnglish, isFalse);
        expect(prefs.getString('app_locale'), equals('ar'));
        expect(notified, isTrue);
      },
    );

    test(
      'setLocale with identical locale does nothing and does not notify',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final provider = LocaleProvider(prefs);

        var notificationCount = 0;
        provider.addListener(() {
          notificationCount++;
        });

        await provider.setLocale(const Locale('en'));

        expect(notificationCount, equals(0));
      },
    );

    test('toggleLocale switches from english to arabic and back', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final provider = LocaleProvider(prefs);

      expect(provider.isEnglish, isTrue);

      await provider.toggleLocale();
      expect(provider.isArabic, isTrue);
      expect(provider.locale, equals(const Locale('ar')));
      expect(prefs.getString('app_locale'), equals('ar'));

      await provider.toggleLocale();
      expect(provider.isEnglish, isTrue);
      expect(provider.locale, equals(const Locale('en')));
      expect(prefs.getString('app_locale'), equals('en'));
    });
  });
}
