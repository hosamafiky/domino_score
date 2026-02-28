import 'package:domino_score/core/di/injection.dart';
import 'package:domino_score/core/locale/locale_cubit.dart';
import 'package:domino_score/core/localization/app_localizations.dart';
import 'package:domino_score/core/widgets/error_view.dart';
import 'package:domino_score/core/widgets/loading_widget.dart';
import 'package:domino_score/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:domino_score/features/settings/presentation/cubit/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => sl<SettingsCubit>(), child: const _SettingsView());
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Directionality(
      textDirection: l10n.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.settingsTitle)),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            if (state is SettingsInitial) return const LoadingWidget();
            if (state is SettingsError) return ErrorView(message: state.message);
            if (state is SettingsSuccess) {
              final s = state.settings;
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(l10n.targetScore, style: Theme.of(context).textTheme.titleMedium),
                  ListTile(
                    title: Text(l10n.targetScore1v1),
                    trailing: SizedBox(
                      width: 80,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(isDense: true),
                        controller: TextEditingController(text: '${s.targetScore1v1}'),
                        onSubmitted: (v) {
                          final n = int.tryParse(v);
                          if (n != null) context.read<SettingsCubit>().updateSettings(targetScore1v1: n);
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(l10n.targetScoreTriple),
                    trailing: SizedBox(
                      width: 80,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(isDense: true),
                        controller: TextEditingController(text: '${s.targetScoreTriple}'),
                        onSubmitted: (v) {
                          final n = int.tryParse(v);
                          if (n != null) context.read<SettingsCubit>().updateSettings(targetScoreTriple: n);
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(l10n.targetScore2v2),
                    trailing: SizedBox(
                      width: 80,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(isDense: true),
                        controller: TextEditingController(text: '${s.targetScore2v2}'),
                        onSubmitted: (v) {
                          final n = int.tryParse(v);
                          if (n != null) context.read<SettingsCubit>().updateSettings(targetScore2v2: n);
                        },
                      ),
                    ),
                  ),
                  const Divider(),
                  Text(l10n.notifications, style: Theme.of(context).textTheme.titleMedium),
                  SwitchListTile(
                    title: Text(l10n.notificationsMatchEnd),
                    value: s.notificationsMatchEnd,
                    onChanged: (v) => context.read<SettingsCubit>().updateSettings(notificationsMatchEnd: v),
                  ),
                  SwitchListTile(
                    title: Text(l10n.notificationsSessionReminders),
                    value: s.notificationsSessionReminders,
                    onChanged: (v) => context.read<SettingsCubit>().updateSettings(notificationsSessionReminders: v),
                  ),
                  const Divider(),
                  Text(l10n.language, style: Theme.of(context).textTheme.titleMedium),
                  BlocBuilder<LocaleCubit, Locale?>(
                    builder: (context, locale) {
                      final current = locale ?? AppLocalizations.defaultLocale;
                      final label = current.languageCode == 'ar' ? l10n.languageArabic : l10n.languageEnglish;
                      return ListTile(
                        title: Text(label),
                        trailing: const Icon(Icons.arrow_drop_down),
                        onTap: () => _showLanguagePicker(context),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(l10n.seedSampleData),
                    trailing: FilledButton(onPressed: () => _seedData(context), child: Text(l10n.seedSampleData)),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Future<void> _seedData(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await context.read<SettingsCubit>().seedSampleData();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.seedSampleDataDone)));
    }
  }

  void _showLanguagePicker(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.languageArabic),
              onTap: () {
                context.read<LocaleCubit>().setLocale(const Locale('ar'));
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text(l10n.languageEnglish),
              onTap: () {
                context.read<LocaleCubit>().setLocale(const Locale('en'));
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
