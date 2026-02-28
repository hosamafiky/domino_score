import 'package:equatable/equatable.dart';
import 'package:domino_score/features/sessions/domain/entities/session.dart';

abstract class SessionsState extends Equatable {
  const SessionsState();

  @override
  List<Object?> get props => [];
}

class SessionsInitial extends SessionsState {}

class SessionsLoading extends SessionsState {}

class SessionsSuccess extends SessionsState {
  final List<Session> sessions;

  const SessionsSuccess(this.sessions);

  @override
  List<Object?> get props => [sessions];
}

class SessionsEmpty extends SessionsState {}

class SessionsError extends SessionsState {
  final String message;

  const SessionsError(this.message);

  @override
  List<Object?> get props => [message];
}
