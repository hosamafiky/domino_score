import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domino_score/features/players/domain/entities/player.dart';

class PlayerModel extends Player {
  const PlayerModel({required super.id, required super.name, required super.avatarColor, required super.createdAt});

  factory PlayerModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return PlayerModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      avatarColor: data['avatarColor'] as String? ?? '#1976D2',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {'name': name, 'avatarColor': avatarColor, 'createdAt': Timestamp.fromDate(createdAt)};
}
