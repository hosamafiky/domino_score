import 'package:domino_score/core/error/exceptions.dart';
import 'package:domino_score/features/players/data/models/player_model.dart';
import 'package:domino_score/firebase/firestore_refs.dart';

class PlayersRemoteDatasource {
  PlayersRemoteDatasource(this._refs);

  final FirestoreRefs _refs;

  Future<List<PlayerModel>> getPlayers() async {
    try {
      final snap = await _refs.players.orderBy('createdAt').get();
      return snap.docs.map((d) => PlayerModel.fromFirestore(d)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<PlayerModel> addPlayer({required String name, required String avatarColor}) async {
    try {
      final ref = _refs.players.doc();
      final model = PlayerModel(id: ref.id, name: name, avatarColor: avatarColor, createdAt: DateTime.now());
      await ref.set(model.toMap());
      return model;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> updatePlayer({required String id, String? name, String? avatarColor}) async {
    try {
      final ref = _refs.player(id);
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (avatarColor != null) data['avatarColor'] = avatarColor;
      if (data.isNotEmpty) await ref.update(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
