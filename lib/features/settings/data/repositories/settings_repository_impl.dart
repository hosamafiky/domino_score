import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/exceptions.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/settings/domain/entities/settings_entity.dart';
import 'package:domino_score/features/settings/domain/repositories/settings_repository.dart';
import 'package:domino_score/features/settings/data/datasources/settings_remote_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._datasource);

  final SettingsRemoteDatasource _datasource;

  @override
  Future<Either<Failure, SettingsEntity>> getSettings() async {
    try {
      final settings = await _datasource.getSettings();
      return right(settings);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    }
  }

  @override
  Stream<SettingsEntity> watchSettings() => _datasource.watchSettings();

  @override
  Future<Either<Failure, void>> updateSettings({
    int? targetScore1v1,
    int? targetScoreTriple,
    int? targetScore2v2,
    bool? notificationsMatchEnd,
    bool? notificationsSessionReminders,
  }) async {
    try {
      await _datasource.updateSettings(
        targetScore1v1: targetScore1v1,
        targetScoreTriple: targetScoreTriple,
        targetScore2v2: targetScore2v2,
        notificationsMatchEnd: notificationsMatchEnd,
        notificationsSessionReminders: notificationsSessionReminders,
      );
      return right(null);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    }
  }
}
