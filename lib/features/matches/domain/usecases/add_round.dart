import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/matches/domain/repositories/matches_repository.dart';

class AddRound {
  AddRound(this._repository);

  final MatchesRepository _repository;

  Future<Either<Failure, void>> call({
    required String matchId,
    required String winnerId,
    required int pointsDelta,
    String? notes,
  }) =>
      _repository.addRound(
        matchId: matchId,
        winnerId: winnerId,
        pointsDelta: pointsDelta,
        notes: notes,
      );
}
