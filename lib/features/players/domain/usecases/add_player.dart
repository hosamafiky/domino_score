import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/players/domain/entities/player.dart';
import 'package:domino_score/features/players/domain/repositories/players_repository.dart';

class AddPlayer {
  AddPlayer(this._repository);

  final PlayersRepository _repository;

  Future<Either<Failure, Player>> call({
    required String name,
    required String avatarColor,
  }) =>
      _repository.addPlayer(name: name, avatarColor: avatarColor);
}
