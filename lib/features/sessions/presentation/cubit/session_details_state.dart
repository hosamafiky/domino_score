import 'package:equatable/equatable.dart';
import 'package:domino_score/features/sessions/domain/entities/session.dart';
import 'package:domino_score/features/matches/domain/entities/match.dart' as app;

abstract class SessionDetailsState extends Equatable {
  const SessionDetailsState();

  @override
  List<Object?> get props => [];
}

class SessionDetailsInitial extends SessionDetailsState {}

class SessionDetailsLoading extends SessionDetailsState {}

class SessionDetailsSuccess extends SessionDetailsState {
  final Session session;
  final List<app.Match> matches;

  const SessionDetailsSuccess(this.session, this.matches);

  @override
  List<Object?> get props => [session, matches];
}

class SessionDetailsError extends SessionDetailsState {
  final String message;

  const SessionDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
