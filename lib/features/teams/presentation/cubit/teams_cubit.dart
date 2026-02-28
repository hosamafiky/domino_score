import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domino_score/features/teams/domain/usecases/get_teams.dart';
import 'package:domino_score/features/teams/domain/usecases/add_team.dart';
import 'package:domino_score/features/teams/presentation/cubit/teams_state.dart';

class TeamsCubit extends Cubit<TeamsState> {
  TeamsCubit(this._getTeams, this._addTeam) : super(TeamsInitial());

  final GetTeams _getTeams;
  final AddTeam _addTeam;

  Future<void> loadTeams() async {
    emit(TeamsLoading());
    final result = await _getTeams();
    result.fold(
      (f) => emit(TeamsError(f.message)),
      (list) {
        if (list.isEmpty) {
          emit(TeamsEmpty());
        } else {
          emit(TeamsSuccess(list));
        }
      },
    );
  }

  Future<bool> addTeam({
    required String name,
    required List<String> playerIds,
  }) async {
    final result = await _addTeam(name: name, playerIds: playerIds);
    return result.fold(
      (f) {
        emit(TeamsError(f.message));
        return false;
      },
      (_) {
        loadTeams();
        return true;
      },
    );
  }
}
