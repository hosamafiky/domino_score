import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/matches/domain/entities/match.dart';
import 'package:domino_score/features/matches/domain/entities/round.dart';

abstract class MatchesRepository {
  Future<Either<Failure, Match>> addMatch({
    required String sessionId,
    required int targetScore,
    required String matchType,
    required List<String> participantIds,
  });
  Future<Either<Failure, Match>> getMatch(String matchId);
  Stream<Match?> watchMatch(String matchId);
  Stream<List<Match>> watchMatchesForSession(String sessionId);
  Stream<List<Round>> watchRounds(String matchId);
  Future<Either<Failure, void>> addRound({
    required String matchId,
    required String winnerId,
    required int pointsDelta,
    String? notes,
  });
  Future<Either<Failure, void>> undoLastRound(String matchId);
  Future<Either<Failure, void>> endMatch(String matchId);
}
