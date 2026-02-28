import 'package:domino_score/features/players/domain/usecases/add_player.dart';
import 'package:domino_score/features/players/domain/usecases/get_players.dart';
import 'package:domino_score/features/players/domain/usecases/update_player.dart';
import 'package:domino_score/features/players/presentation/cubit/players_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayersCubit extends Cubit<PlayersState> {
  PlayersCubit(this._getPlayers, this._addPlayer, this._updatePlayer) : super(PlayersInitial());

  final GetPlayers _getPlayers;
  final AddPlayer _addPlayer;
  final UpdatePlayer _updatePlayer;

  Future<void> loadPlayers() async {
    emit(PlayersLoading());
    final result = await _getPlayers();
    result.fold((f) => emit(PlayersError(f.message)), (list) {
      if (list.isEmpty) {
        emit(PlayersEmpty());
      } else {
        emit(PlayersSuccess(list));
      }
    });
  }

  Future<bool> addPlayer({required String name, required String avatarColor}) async {
    final result = await _addPlayer(name: name, avatarColor: avatarColor);
    return result.fold(
      (f) {
        emit(PlayersError(f.message));
        return false;
      },
      (_) {
        loadPlayers();
        return true;
      },
    );
  }

  Future<bool> updatePlayer({required String id, String? name, String? avatarColor}) async {
    final result = await _updatePlayer(id: id, name: name, avatarColor: avatarColor);
    return result.fold(
      (f) {
        emit(PlayersError(f.message));
        return false;
      },
      (_) {
        loadPlayers();
        return true;
      },
    );
  }
}
