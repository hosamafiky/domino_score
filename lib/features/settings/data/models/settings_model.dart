import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domino_score/features/settings/domain/entities/settings_entity.dart';

class SettingsModel extends SettingsEntity {
  const SettingsModel({
    super.targetScore1v1 = 100,
    super.targetScoreTriple = 100,
    super.targetScore2v2 = 100,
    super.notificationsMatchEnd = true,
    super.notificationsSessionReminders = false,
    super.updatedAt,
  });

  factory SettingsModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return SettingsModel(
      targetScore1v1: (data['targetScore_1v1'] as num?)?.toInt() ?? 100,
      targetScoreTriple: (data['targetScore_triple'] as num?)?.toInt() ?? 100,
      targetScore2v2: (data['targetScore_2v2'] as num?)?.toInt() ?? 100,
      notificationsMatchEnd: data['notifications_matchEnd'] as bool? ?? true,
      notificationsSessionReminders:
          data['notifications_sessionReminders'] as bool? ?? false,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'targetScore_1v1': targetScore1v1,
        'targetScore_triple': targetScoreTriple,
        'targetScore_2v2': targetScore2v2,
        'notifications_matchEnd': notificationsMatchEnd,
        'notifications_sessionReminders': notificationsSessionReminders,
        'updatedAt': FieldValue.serverTimestamp(),
      };
}
