import 'package:flutter/material.dart';

class SettingController extends ChangeNotifier {
  SettingController._internal();

  static final _settingController = SettingController._internal();
  static SettingController get instance => _settingController;

  // Language setting
  Locale _locale = const Locale('vi');
  Locale get locale => _locale;
  String get languageCode => _locale.languageCode;
  void changeLocale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }

  void changeLocaleByLanguageCode(String languageCode) {
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Map<String, String> supportLanguage = {
    'vi': '🇻🇳 Tiếng Việt',
    'en': '🇺🇸 English'
  };

  void switchLanguage() {
    if (_locale == const Locale('vi')) {
      // changeLocale(const Locale('en'));
      _locale = const Locale('en');
    } else {
      _locale = const Locale('vi');

      // changeLocale(const Locale('vi'));
    }

    notifyListeners();
  }
}
