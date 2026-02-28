import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/exceptions.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/sessions/domain/entities/session.dart';
import 'package:domino_score/features/sessions/domain/repositories/sessions_repository.dart';
import 'package:domino_score/features/sessions/data/datasources/sessions_remote_datasource.dart';

class SessionsRepositoryImpl implements SessionsRepository {
  SessionsRepositoryImpl(this._datasource);

  final SessionsRemoteDatasource _datasource;

  @override
  Future<Either<Failure, Session>> createSession({
    required String title,
    required DateTime date,
    required MatchType matchType,
    required List<String> participantIds,
  }) async {
    try {
      final session = await _datasource.createSession(
        title: title,
        date: date,
        matchType: matchType,
        participantIds: participantIds,
      );
      return right(session);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    }
  }

  @override
  Stream<List<Session>> watchSessions() =>
      _datasource.watchSessions();

  @override
  Future<Either<Failure, Session>> getSession(String id) async {
    try {
      final session = await _datasource.getSession(id);
      return right(session);
    } on NotFoundException catch (e) {
      return left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> endSession(String sessionId) async {
    try {
      await _datasource.endSession(sessionId);
      return right(null);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    }
  }
}
