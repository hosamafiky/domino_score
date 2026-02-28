import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domino_score/features/teams/domain/entities/team.dart';

class TeamModel extends Team {
  const TeamModel({
    required super.id,
    required super.name,
    required super.playerIds,
    required super.createdAt,
  });

  factory TeamModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final list = data['playerIds'] as List<dynamic>?;
    return TeamModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      playerIds: list?.map((e) => e.toString()).toList() ?? [],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'playerIds': playerIds,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
