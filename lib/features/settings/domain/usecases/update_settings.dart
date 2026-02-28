import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/settings/domain/repositories/settings_repository.dart';

class UpdateSettings {
  UpdateSettings(this._repository);

  final SettingsRepository _repository;

  Future<Either<Failure, void>> call({
    int? targetScore1v1,
    int? targetScoreTriple,
    int? targetScore2v2,
    bool? notificationsMatchEnd,
    bool? notificationsSessionReminders,
  }) =>
      _repository.updateSettings(
        targetScore1v1: targetScore1v1,
        targetScoreTriple: targetScoreTriple,
        targetScore2v2: targetScore2v2,
        notificationsMatchEnd: notificationsMatchEnd,
        notificationsSessionReminders: notificationsSessionReminders,
      );
}
