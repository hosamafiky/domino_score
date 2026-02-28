import 'package:domino_score/core/di/injection.dart' as di;
import 'package:domino_score/core/localization/app_localizations.dart';
import 'package:domino_score/core/widgets/error_view.dart';
import 'package:domino_score/core/widgets/loading_widget.dart';
import 'package:domino_score/features/sessions/domain/entities/session.dart';
import 'package:domino_score/features/sessions/presentation/cubit/session_details_cubit.dart';
import 'package:domino_score/features/sessions/presentation/cubit/session_details_state.dart';
import 'package:domino_score/features/settings/domain/usecases/get_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SessionDetailsPage extends StatelessWidget {
  const SessionDetailsPage({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<SessionDetailsCubit>()..loadSession(sessionId),
      child: _SessionDetailsView(sessionId: sessionId),
    );
  }
}

class _SessionDetailsView extends StatelessWidget {
  const _SessionDetailsView({required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Directionality(
      textDirection: l10n.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.sessionsTitle),
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        ),
        body: BlocBuilder<SessionDetailsCubit, SessionDetailsState>(
          builder: (context, state) {
            if (state is SessionDetailsLoading) return const LoadingWidget();
            if (state is SessionDetailsError) {
              return ErrorView(message: state.message);
            }
            if (state is SessionDetailsSuccess) {
              final session = state.session;
              final matches = state.matches;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(session.title, style: Theme.of(context).textTheme.titleLarge),
                            Text('${session.matchType.value} • ${session.status}'),
                          ],
                        ),
                      ),
                    ),
                    if (session.isActive) ...[
                      const SizedBox(height: 16),
                      FilledButton.icon(icon: const Icon(Icons.add), label: Text(l10n.addMatch), onPressed: () => _addMatch(context)),
                    ],
                    const SizedBox(height: 16),
                    Text(l10n.sessionsTitle, style: Theme.of(context).textTheme.titleSmall),
                    ...matches.map(
                      (m) => Card(
                        child: ListTile(
                          title: Text('Match • ${m.status}'),
                          subtitle: Text('Target: ${m.targetScore}'),
                          trailing: m.status == 'active'
                              ? IconButton(icon: const Icon(Icons.open_in_new), onPressed: () => context.push('/sessions/$sessionId/match/${m.id}'))
                              : null,
                          onTap: () => context.push('/sessions/$sessionId/match/${m.id}'),
                        ),
                      ),
                    ),
                    if (session.isActive) TextButton(onPressed: () => _endSession(context), child: Text('${l10n.ended} ${l10n.sessionsTitle}')),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Future<void> _addMatch(BuildContext context) async {
    final cubit = context.read<SessionDetailsCubit>();
    final state = cubit.state;
    if (state is! SessionDetailsSuccess) return;
    final getSettings = di.sl<GetSettings>();
    final settingsResult = await getSettings();
    final targetScore = settingsResult.fold((_) => 100, (s) {
      switch (state.session.matchType) {
        case MatchType.oneVOne:
          return s.targetScore1v1;
        case MatchType.triple:
          return s.targetScoreTriple;
        case MatchType.twoVTwo:
          return s.targetScore2v2;
      }
    });
    await cubit.addMatch(sessionId, targetScore);
  }

  Future<void> _endSession(BuildContext context) async {
    final ok = await context.read<SessionDetailsCubit>().endSession(sessionId);
    if (ok && context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Session ended')));
  }
}
