import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/sessions/domain/entities/session.dart';

abstract class SessionsRepository {
  Future<Either<Failure, Session>> createSession({
    required String title,
    required DateTime date,
    required MatchType matchType,
    required List<String> participantIds,
  });
  Stream<List<Session>> watchSessions();
  Future<Either<Failure, Session>> getSession(String id);
  Future<Either<Failure, void>> endSession(String sessionId);
}
