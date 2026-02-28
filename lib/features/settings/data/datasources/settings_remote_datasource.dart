import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domino_score/core/error/exceptions.dart';
import 'package:domino_score/features/settings/data/models/settings_model.dart';
import 'package:domino_score/firebase/firestore_refs.dart';

class SettingsRemoteDatasource {
  SettingsRemoteDatasource(this._refs);

  final FirestoreRefs _refs;

  Future<SettingsModel> getSettings() async {
    try {
      final doc = await _refs.globalSettings.get();
      if (!doc.exists) {
        final defaultModel = const SettingsModel();
        await _refs.globalSettings.set(defaultModel.toMap());
        return defaultModel;
      }
      return SettingsModel.fromFirestore(doc);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Stream<SettingsModel> watchSettings() {
    return _refs.globalSettings.snapshots().map((doc) {
      if (!doc.exists) return const SettingsModel();
      return SettingsModel.fromFirestore(doc);
    });
  }

  Future<void> updateSettings({
    int? targetScore1v1,
    int? targetScoreTriple,
    int? targetScore2v2,
    bool? notificationsMatchEnd,
    bool? notificationsSessionReminders,
  }) async {
    try {
      final data = <String, dynamic>{'updatedAt': FieldValue.serverTimestamp()};
      if (targetScore1v1 != null) data['targetScore_1v1'] = targetScore1v1;
      if (targetScoreTriple != null) data['targetScore_triple'] = targetScoreTriple;
      if (targetScore2v2 != null) data['targetScore_2v2'] = targetScore2v2;
      if (notificationsMatchEnd != null) {
        data['notifications_matchEnd'] = notificationsMatchEnd;
      }
      if (notificationsSessionReminders != null) {
        data['notifications_sessionReminders'] = notificationsSessionReminders;
      }
      await _refs.globalSettings.set(data, SetOptions(merge: true));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
