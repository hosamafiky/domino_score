import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/exceptions.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/stats/domain/entities/player_stats.dart';
import 'package:domino_score/features/stats/domain/entities/team_stats.dart';
import 'package:domino_score/features/stats/domain/entities/stats_trends.dart';
import 'package:domino_score/features/stats/domain/repositories/stats_repository.dart';
import 'package:domino_score/features/stats/data/datasources/stats_remote_datasource.dart';

class StatsRepositoryImpl implements StatsRepository {
  StatsRepositoryImpl(this._datasource);

  final StatsRemoteDatasource _datasource;

  @override
  Future<Either<Failure, List<PlayerStats>>> getPlayerLeaderboard() async {
    try {
      final list = await _datasource.getPlayerLeaderboard();
      return right(list);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<TeamStats>>> getTeamLeaderboard() async {
    try {
      final list = await _datasource.getTeamLeaderboard();
      return right(list);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, StatsTrends>> getTrends() async {
    try {
      final trends = await _datasource.getTrends();
      return right(trends);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    }
  }
}
