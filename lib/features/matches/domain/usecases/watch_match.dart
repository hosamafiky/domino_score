import 'package:domino_score/features/matches/domain/entities/match.dart';
import 'package:domino_score/features/matches/domain/repositories/matches_repository.dart';

class WatchMatch {
  WatchMatch(this._repository);

  final MatchesRepository _repository;

  Stream<Match?> call(String matchId) => _repository.watchMatch(matchId);
}
