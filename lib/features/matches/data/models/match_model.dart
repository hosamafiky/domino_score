import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domino_score/features/matches/domain/entities/match.dart';

class MatchModel extends Match {
  const MatchModel({
    required super.id,
    required super.sessionId,
    required super.matchType,
    required super.participantIds,
    required super.targetScore,
    required super.status,
    super.winnerId,
    required super.scores,
    required super.createdAt,
    super.endedAt,
  });

  factory MatchModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final participantIds = (data['participantIds'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
    final scoresMap = data['scores'] as Map<String, dynamic>?;
    final scores = <String, int>{};
    if (scoresMap != null) {
      for (final e in scoresMap.entries) {
        scores[e.key] = (e.value is int) ? e.value : int.tryParse(e.value.toString()) ?? 0;
      }
    }
    for (final id in participantIds) {
      scores.putIfAbsent(id, () => 0);
    }
    return MatchModel(
      id: doc.id,
      sessionId: data['sessionId'] as String? ?? '',
      matchType: data['matchType'] as String? ?? '1v1',
      participantIds: participantIds,
      targetScore: (data['targetScore'] as num?)?.toInt() ?? 100,
      status: data['status'] as String? ?? 'active',
      winnerId: data['winnerId'] as String?,
      scores: scores,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endedAt: (data['endedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'sessionId': sessionId,
        'matchType': matchType,
        'participantIds': participantIds,
        'targetScore': targetScore,
        'status': status,
        if (winnerId != null) 'winnerId': winnerId,
        'scores': scores,
        'createdAt': Timestamp.fromDate(createdAt),
        if (endedAt != null) 'endedAt': Timestamp.fromDate(endedAt!),
      };
}
