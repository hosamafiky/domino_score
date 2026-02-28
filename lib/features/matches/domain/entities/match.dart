import 'package:equatable/equatable.dart';

class Match extends Equatable {
  final String id;
  final String sessionId;
  final String matchType; // "1v1" | "triple" | "2v2"
  final List<String> participantIds;
  final int targetScore;
  final String status; // "active" | "ended"
  final String? winnerId;
  final Map<String, int> scores; // participantId -> score
  final DateTime createdAt;
  final DateTime? endedAt;

  const Match({
    required this.id,
    required this.sessionId,
    required this.matchType,
    required this.participantIds,
    required this.targetScore,
    required this.status,
    this.winnerId,
    required this.scores,
    required this.createdAt,
    this.endedAt,
  });

  bool get isEnded => status == 'ended';

  @override
  List<Object?> get props =>
      [id, sessionId, matchType, participantIds, targetScore, status, winnerId, scores, createdAt, endedAt];
}
