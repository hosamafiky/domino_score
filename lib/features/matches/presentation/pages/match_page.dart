import 'package:domino_score/core/di/injection.dart';
import 'package:domino_score/core/localization/app_localizations.dart';
import 'package:domino_score/core/widgets/error_view.dart';
import 'package:domino_score/core/widgets/loading_widget.dart';
import 'package:domino_score/features/matches/presentation/cubit/match_cubit.dart';
import 'package:domino_score/features/matches/presentation/cubit/match_state.dart';
import 'package:domino_score/features/matches/presentation/widgets/add_round_bottom_sheet.dart';
import 'package:domino_score/features/players/domain/usecases/get_players.dart';
import 'package:domino_score/features/sessions/domain/usecases/get_session.dart';
import 'package:domino_score/features/teams/domain/usecases/get_teams.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key, required this.sessionId, required this.matchId});

  final String sessionId;
  final String matchId;

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MatchCubit>()..loadMatch(widget.matchId),
      child: _MatchView(sessionId: widget.sessionId, matchId: widget.matchId),
    );
  }
}

class _MatchView extends StatelessWidget {
  const _MatchView({required this.sessionId, required this.matchId});

  final String sessionId;
  final String matchId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Directionality(
      textDirection: l10n.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Match'),
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        ),
        body: BlocConsumer<MatchCubit, MatchState>(
          listener: (context, state) async {
            if (state is MatchSuccess && state.match.isEnded) {
              final winnerId = state.match.winnerId ?? '';
              final is2v2 = state.match.matchType == '2v2';
              final name = await _participantName(winnerId, is2v2);
              final sessionResult = await sl<GetSession>().call(sessionId);
              final sessionTitle = sessionResult.fold((_) => '', (s) => s.title);
              if (context.mounted) {
                context.push('/congratulations', extra: {'winnerName': name, 'sessionTitle': sessionTitle, 'sessionId': sessionId});
              }
            }
          },
          builder: (context, state) {
            if (state is MatchLoading) return const LoadingWidget();
            if (state is MatchError) return ErrorView(message: state.message);
            if (state is MatchSuccess) {
              final match = state.match;
              final participantIds = match.participantIds;
              final scores = match.scores;
              final is2v2 = match.matchType == '2v2';
              return Column(
                children: [
                  Material(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: participantIds
                            .map(
                              (id) => FutureBuilder(
                                future: _participantName(id, is2v2),
                                builder: (context, snap) {
                                  final name = snap.data ?? id;
                                  final score = scores[id] ?? 0;
                                  final isWinner = match.winnerId == id;
                                  return Column(
                                    children: [
                                      Text(name, style: Theme.of(context).textTheme.titleSmall),
                                      Text(
                                        '$score',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.displaySmall?.copyWith(color: isWinner ? Theme.of(context).colorScheme.primary : null),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        if (match.status == 'active') ...[
                          FilledButton.icon(icon: const Icon(Icons.add), label: Text(l10n.addRound), onPressed: () => _showAddRound(context)),
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.undo),
                            label: Text(l10n.undoLastRound),
                            onPressed: () => context.read<MatchCubit>().undoLastRound(matchId),
                          ),
                        ],
                      ],
                    ),
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

  Future<String> _participantName(String id, bool isTeam) async {
    if (isTeam) {
      final result = await sl<GetTeams>().call();
      return result.fold((_) => id, (list) => list.where((t) => t.id == id).firstOrNull?.name ?? id);
    }
    final result = await sl<GetPlayers>().call();
    return result.fold((_) => id, (list) => list.where((p) => p.id == id).firstOrNull?.name ?? id);
  }

  void _showAddRound(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => BlocProvider.value(
        value: context.read<MatchCubit>(),
        child: AddRoundBottomSheet(matchId: matchId, sessionId: sessionId),
      ),
    );
  }
}
