import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/settings/domain/entities/settings_entity.dart';
import 'package:domino_score/features/settings/domain/repositories/settings_repository.dart';

class GetSettings {
  GetSettings(this._repository);

  final SettingsRepository _repository;

  Future<Either<Failure, SettingsEntity>> call() => _repository.getSettings();
}
