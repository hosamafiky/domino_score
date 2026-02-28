import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/players/domain/entities/player.dart';

abstract class PlayersRepository {
  Future<Either<Failure, List<Player>>> getPlayers();
  Future<Either<Failure, Player>> addPlayer({required String name, required String avatarColor});
  Future<Either<Failure, void>> updatePlayer({required String id, String? name, String? avatarColor});
}
