import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domino_score/core/error/exceptions.dart';
import 'package:domino_score/features/matches/data/models/match_model.dart';
import 'package:domino_score/features/matches/data/models/round_model.dart';
import 'package:domino_score/features/matches/domain/entities/match.dart';
import 'package:domino_score/firebase/firestore_refs.dart';

class MatchesRemoteDatasource {
  MatchesRemoteDatasource(this._refs);

  final FirestoreRefs _refs;

  Future<MatchModel> addMatch({required String sessionId, required int targetScore, required String matchType, required List<String> participantIds}) async {
    try {
      final ref = _refs.matches.doc();
      final scores = <String, int>{};
      for (final id in participantIds) {
        scores[id] = 0;
      }
      final model = MatchModel(
        id: ref.id,
        sessionId: sessionId,
        matchType: matchType,
        participantIds: participantIds,
        targetScore: targetScore,
        status: 'active',
        winnerId: null,
        scores: scores,
        createdAt: DateTime.now(),
        endedAt: null,
      );
      await ref.set(model.toMap());
      return model;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<MatchModel> getMatch(String matchId) async {
    final doc = await _refs.match(matchId).get();
    if (!doc.exists) throw NotFoundException('Match not found');
    return MatchModel.fromFirestore(doc);
  }

  Stream<Match?> watchMatch(String matchId) {
    return _refs.match(matchId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return MatchModel.fromFirestore(doc);
    });
  }

  Stream<List<MatchModel>> watchMatchesForSession(String sessionId) {
    return _refs.matches
        .where('sessionId', isEqualTo: sessionId)
        .orderBy('createdAt')
        .snapshots()
        .map((snap) => snap.docs.map((d) => MatchModel.fromFirestore(d)).toList());
  }

  Stream<List<RoundModel>> watchRounds(String matchId) {
    return _refs.rounds
        .where('matchId', isEqualTo: matchId)
        .orderBy('index')
        .snapshots()
        .map((snap) => snap.docs.map((d) => RoundModel.fromFirestore(d)).toList());
  }

  Future<void> addRound({required String matchId, required String winnerId, required int pointsDelta, String? notes}) async {
    final roundsSnap = await _refs.rounds.where('matchId', isEqualTo: matchId).orderBy('index', descending: true).limit(1).get();
    final nextIndex = roundsSnap.docs.isEmpty ? 0 : (RoundModel.fromFirestore(roundsSnap.docs.first).index + 1);

    await FirebaseFirestore.instance.runTransaction((tx) async {
      final matchRef = _refs.match(matchId);
      final matchDoc = await tx.get(matchRef);
      if (!matchDoc.exists) throw NotFoundException('Match not found');
      final match = MatchModel.fromFirestore(matchDoc);
      if (match.status == 'ended') throw ValidationException('Match already ended');

      final roundRef = _refs.rounds.doc();
      tx.set(roundRef, {
        'matchId': matchId,
        'index': nextIndex,
        'winnerId': winnerId,
        'pointsDelta': pointsDelta,
        'notes': ?notes,
        'createdAt': FieldValue.serverTimestamp(),
      });

      final newScores = Map<String, int>.from(match.scores);
      newScores[winnerId] = (newScores[winnerId] ?? 0) + pointsDelta;
      final reachedTarget = newScores.values.any((s) => s >= match.targetScore);
      tx.update(matchRef, {
        'scores': newScores,
        if (reachedTarget) 'status': 'ended',
        if (reachedTarget) 'winnerId': winnerId,
        if (reachedTarget) 'endedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> undoLastRound(String matchId) async {
    final roundsSnap = await _refs.rounds.where('matchId', isEqualTo: matchId).orderBy('index', descending: true).limit(1).get();
    if (roundsSnap.docs.isEmpty) throw NotFoundException('No rounds to undo');
    final lastRoundDoc = roundsSnap.docs.first;
    final lastRound = RoundModel.fromFirestore(lastRoundDoc);

    await FirebaseFirestore.instance.runTransaction((tx) async {
      final matchRef = _refs.match(matchId);
      tx.delete(lastRoundDoc.reference);
      final matchDoc = await tx.get(matchRef);
      final match = MatchModel.fromFirestore(matchDoc);
      final newScores = Map<String, int>.from(match.scores);
      newScores[lastRound.winnerId] = (newScores[lastRound.winnerId] ?? 0) - lastRound.pointsDelta;
      if (newScores[lastRound.winnerId]! < 0) newScores[lastRound.winnerId] = 0;

      final wasEnded = match.status == 'ended';
      tx.update(matchRef, {
        'scores': newScores,
        if (wasEnded) 'status': 'active',
        if (wasEnded) 'winnerId': FieldValue.delete(),
        if (wasEnded) 'endedAt': FieldValue.delete(),
      });
    });
  }

  Future<void> endMatch(String matchId) async {
    try {
      await _refs.match(matchId).update({'status': 'ended', 'endedAt': FieldValue.serverTimestamp()});
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
