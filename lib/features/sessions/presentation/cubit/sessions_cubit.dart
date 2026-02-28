import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domino_score/features/sessions/domain/entities/session.dart';
import 'package:domino_score/features/sessions/domain/usecases/create_session.dart';
import 'package:domino_score/features/sessions/domain/usecases/get_sessions.dart';
import 'package:domino_score/features/sessions/presentation/cubit/sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  SessionsCubit(this._createSession, this._getSessions) : super(SessionsInitial()) {
    _subscription = _getSessions().listen(
      (list) {
        if (list.isEmpty) {
          emit(SessionsEmpty());
        } else {
          emit(SessionsSuccess(list));
        }
      },
      onError: (e) => emit(SessionsError(e.toString())),
    );
  }

  final CreateSession _createSession;
  final GetSessions _getSessions;
  late final StreamSubscription<List<Session>> _subscription;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  Future<bool> createSession({
    required String title,
    required DateTime date,
    required MatchType matchType,
    required List<String> participantIds,
  }) async {
    final result = await _createSession(
      title: title,
      date: date,
      matchType: matchType,
      participantIds: participantIds,
    );
    return result.fold(
      (f) {
        emit(SessionsError(f.message));
        return false;
      },
      (_) => true,
    );
  }
}
