import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/matches/domain/repositories/matches_repository.dart';

class EndMatch {
  EndMatch(this._repository);

  final MatchesRepository _repository;

  Future<Either<Failure, void>> call(String matchId) =>
      _repository.endMatch(matchId);
}
