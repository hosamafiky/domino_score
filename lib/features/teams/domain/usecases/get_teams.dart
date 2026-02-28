import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/teams/domain/entities/team.dart';
import 'package:domino_score/features/teams/domain/repositories/teams_repository.dart';

class GetTeams {
  GetTeams(this._repository);

  final TeamsRepository _repository;

  Future<Either<Failure, List<Team>>> call() => _repository.getTeams();
}
