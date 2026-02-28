import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/sessions/domain/entities/session.dart';
import 'package:domino_score/features/sessions/domain/repositories/sessions_repository.dart';

class CreateSession {
  CreateSession(this._repository);

  final SessionsRepository _repository;

  Future<Either<Failure, Session>> call({
    required String title,
    required DateTime date,
    required MatchType matchType,
    required List<String> participantIds,
  }) =>
      _repository.createSession(
        title: title,
        date: date,
        matchType: matchType,
        participantIds: participantIds,
      );
}
