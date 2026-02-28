import 'package:domino_score/core/di/injection.dart';
import 'package:domino_score/core/localization/app_localizations.dart';
import 'package:domino_score/core/localization/app_localizations_delegate.dart';
import 'package:domino_score/core/router/app_router.dart';
import 'package:domino_score/core/theme/app_theme.dart';
import 'package:domino_score/firebase/messaging_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  await sl<MessagingService>().init();
  runApp(const DominoScoreApp());
}

class DominoScoreApp extends StatelessWidget {
  const DominoScoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Domino Score',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: createAppRouter(),
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: AppLocalizations.defaultLocale,
    );
  }
}
