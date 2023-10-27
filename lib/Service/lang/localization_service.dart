import 'dart:ui';

import 'package:gagagonew/Service/lang/pt_br.dart';
import 'package:get/get.dart';

import 'en_us.dart';
import 'es_es.dart';
import 'fr_fr.dart';

class LocalizationService extends Translations {
  // Default locale
  static const locale = Locale('en', 'US');

  static Locale currentLocale = const Locale('en', 'US');

  // fallbackLocale saves the day when the locale gets in trouble
  static const fallbackLocale = Locale('en', 'US');

  // Supported languages
  // Needs to be same order with locales
  static const langs = [
    'English',
    'Portuguese',
    'French',
    'Spanish',
  ];

  // Supported locales
  // Needs to be same order with langs
  static final locales = [
    const Locale('en', 'US'),
    const Locale('pt', 'BR'),
    const Locale('fr', 'FR'),
    const Locale('es', 'ES'),
  ];

  // Keys and their translations
  // Translations are separated maps in `lang` file
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS, // lang/en_us.dart
        'pt_BR': ptBR, // lang/pt_BR.dart
        'fr_FR': frFR, // lang/fr_FR.dart
        // 'hi_IN': hiIN, // lang/hi_IN.dart
        'es_ES': esES, // lang/es_ES.dart
      };

  // Gets locale from language, and updates the locale
  static void changeLocale(String lang) {
    print("under changeLocale");
    final locale = _getLocaleFromLanguage(lang);
    setCurrentLocale(locale);
    Get.updateLocale(locale);
  }

  // Finds language in `langs` list and returns it as Locale
  static Locale _getLocaleFromLanguage(String lang) {
    print("under _getLocaleFromLanguage $lang");

    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) return locales[i];
    }
    return Get.locale ?? locale;
  }

  static setCurrentLocale(Locale locale) {
    currentLocale = locale;
  }
}
