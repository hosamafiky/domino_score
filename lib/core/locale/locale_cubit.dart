import 'package:domino_score/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _localeKey = 'app_locale';

class LocaleCubit extends Cubit<Locale?> {
  LocaleCubit(this._prefs) : super(null) {
    load();
  }

  final SharedPreferences _prefs;

  Future<void> load() async {
    final code = _prefs.getString(_localeKey);
    if (code != null && ['ar', 'en'].contains(code)) {
      emit(Locale(code));
    } else {
      emit(AppLocalizations.defaultLocale);
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (!AppLocalizations.supportedLocales.any((l) => l.languageCode == locale.languageCode)) return;
    await _prefs.setString(_localeKey, locale.languageCode);
    emit(locale);
  }
}
