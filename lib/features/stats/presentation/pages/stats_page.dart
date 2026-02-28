import 'package:domino_score/core/di/injection.dart';
import 'package:domino_score/core/localization/app_localizations.dart';
import 'package:domino_score/core/widgets/error_view.dart';
import 'package:domino_score/core/widgets/loading_widget.dart';
import 'package:domino_score/features/stats/presentation/cubit/stats_cubit.dart';
import 'package:domino_score/features/stats/presentation/cubit/stats_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<StatsCubit>(),
      child: _StatsView(tabController: _tabController),
    );
  }
}

class _StatsView extends StatelessWidget {
  const _StatsView({required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Directionality(
      textDirection: l10n.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.statsTitle),
          bottom: TabBar(
            controller: tabController,
            tabs: [
              Tab(text: l10n.tabPlayers),
              Tab(text: l10n.tabTeamsStat),
              Tab(text: l10n.tabTrends),
            ],
          ),
        ),
        body: TabBarView(controller: tabController, children: [_PlayersTab(), _TeamsTab(), _TrendsTab()]),
      ),
    );
  }
}

class _PlayersTab extends StatefulWidget {
  @override
  State<_PlayersTab> createState() => _PlayersTabState();
}

class _PlayersTabState extends State<_PlayersTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StatsCubit>().loadPlayerLeaderboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsCubit, StatsState>(
      buildWhen: (a, b) => b is StatsPlayersSuccess || b is StatsLoading || b is StatsError,
      builder: (context, state) {
        if (state is StatsLoading) return const LoadingWidget();
        if (state is StatsError) return ErrorView(message: state.message);
        if (state is StatsPlayersSuccess) {
          final list = state.players;
          if (list.isEmpty) return Center(child: Text(AppLocalizations.of(context).empty));
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final p = list[i];
              return Card(
                child: ListTile(
                  title: Text(p.name),
                  subtitle: Text(
                    '${AppLocalizations.of(context).winRate}: ${(p.winRate * 100).toStringAsFixed(0)}% • ${AppLocalizations.of(context).matchesPlayed}: ${p.matchesPlayed}',
                  ),
                ),
              );
            },
          );
        }
        return const Center(child: Text('Load players'));
      },
    );
  }
}

class _TeamsTab extends StatefulWidget {
  @override
  State<_TeamsTab> createState() => _TeamsTabState();
}

class _TeamsTabState extends State<_TeamsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StatsCubit>().loadTeamLeaderboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsCubit, StatsState>(
      buildWhen: (a, b) => b is StatsTeamsSuccess || b is StatsLoading || b is StatsError,
      builder: (context, state) {
        if (state is StatsLoading) return const LoadingWidget();
        if (state is StatsError) return ErrorView(message: state.message);
        if (state is StatsTeamsSuccess) {
          final list = state.teams;
          if (list.isEmpty) return Center(child: Text(AppLocalizations.of(context).empty));
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final t = list[i];
              return Card(
                child: ListTile(
                  title: Text(t.name),
                  subtitle: Text(
                    '${AppLocalizations.of(context).winRate}: ${(t.winRate * 100).toStringAsFixed(0)}% • ${AppLocalizations.of(context).matchesPlayed}: ${t.matchesPlayed}',
                  ),
                ),
              );
            },
          );
        }
        return const Center(child: Text('Load teams'));
      },
    );
  }
}

class _TrendsTab extends StatefulWidget {
  @override
  State<_TrendsTab> createState() => _TrendsTabState();
}

class _TrendsTabState extends State<_TrendsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StatsCubit>().loadTrends();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsCubit, StatsState>(
      buildWhen: (a, b) => b is StatsTrendsSuccess || b is StatsLoading || b is StatsError,
      builder: (context, state) {
        if (state is StatsLoading) return const LoadingWidget();
        if (state is StatsError) return ErrorView(message: state.message);
        if (state is StatsTrendsSuccess) {
          final trends = state.trends;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Match type distribution', style: Theme.of(context).textTheme.titleMedium),
              ...trends.matchTypeDistribution.entries.map((e) => ListTile(title: Text('${e.key}: ${e.value}'))),
            ],
          );
        }
        return const Center(child: Text('Load trends'));
      },
    );
  }
}
