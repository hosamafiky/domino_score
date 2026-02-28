import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/exceptions.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/teams/data/datasources/teams_remote_datasource.dart';
import 'package:domino_score/features/teams/domain/entities/team.dart';
import 'package:domino_score/features/teams/domain/repositories/teams_repository.dart';

class TeamsRepositoryImpl implements TeamsRepository {
  TeamsRepositoryImpl(this._datasource);

  final TeamsRemoteDatasource _datasource;

  @override
  Future<Either<Failure, List<Team>>> getTeams() async {
    try {
      final list = await _datasource.getTeams();
      return right(list);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } on ValidationException catch (e) {
      return left(ValidationFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Team>> addTeam({required String name, required List<String> playerIds}) async {
    try {
      final team = await _datasource.addTeam(name: name, playerIds: playerIds);
      return right(team);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } on ValidationException catch (e) {
      return left(ValidationFailure(e.message));
    }
  }
}
