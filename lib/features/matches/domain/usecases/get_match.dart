import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/matches/domain/entities/match.dart';
import 'package:domino_score/features/matches/domain/repositories/matches_repository.dart';

class GetMatch {
  GetMatch(this._repository);

  final MatchesRepository _repository;

  Future<Either<Failure, Match>> call(String matchId) =>
      _repository.getMatch(matchId);
}
