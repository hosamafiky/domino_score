import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/settings/domain/entities/settings_entity.dart';

abstract class SettingsRepository {
  Future<Either<Failure, SettingsEntity>> getSettings();
  Stream<SettingsEntity> watchSettings();
  Future<Either<Failure, void>> updateSettings({
    int? targetScore1v1,
    int? targetScoreTriple,
    int? targetScore2v2,
    bool? notificationsMatchEnd,
    bool? notificationsSessionReminders,
  });
}
