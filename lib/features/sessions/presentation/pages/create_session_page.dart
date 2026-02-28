import 'package:domino_score/core/di/injection.dart';
import 'package:domino_score/core/localization/app_localizations.dart';
import 'package:domino_score/features/players/presentation/cubit/players_cubit.dart';
import 'package:domino_score/features/players/presentation/cubit/players_state.dart';
import 'package:domino_score/features/sessions/domain/entities/session.dart';
import 'package:domino_score/features/sessions/presentation/cubit/sessions_cubit.dart';
import 'package:domino_score/features/teams/presentation/cubit/teams_cubit.dart';
import 'package:domino_score/features/teams/presentation/cubit/teams_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateSessionPage extends StatefulWidget {
  const CreateSessionPage({super.key});

  @override
  State<CreateSessionPage> createState() => _CreateSessionPageState();
}

class _CreateSessionPageState extends State<CreateSessionPage> {
  final _titleController = TextEditingController();
  DateTime _date = DateTime.now();
  MatchType _matchType = MatchType.oneVOne;
  final _selectedPlayerIds = <String>{};
  final _selectedTeamIds = <String>{};

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<SessionsCubit>()),
        BlocProvider(create: (_) => sl<PlayersCubit>()..loadPlayers()),
        BlocProvider(create: (_) => sl<TeamsCubit>()..loadTeams()),
      ],
      child: _CreateSessionView(
        titleController: _titleController,
        date: _date,
        matchType: _matchType,
        selectedPlayerIds: _selectedPlayerIds,
        selectedTeamIds: _selectedTeamIds,
        onDateChanged: (d) => setState(() => _date = d),
        onMatchTypeChanged: (m) => setState(() => _matchType = m),
        onPlayerToggled: (id) => setState(() {
          if (_selectedPlayerIds.contains(id)) {
            _selectedPlayerIds.remove(id);
          } else {
            _selectedPlayerIds.add(id);
          }
        }),
        onTeamToggled: (id) => setState(() {
          if (_selectedTeamIds.contains(id)) {
            _selectedTeamIds.remove(id);
          } else {
            _selectedTeamIds.add(id);
          }
        }),
      ),
    );
  }
}

class _CreateSessionView extends StatelessWidget {
  const _CreateSessionView({
    required this.titleController,
    required this.date,
    required this.matchType,
    required this.selectedPlayerIds,
    required this.selectedTeamIds,
    required this.onDateChanged,
    required this.onMatchTypeChanged,
    required this.onPlayerToggled,
    required this.onTeamToggled,
  });

  final TextEditingController titleController;
  final DateTime date;
  final MatchType matchType;
  final Set<String> selectedPlayerIds;
  final Set<String> selectedTeamIds;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<MatchType> onMatchTypeChanged;
  final ValueChanged<String> onPlayerToggled;
  final ValueChanged<String> onTeamToggled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Directionality(
      textDirection: l10n.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.createSession),
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: l10n.sessionTitle),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(l10n.sessionDate),
                subtitle: Text('${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) onDateChanged(picked);
                },
              ),
              const SizedBox(height: 16),
              Text(l10n.matchType, style: Theme.of(context).textTheme.titleSmall),
              RadioGroup(
                groupValue: matchType,
                onChanged: (v) => v != null ? onMatchTypeChanged(v) : null,
                child: Column(
                  children: [
                    RadioListTile<MatchType>(title: Text(l10n.matchType1v1), value: MatchType.oneVOne),
                    RadioListTile<MatchType>(title: Text(l10n.matchTypeTriple), value: MatchType.triple),
                    RadioListTile<MatchType>(title: Text(l10n.matchType2v2), value: MatchType.twoVTwo),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (matchType == MatchType.twoVTwo) ...[
                Text(l10n.selectTeams, style: Theme.of(context).textTheme.titleSmall),
                BlocBuilder<TeamsCubit, TeamsState>(
                  builder: (context, state) {
                    if (state is TeamsSuccess) {
                      return Column(
                        children: state.teams
                            .map((t) => CheckboxListTile(title: Text(t.name), value: selectedTeamIds.contains(t.id), onChanged: (_) => onTeamToggled(t.id)))
                            .toList(),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ] else ...[
                Text(l10n.selectPlayers, style: Theme.of(context).textTheme.titleSmall),
                BlocBuilder<PlayersCubit, PlayersState>(
                  builder: (context, state) {
                    if (state is PlayersSuccess) {
                      final needed = matchType == MatchType.oneVOne ? 2 : 3;
                      return Column(
                        children: state.players
                            .map(
                              (p) => CheckboxListTile(
                                title: Text(p.name),
                                value: selectedPlayerIds.contains(p.id),
                                onChanged: (v) {
                                  if (v == true && selectedPlayerIds.length >= needed) return;
                                  onPlayerToggled(p.id);
                                },
                              ),
                            )
                            .toList(),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
              const SizedBox(height: 24),
              FilledButton(onPressed: () => _create(context), child: Text(l10n.save)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _create(BuildContext context) async {
    final title = titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter title')));
      return;
    }
    List<String> participantIds;
    if (matchType == MatchType.twoVTwo) {
      if (selectedTeamIds.length != 2) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select 2 teams')));
        return;
      }
      participantIds = selectedTeamIds.toList();
    } else {
      final needed = matchType == MatchType.oneVOne ? 2 : 3;
      if (selectedPlayerIds.length != needed) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Select $needed players')));
        return;
      }
      participantIds = selectedPlayerIds.toList();
    }
    final ok = await context.read<SessionsCubit>().createSession(title: title, date: date, matchType: matchType, participantIds: participantIds);
    if (ok && context.mounted) {
      context.pop();
    }
  }
}
