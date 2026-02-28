import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/teams/domain/entities/team.dart';

abstract class TeamsRepository {
  Future<Either<Failure, List<Team>>> getTeams();
  Future<Either<Failure, Team>> addTeam({
    required String name,
    required List<String> playerIds,
  });
}
