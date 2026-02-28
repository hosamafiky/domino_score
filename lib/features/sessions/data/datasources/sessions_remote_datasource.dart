import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domino_score/core/error/exceptions.dart';
import 'package:domino_score/features/sessions/data/models/session_model.dart';
import 'package:domino_score/features/sessions/domain/entities/session.dart';
import 'package:domino_score/firebase/firestore_refs.dart';

class SessionsRemoteDatasource {
  SessionsRemoteDatasource(this._refs);

  final FirestoreRefs _refs;

  Future<SessionModel> createSession({
    required String title,
    required DateTime date,
    required MatchType matchType,
    required List<String> participantIds,
  }) async {
    try {
      final ref = _refs.sessions.doc();
      final model = SessionModel(
        id: ref.id,
        title: title,
        date: date,
        matchType: matchType,
        participantIds: participantIds,
        status: 'active',
        createdAt: DateTime.now(),
        endedAt: null,
      );
      await ref.set(model.toMap());
      return model;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Stream<List<SessionModel>> watchSessions() {
    return _refs.sessions
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => SessionModel.fromFirestore(d)).toList());
  }

  Future<SessionModel> getSession(String id) async {
    try {
      final doc = await _refs.session(id).get();
      if (!doc.exists) throw NotFoundException('Session not found');
      return SessionModel.fromFirestore(doc);
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> endSession(String sessionId) async {
    try {
      await _refs.session(sessionId).update({
        'status': 'ended',
        'endedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
