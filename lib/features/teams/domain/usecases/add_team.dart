import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/teams/domain/entities/team.dart';
import 'package:domino_score/features/teams/domain/repositories/teams_repository.dart';

class AddTeam {
  AddTeam(this._repository);

  final TeamsRepository _repository;

  Future<Either<Failure, Team>> call({
    required String name,
    required List<String> playerIds,
  }) =>
      _repository.addTeam(name: name, playerIds: playerIds);
}
