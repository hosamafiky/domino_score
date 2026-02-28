import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domino_score/core/localization/app_localizations.dart';
import 'package:domino_score/core/utils/constants.dart';
import 'package:domino_score/core/di/injection.dart';
import 'package:domino_score/features/matches/presentation/cubit/match_cubit.dart';
import 'package:domino_score/features/players/domain/entities/player.dart';
import 'package:domino_score/features/players/domain/usecases/get_players.dart';
import 'package:domino_score/features/teams/domain/entities/team.dart';
import 'package:domino_score/features/teams/domain/usecases/get_teams.dart';
import 'package:domino_score/features/matches/domain/usecases/get_match.dart';

class AddRoundBottomSheet extends StatefulWidget {
  const AddRoundBottomSheet({super.key, required this.matchId, required this.sessionId});

  final String matchId;
  final String sessionId;

  @override
  State<AddRoundBottomSheet> createState() => _AddRoundBottomSheetState();
}

class _AddRoundBottomSheetState extends State<AddRoundBottomSheet> {
  String? _winnerId;
  int _pointsDelta = 10;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FutureBuilder(
      future: sl<GetMatch>().call(widget.matchId),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done || !snap.hasData) {
          return const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()));
        }
        final result = snap.data!;
        return result.fold(
          (_) => const Padding(padding: EdgeInsets.all(24), child: Text('Error')),
          (match) => _buildContent(context, l10n, match.matchType == '2v2', match.participantIds),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations l10n, bool is2v2, List<String> participantIds) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      expand: false,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(is2v2 ? l10n.pickWinningTeam : l10n.pickWinner, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            FutureBuilder(
              future: _participantNames(participantIds, is2v2),
              builder: (context, nameSnap) {
                final names = nameSnap.data ?? <String, String>{};
                return Wrap(
                  spacing: 8,
                  children: participantIds.map((id) => ChoiceChip(
                    label: Text(names[id] ?? id),
                    selected: _winnerId == id,
                    onSelected: (v) => setState(() => _winnerId = v ? id : null),
                  )).toList(),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(l10n.points, style: Theme.of(context).textTheme.titleSmall),
            Row(
              children: quickPointOptions.map((p) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilledButton(
                  onPressed: () => setState(() => _pointsDelta = p),
                  child: Text('+$p'),
                ),
              )).toList(),
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.points),
              onChanged: (v) => setState(() => _pointsDelta = int.tryParse(v) ?? _pointsDelta),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(labelText: l10n.notes),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _winnerId == null ? null : () => _submit(context),
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, String>> _participantNames(List<String> ids, bool isTeam) async {
    final map = <String, String>{};
    if (isTeam) {
      final result = await sl<GetTeams>().call();
      final list = result.fold((_) => <Team>[], (r) => r);
      for (final t in list) {
        if (ids.contains(t.id)) map[t.id] = t.name;
      }
    } else {
      final result = await sl<GetPlayers>().call();
      final list = result.fold((_) => <Player>[], (r) => r);
      for (final p in list) {
        if (ids.contains(p.id)) map[p.id] = p.name;
      }
    }
    for (final id in ids) {
      map.putIfAbsent(id, () => id);
    }
    return map;
  }

  Future<void> _submit(BuildContext context) async {
    if (_winnerId == null) return;
    final ok = await context.read<MatchCubit>().addRound(
      matchId: widget.matchId,
      winnerId: _winnerId!,
      pointsDelta: _pointsDelta,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );
    if (ok && context.mounted) Navigator.of(context).pop();
  }
}
