import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/sessions/domain/repositories/sessions_repository.dart';

class EndSession {
  EndSession(this._repository);

  final SessionsRepository _repository;

  Future<Either<Failure, void>> call(String sessionId) =>
      _repository.endSession(sessionId);
}
