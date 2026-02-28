import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/players/domain/repositories/players_repository.dart';

class UpdatePlayer {
  UpdatePlayer(this._repository);

  final PlayersRepository _repository;

  Future<Either<Failure, void>> call({
    required String id,
    String? name,
    String? avatarColor,
  }) =>
      _repository.updatePlayer(id: id, name: name, avatarColor: avatarColor);
}
