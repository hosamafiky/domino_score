import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/sessions/domain/entities/session.dart';
import 'package:domino_score/features/sessions/domain/repositories/sessions_repository.dart';

class GetSession {
  GetSession(this._repository);

  final SessionsRepository _repository;

  Future<Either<Failure, Session>> call(String id) => _repository.getSession(id);
}
