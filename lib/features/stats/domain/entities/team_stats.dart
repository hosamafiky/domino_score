import 'package:equatable/equatable.dart';

class TeamStats extends Equatable {
  final String teamId;
  final String name;
  final int matchesPlayed;
  final int wins;
  final int sessionsParticipated;

  const TeamStats({
    required this.teamId,
    required this.name,
    required this.matchesPlayed,
    required this.wins,
    required this.sessionsParticipated,
  });

  double get winRate => matchesPlayed > 0 ? wins / matchesPlayed : 0.0;

  @override
  List<Object?> get props => [teamId, name, matchesPlayed, wins, sessionsParticipated];
}
