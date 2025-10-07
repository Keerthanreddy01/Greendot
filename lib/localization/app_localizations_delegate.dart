import 'package:flutter/material.dart';
import 'app_localizations.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_te.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_or.dart';
import 'app_localizations_as.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return [
      'en', 'hi', 'te', 'ta', 'kn', 'ml',
      'mr', 'gu', 'bn', 'pa', 'or', 'as'
    ].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'hi':
        return AppLocalizationsHi();
      case 'te':
        return AppLocalizationsTe();
      case 'ta':
        return AppLocalizationsTa();
      case 'kn':
        return AppLocalizationsKn();
      case 'ml':
        return AppLocalizationsMl();
      case 'mr':
        return AppLocalizationsMr();
      case 'gu':
        return AppLocalizationsGu();
      case 'bn':
        return AppLocalizationsBn();
      case 'pa':
        return AppLocalizationsPa();
      case 'or':
        return AppLocalizationsOr();
      case 'as':
        return AppLocalizationsAs();
      default:
        return AppLocalizationsEn();
    }
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
