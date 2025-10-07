import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en', 'US');

  Locale get currentLocale => _currentLocale;

  // Supported locales
  final List<Locale> supportedLocales = const [
    Locale('en', 'US'),
    Locale('hi', 'IN'),
    Locale('te', 'IN'),
    Locale('ta', 'IN'),
    Locale('kn', 'IN'),
    Locale('ml', 'IN'),
    Locale('mr', 'IN'),
    Locale('gu', 'IN'),
    Locale('bn', 'IN'),
    Locale('pa', 'IN'),
    Locale('or', 'IN'),
    Locale('as', 'IN'),
  ];

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('selected_language') ?? 'en';
      final countryCode = prefs.getString('selected_country') ?? 'US';

      final savedLocale = Locale(languageCode, countryCode);

      // Check if the saved locale is supported
      if (supportedLocales.contains(savedLocale)) {
        _currentLocale = savedLocale;
        notifyListeners();
      }
    } catch (e) {
      // If loading fails, keep default English
      debugPrint('Error loading saved language: $e');
    }
  }

  Future<void> changeLanguage(Locale newLocale) async {
    if (_currentLocale == newLocale) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_language', newLocale.languageCode);
      await prefs.setString('selected_country', newLocale.countryCode ?? 'US');

      _currentLocale = newLocale;
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving language preference: $e');
    }
  }

  String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'hi':
        return 'Hindi';
      case 'te':
        return 'Telugu';
      case 'ta':
        return 'Tamil';
      case 'kn':
        return 'Kannada';
      case 'ml':
        return 'Malayalam';
      case 'mr':
        return 'Marathi';
      case 'gu':
        return 'Gujarati';
      case 'bn':
        return 'Bengali';
      case 'pa':
        return 'Punjabi';
      case 'or':
        return 'Odia';
      case 'as':
        return 'Assamese';
      default:
        return 'English';
    }
  }

  String getLanguageFlag(String languageCode) {
    switch (languageCode) {
      case 'en':
        return '🇺🇸';
      case 'hi':
      case 'te':
      case 'ta':
      case 'kn':
      case 'ml':
      case 'mr':
      case 'gu':
      case 'bn':
      case 'pa':
      case 'or':
      case 'as':
        return '🇮🇳';
      default:
        return '🇺🇸';
    }
  }
}
