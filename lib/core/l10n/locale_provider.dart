import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class LocaleProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  static const String _localeKey = 'app_locale';
  late Locale _locale;

  LocaleProvider(this._prefs) {
    final savedLocale = _prefs.getString(_localeKey);
    _locale = Locale(savedLocale ?? 'en');
  }

  Locale get locale => _locale;

  bool get isArabic => _locale.languageCode == 'ar';

  bool get isEnglish => _locale.languageCode == 'en';

  Future<void> setLocale(Locale newLocale) async {
    if (_locale == newLocale) return;
    _locale = newLocale;
    await _prefs.setString(_localeKey, newLocale.languageCode);
    notifyListeners();
  }

  Future<void> toggleLocale() async {
    final nextLocale = isArabic ? const Locale('en') : const Locale('ar');
    await setLocale(nextLocale);
  }
}
