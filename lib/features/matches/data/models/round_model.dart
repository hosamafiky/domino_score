import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domino_score/features/matches/domain/entities/round.dart';

class RoundModel extends Round {
  const RoundModel({
    required super.id,
    required super.matchId,
    required super.index,
    required super.winnerId,
    required super.pointsDelta,
    super.notes,
    required super.createdAt,
  });

  factory RoundModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return RoundModel(
      id: doc.id,
      matchId: data['matchId'] as String? ?? '',
      index: (data['index'] as num?)?.toInt() ?? 0,
      winnerId: data['winnerId'] as String? ?? '',
      pointsDelta: (data['pointsDelta'] as num?)?.toInt() ?? 0,
      notes: data['notes'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'matchId': matchId,
        'index': index,
        'winnerId': winnerId,
        'pointsDelta': pointsDelta,
        if (notes != null) 'notes': notes,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
