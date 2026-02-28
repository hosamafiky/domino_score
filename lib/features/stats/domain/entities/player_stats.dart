import 'package:equatable/equatable.dart';

class PlayerStats extends Equatable {
  final String playerId;
  final String name;
  final String? avatarColor;
  final int matchesPlayed;
  final int wins;
  final int sessionsParticipated;

  const PlayerStats({
    required this.playerId,
    required this.name,
    this.avatarColor,
    required this.matchesPlayed,
    required this.wins,
    required this.sessionsParticipated,
  });

  double get winRate => matchesPlayed > 0 ? wins / matchesPlayed : 0.0;

  @override
  List<Object?> get props => [playerId, name, matchesPlayed, wins, sessionsParticipated];
}
