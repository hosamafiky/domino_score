import 'package:domino_score/features/stats/domain/usecases/compute_stats.dart';
import 'package:domino_score/features/stats/presentation/cubit/stats_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatsCubit extends Cubit<StatsState> {
  StatsCubit(this._computeStats) : super(StatsInitial());

  final ComputeStats _computeStats;

  Future<void> loadPlayerLeaderboard() async {
    emit(StatsLoading());
    final result = await _computeStats.playerLeaderboard();
    result.fold((f) => emit(StatsError(f.message)), (list) => emit(StatsPlayersSuccess(list)));
  }

  Future<void> loadTeamLeaderboard() async {
    emit(StatsLoading());
    final result = await _computeStats.teamLeaderboard();
    result.fold((f) => emit(StatsError(f.message)), (list) => emit(StatsTeamsSuccess(list)));
  }

  Future<void> loadTrends() async {
    emit(StatsLoading());
    final result = await _computeStats.trends();
    result.fold((f) => emit(StatsError(f.message)), (trends) => emit(StatsTrendsSuccess(trends)));
  }
}
