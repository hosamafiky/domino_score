import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/players/domain/entities/player.dart';
import 'package:domino_score/features/players/domain/repositories/players_repository.dart';

class GetPlayers {
  GetPlayers(this._repository);

  final PlayersRepository _repository;

  Future<Either<Failure, List<Player>>> call() => _repository.getPlayers();
}
