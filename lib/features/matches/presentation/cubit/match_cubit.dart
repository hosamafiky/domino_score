import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domino_score/features/matches/domain/entities/match.dart';
import 'package:domino_score/features/matches/domain/entities/round.dart';
import 'package:domino_score/features/matches/domain/usecases/get_match.dart';
import 'package:domino_score/features/matches/domain/usecases/watch_match.dart';
import 'package:domino_score/features/matches/domain/usecases/watch_rounds.dart';
import 'package:domino_score/features/matches/domain/usecases/add_round.dart';
import 'package:domino_score/features/matches/domain/usecases/undo_last_round.dart';
import 'package:domino_score/features/matches/domain/usecases/end_match.dart';
import 'package:domino_score/features/matches/presentation/cubit/match_state.dart';

class MatchCubit extends Cubit<MatchState> {
  MatchCubit(
    this._getMatch,
    this._watchMatch,
    this._watchRounds,
    this._addRound,
    this._undoLastRound,
    this._endMatch,
  ) : super(MatchInitial());

  final GetMatch _getMatch;
  final WatchMatch _watchMatch;
  final WatchRounds _watchRounds;
  final AddRound _addRound;
  final UndoLastRound _undoLastRound;
  final EndMatch _endMatch;
  StreamSubscription<Match?>? _matchSub;
  StreamSubscription<List<Round>>? _roundsSub;

  void loadMatch(String matchId) {
    emit(MatchLoading());
    _matchSub?.cancel();
    _roundsSub?.cancel();
    _matchSub = _watchMatch(matchId).listen(
      (match) async {
        if (match == null) {
          final result = await _getMatch(matchId);
          result.fold(
            (f) => emit(MatchError(f.message)),
            (_) {},
          );
          return;
        }
        _roundsSub?.cancel();
        _roundsSub = _watchRounds(matchId).listen(
          (rounds) => emit(MatchSuccess(match, rounds)),
          onError: (e) => emit(MatchError(e.toString())),
        );
      },
      onError: (e) => emit(MatchError(e.toString())),
    );
  }

  @override
  Future<void> close() {
    _matchSub?.cancel();
    _roundsSub?.cancel();
    return super.close();
  }

  Future<bool> addRound({
    required String matchId,
    required String winnerId,
    required int pointsDelta,
    String? notes,
  }) async {
    final result = await _addRound(
      matchId: matchId,
      winnerId: winnerId,
      pointsDelta: pointsDelta,
      notes: notes,
    );
    return result.fold(
      (f) => false,
      (_) => true,
    );
  }

  Future<bool> undoLastRound(String matchId) async {
    final result = await _undoLastRound(matchId);
    return result.fold(
      (f) => false,
      (_) => true,
    );
  }

  Future<bool> endMatch(String matchId) async {
    final result = await _endMatch(matchId);
    return result.fold(
      (f) => false,
      (_) => true,
    );
  }
}
