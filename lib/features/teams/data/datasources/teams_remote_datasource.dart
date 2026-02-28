import 'package:domino_score/core/error/exceptions.dart';
import 'package:domino_score/features/teams/data/models/team_model.dart';
import 'package:domino_score/firebase/firestore_refs.dart';

class TeamsRemoteDatasource {
  TeamsRemoteDatasource(this._refs);

  final FirestoreRefs _refs;

  Future<List<TeamModel>> getTeams() async {
    try {
      final snap = await _refs.teams.orderBy('createdAt').get();
      return snap.docs.map((d) => TeamModel.fromFirestore(d)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<TeamModel> addTeam({required String name, required List<String> playerIds}) async {
    if (playerIds.length != 2) {
      throw ValidationException('Team must have exactly 2 players');
    }
    try {
      final ref = _refs.teams.doc();
      final model = TeamModel(id: ref.id, name: name, playerIds: playerIds, createdAt: DateTime.now());
      await ref.set(model.toMap());
      return model;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
