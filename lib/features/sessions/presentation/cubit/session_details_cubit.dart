import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domino_score/features/sessions/domain/entities/session.dart';
import 'package:domino_score/features/sessions/domain/usecases/get_session.dart';
import 'package:domino_score/features/sessions/domain/usecases/end_session.dart';
import 'package:domino_score/features/matches/domain/usecases/watch_matches_for_session.dart';
import 'package:domino_score/features/sessions/presentation/cubit/session_details_state.dart';
import 'package:domino_score/features/matches/domain/usecases/add_match.dart';
import 'package:domino_score/features/matches/domain/entities/match.dart' as app;

class SessionDetailsCubit extends Cubit<SessionDetailsState> {
  SessionDetailsCubit(this._getSession, this._endSession, this._addMatch, this._watchMatches)
      : super(SessionDetailsInitial());

  final GetSession _getSession;
  final EndSession _endSession;
  final AddMatch _addMatch;
  final WatchMatchesForSession _watchMatches;
  StreamSubscription<List<app.Match>>? _matchesSub;
  Session? _currentSession;

  Future<void> loadSession(String sessionId) async {
    emit(SessionDetailsLoading());
    final result = await _getSession(sessionId);
    await result.fold(
      (f) async => emit(SessionDetailsError(f.message)),
      (session) async {
        _currentSession = session;
        _matchesSub?.cancel();
        _matchesSub = _watchMatches(sessionId).listen(
          (matches) {
            if (_currentSession != null) {
              emit(SessionDetailsSuccess(_currentSession!, matches));
            }
          },
          onError: (e) => emit(SessionDetailsError(e.toString())),
        );
        emit(SessionDetailsSuccess(session, []));
      },
    );
  }

  @override
  Future<void> close() {
    _matchesSub?.cancel();
    return super.close();
  }

  Future<bool> endSession(String sessionId) async {
    final result = await _endSession(sessionId);
    return result.fold(
      (f) => false,
      (_) {
        loadSession(sessionId);
        return true;
      },
    );
  }

  Future<bool> addMatch(String sessionId, int targetScore) async {
    final state = this.state;
    if (state is! SessionDetailsSuccess) return false;
    final result = await _addMatch(
      sessionId: sessionId,
      targetScore: targetScore,
      matchType: state.session.matchType.value,
      participantIds: state.session.participantIds,
    );
    return result.fold(
      (f) => false,
      (_) {
        loadSession(sessionId);
        return true;
      },
    );
  }
}
