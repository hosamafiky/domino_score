import 'package:equatable/equatable.dart';
import 'package:domino_score/features/matches/domain/entities/match.dart';
import 'package:domino_score/features/matches/domain/entities/round.dart';

abstract class MatchState extends Equatable {
  const MatchState();

  @override
  List<Object?> get props => [];
}

class MatchInitial extends MatchState {}

class MatchLoading extends MatchState {}

class MatchSuccess extends MatchState {
  final Match match;
  final List<Round> rounds;

  const MatchSuccess(this.match, this.rounds);

  @override
  List<Object?> get props => [match, rounds];
}

class MatchError extends MatchState {
  final String message;

  const MatchError(this.message);

  @override
  List<Object?> get props => [message];
}
