import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/stats/domain/entities/player_stats.dart';
import 'package:domino_score/features/stats/domain/entities/team_stats.dart';
import 'package:domino_score/features/stats/domain/entities/stats_trends.dart';

abstract class StatsRepository {
  Future<Either<Failure, List<PlayerStats>>> getPlayerLeaderboard();
  Future<Either<Failure, List<TeamStats>>> getTeamLeaderboard();
  Future<Either<Failure, StatsTrends>> getTrends();
}
