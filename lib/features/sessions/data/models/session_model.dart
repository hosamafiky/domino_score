import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domino_score/features/sessions/domain/entities/session.dart';

class SessionModel extends Session {
  const SessionModel({
    required super.id,
    required super.title,
    required super.date,
    required super.matchType,
    required super.participantIds,
    required super.status,
    required super.createdAt,
    super.endedAt,
  });

  factory SessionModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final list = data['participantIds'] as List<dynamic>?;
    return SessionModel(
      id: doc.id,
      title: data['title'] as String? ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      matchType: MatchTypeX.fromString(data['matchType'] as String? ?? '1v1'),
      participantIds: list?.map((e) => e.toString()).toList() ?? [],
      status: data['status'] as String? ?? 'active',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endedAt: (data['endedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'date': Timestamp.fromDate(date),
        'matchType': matchType.value,
        'participantIds': participantIds,
        'status': status,
        'createdAt': Timestamp.fromDate(createdAt),
        if (endedAt != null) 'endedAt': Timestamp.fromDate(endedAt!),
      };
}
