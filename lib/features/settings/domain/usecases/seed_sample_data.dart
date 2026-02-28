import 'package:domino_score/features/players/domain/entities/player.dart';
import 'package:domino_score/features/players/domain/usecases/add_player.dart';
import 'package:domino_score/features/players/domain/usecases/get_players.dart';
import 'package:domino_score/features/teams/domain/entities/team.dart';
import 'package:domino_score/features/teams/domain/usecases/add_team.dart';
import 'package:domino_score/features/teams/domain/usecases/get_teams.dart';

class SeedSampleData {
  const SeedSampleData(this._getPlayers, this._getTeams, this._addPlayer, this._addTeam);

  final GetPlayers _getPlayers;
  final GetTeams _getTeams;
  final AddPlayer _addPlayer;
  final AddTeam _addTeam;

  static const _colors = ['#1976D2', '#388E3C', '#F57C00', '#7B1FA2', '#C62828'];

  Future<bool> call() async {
    final playersResult = await _getPlayers();
    final teamsResult = await _getTeams();
    final players = playersResult.fold((_) => <Player>[], (r) => r);
    final teams = teamsResult.fold((_) => <Team>[], (r) => r);
    if (players.isNotEmpty && teams.isNotEmpty) return true;

    if (players.isEmpty) {
      const names = ['أحمد', 'محمد', 'خالد', 'علي'];
      for (var i = 0; i < names.length; i++) {
        await _addPlayer(name: names[i], avatarColor: _colors[i % _colors.length]);
      }
    }
    final currentPlayersResult = await _getPlayers();
    final currentPlayers = currentPlayersResult.fold((_) => <Player>[], (r) => r);
    if (currentPlayers.length >= 2 && teams.isEmpty) {
      await _addTeam(name: 'فريق أ', playerIds: [currentPlayers[0].id, currentPlayers[1].id]);
      if (currentPlayers.length >= 4) {
        await _addTeam(name: 'فريق ب', playerIds: [currentPlayers[2].id, currentPlayers[3].id]);
      }
    }
    return true;
  }
}
