import 'package:domino_score/features/stats/domain/entities/player_stats.dart';
import 'package:domino_score/features/stats/domain/entities/stats_trends.dart';
import 'package:domino_score/features/stats/domain/entities/team_stats.dart';
import 'package:equatable/equatable.dart';

abstract class StatsState extends Equatable {
  const StatsState();

  @override
  List<Object?> get props => [];
}

class StatsInitial extends StatsState {}

class StatsLoading extends StatsState {}

class StatsPlayersSuccess extends StatsState {
  final List<PlayerStats> players;

  const StatsPlayersSuccess(this.players);

  @override
  List<Object?> get props => [players];
}

class StatsTeamsSuccess extends StatsState {
  final List<TeamStats> teams;

  const StatsTeamsSuccess(this.teams);

  @override
  List<Object?> get props => [teams];
}

class StatsTrendsSuccess extends StatsState {
  final StatsTrends trends;

  const StatsTrendsSuccess(this.trends);

  @override
  List<Object?> get props => [trends];
}

class StatsError extends StatsState {
  final String message;

  const StatsError(this.message);

  @override
  List<Object?> get props => [message];
}
