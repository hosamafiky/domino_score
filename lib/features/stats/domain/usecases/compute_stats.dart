import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/stats/domain/entities/player_stats.dart';
import 'package:domino_score/features/stats/domain/entities/team_stats.dart';
import 'package:domino_score/features/stats/domain/entities/stats_trends.dart';
import 'package:domino_score/features/stats/domain/repositories/stats_repository.dart';

class ComputeStats {
  ComputeStats(this._repository);

  final StatsRepository _repository;

  Future<Either<Failure, List<PlayerStats>>> playerLeaderboard() =>
      _repository.getPlayerLeaderboard();

  Future<Either<Failure, List<TeamStats>>> teamLeaderboard() =>
      _repository.getTeamLeaderboard();

  Future<Either<Failure, StatsTrends>> trends() => _repository.getTrends();
}
