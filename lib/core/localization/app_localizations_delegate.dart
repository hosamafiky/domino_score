import 'package:flutter/material.dart';
import 'package:domino_score/core/localization/app_localizations.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ar', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final supported = AppLocalizations.supportedLocales
        .where((l) => l.languageCode == locale.languageCode)
        .toList();
    final effectiveLocale =
        supported.isNotEmpty ? supported.first : AppLocalizations.defaultLocale;
    return AppLocalizations(effectiveLocale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
