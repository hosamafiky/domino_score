import 'package:domino_score/core/di/injection.dart';
import 'package:domino_score/core/locale/locale_cubit.dart';
import 'package:domino_score/core/localization/app_localizations.dart';
import 'package:domino_score/core/localization/app_localizations_delegate.dart';
import 'package:domino_score/core/router/app_router.dart';
import 'package:domino_score/core/theme/app_theme.dart';
import 'package:domino_score/firebase/messaging_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  await sl<MessagingService>().init();
  final router = createAppRouter();
  runApp(
    BlocProvider<LocaleCubit>.value(
      value: sl<LocaleCubit>(),
      child: DominoScoreApp(router: router),
    ),
  );
}

class DominoScoreApp extends StatelessWidget {
  const DominoScoreApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale?>(
      buildWhen: (prev, next) => prev != next,
      builder: (context, locale) {
        return MaterialApp.router(
          title: 'Domino Score',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: ThemeMode.system,
          routerConfig: router,
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale ?? AppLocalizations.defaultLocale,
        );
      },
    );
  }
}
