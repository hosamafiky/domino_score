import 'package:domino_score/features/matches/domain/entities/match.dart';
import 'package:domino_score/features/matches/domain/repositories/matches_repository.dart';

class WatchMatchesForSession {
  WatchMatchesForSession(this._repository);

  final MatchesRepository _repository;

  Stream<List<Match>> call(String sessionId) =>
      _repository.watchMatchesForSession(sessionId);
}
