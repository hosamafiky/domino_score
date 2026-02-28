import 'package:domino_score/features/sessions/domain/entities/session.dart';
import 'package:domino_score/features/sessions/domain/repositories/sessions_repository.dart';

class GetSessions {
  GetSessions(this._repository);

  final SessionsRepository _repository;

  Stream<List<Session>> call() => _repository.watchSessions();
}
