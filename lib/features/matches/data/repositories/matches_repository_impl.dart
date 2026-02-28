import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/exceptions.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/matches/domain/entities/match.dart';
import 'package:domino_score/features/matches/domain/entities/round.dart';
import 'package:domino_score/features/matches/domain/repositories/matches_repository.dart';
import 'package:domino_score/features/matches/data/datasources/matches_remote_datasource.dart';

class MatchesRepositoryImpl implements MatchesRepository {
  MatchesRepositoryImpl(this._datasource);

  final MatchesRemoteDatasource _datasource;

  @override
  Future<Either<Failure, Match>> addMatch({
    required String sessionId,
    required int targetScore,
    required String matchType,
    required List<String> participantIds,
  }) async {
    try {
      final match = await _datasource.addMatch(
        sessionId: sessionId,
        targetScore: targetScore,
        matchType: matchType,
        participantIds: participantIds,
      );
      return right(match);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Match>> getMatch(String matchId) async {
    try {
      final match = await _datasource.getMatch(matchId);
      return right(match);
    } on NotFoundException catch (e) {
      return left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    }
  }

  @override
  Stream<Match?> watchMatch(String matchId) => _datasource.watchMatch(matchId);

  @override
  Stream<List<Match>> watchMatchesForSession(String sessionId) =>
      _datasource.watchMatchesForSession(sessionId);

  @override
  Stream<List<Round>> watchRounds(String matchId) =>
      _datasource.watchRounds(matchId);

  @override
  Future<Either<Failure, void>> addRound({
    required String matchId,
    required String winnerId,
    required int pointsDelta,
    String? notes,
  }) async {
    try {
      final matchResult = await getMatch(matchId);
      return matchResult.fold(
        (f) => left(f),
        (match) {
          if (match.matchType == '2v2') {
            if (!match.participantIds.contains(winnerId)) {
              return left(ValidationFailure('Winner must be one of the teams'));
            }
          } else {
            if (!match.participantIds.contains(winnerId)) {
              return left(ValidationFailure('Winner must be one of the participants'));
            }
          }
          return _addRoundImpl(matchId, winnerId, pointsDelta, notes);
        },
      );
    } catch (_) {
      return left(ServerFailure('Failed to add round'));
    }
  }

  Future<Either<Failure, void>> _addRoundImpl(
    String matchId,
    String winnerId,
    int pointsDelta,
    String? notes,
  ) async {
    try {
      await _datasource.addRound(
        matchId: matchId,
        winnerId: winnerId,
        pointsDelta: pointsDelta,
        notes: notes,
      );
      return right(null);
    } on ValidationException catch (e) {
      return left(ValidationFailure(e.message));
    } on NotFoundException catch (e) {
      return left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> undoLastRound(String matchId) async {
    try {
      await _datasource.undoLastRound(matchId);
      return right(null);
    } on NotFoundException catch (e) {
      return left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> endMatch(String matchId) async {
    try {
      await _datasource.endMatch(matchId);
      return right(null);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    }
  }
}
