import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:domino_score/core/localization/app_localizations.dart';

class CongratulationsPage extends StatelessWidget {
  const CongratulationsPage({
    super.key,
    required this.winnerName,
    required this.sessionTitle,
    required this.sessionId,
  });

  final String winnerName;
  final String sessionTitle;
  final String sessionId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Directionality(
      textDirection: l10n.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n.congratulations, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 16),
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(l10n.winner, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(winnerName, style: Theme.of(context).textTheme.headlineSmall),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    FilledButton.icon(
                      icon: const Icon(Icons.add),
                      label: Text(l10n.nextMatch),
                      onPressed: () {
                        context.go('/sessions/$sessionId');
                      },
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: Text(l10n.backToSession),
                      onPressed: () => context.go('/sessions/$sessionId'),
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.share),
                      label: Text(l10n.share),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
