import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/matches/domain/entities/match.dart';
import 'package:domino_score/features/matches/domain/repositories/matches_repository.dart';

class AddMatch {
  AddMatch(this._repository);

  final MatchesRepository _repository;

  Future<Either<Failure, Match>> call({
    required String sessionId,
    required int targetScore,
    required String matchType,
    required List<String> participantIds,
  }) =>
      _repository.addMatch(
        sessionId: sessionId,
        targetScore: targetScore,
        matchType: matchType,
        participantIds: participantIds,
      );
}
