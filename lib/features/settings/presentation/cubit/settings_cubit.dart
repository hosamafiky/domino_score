import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domino_score/features/settings/domain/entities/settings_entity.dart';
import 'package:domino_score/features/settings/domain/repositories/settings_repository.dart';
import 'package:domino_score/features/settings/domain/usecases/update_settings.dart';
import 'package:domino_score/features/settings/domain/usecases/seed_sample_data.dart';
import 'package:domino_score/features/settings/presentation/cubit/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repository, this._updateSettings, this._seedSampleData) : super(SettingsInitial()) {
    _sub = _repository.watchSettings().listen(
      (s) => emit(SettingsSuccess(s)),
      onError: (e) => emit(SettingsError(e.toString())),
    );
  }

  final SettingsRepository _repository;
  final UpdateSettings _updateSettings;
  final SeedSampleData _seedSampleData;
  StreamSubscription<SettingsEntity>? _sub;

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }

  Future<bool> updateSettings({
    int? targetScore1v1,
    int? targetScoreTriple,
    int? targetScore2v2,
    bool? notificationsMatchEnd,
    bool? notificationsSessionReminders,
  }) async {
    final result = await _updateSettings(
      targetScore1v1: targetScore1v1,
      targetScoreTriple: targetScoreTriple,
      targetScore2v2: targetScore2v2,
      notificationsMatchEnd: notificationsMatchEnd,
      notificationsSessionReminders: notificationsSessionReminders,
    );
    return result.fold(
      (f) => false,
      (_) => true,
    );
  }

  Future<bool> seedSampleData() => _seedSampleData();
}
