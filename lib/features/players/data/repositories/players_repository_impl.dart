import 'package:dartz/dartz.dart';
import 'package:domino_score/core/error/exceptions.dart';
import 'package:domino_score/core/error/failures.dart';
import 'package:domino_score/features/players/data/datasources/players_remote_datasource.dart';
import 'package:domino_score/features/players/domain/entities/player.dart';
import 'package:domino_score/features/players/domain/repositories/players_repository.dart';

class PlayersRepositoryImpl implements PlayersRepository {
  PlayersRepositoryImpl(this._datasource);

  final PlayersRemoteDatasource _datasource;

  @override
  Future<Either<Failure, List<Player>>> getPlayers() async {
    try {
      final list = await _datasource.getPlayers();
      return right(list);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Player>> addPlayer({required String name, required String avatarColor}) async {
    try {
      final player = await _datasource.addPlayer(name: name, avatarColor: avatarColor);
      return right(player);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updatePlayer({required String id, String? name, String? avatarColor}) async {
    try {
      await _datasource.updatePlayer(id: id, name: name, avatarColor: avatarColor);
      return right(null);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    }
  }
}
