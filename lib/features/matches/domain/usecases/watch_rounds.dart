import 'package:domino_score/features/matches/domain/entities/round.dart';
import 'package:domino_score/features/matches/domain/repositories/matches_repository.dart';

class WatchRounds {
  WatchRounds(this._repository);

  final MatchesRepository _repository;

  Stream<List<Round>> call(String matchId) => _repository.watchRounds(matchId);
}
