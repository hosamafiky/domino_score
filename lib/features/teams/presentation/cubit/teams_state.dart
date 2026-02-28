import 'package:equatable/equatable.dart';
import 'package:domino_score/features/teams/domain/entities/team.dart';

abstract class TeamsState extends Equatable {
  const TeamsState();

  @override
  List<Object?> get props => [];
}

class TeamsInitial extends TeamsState {}

class TeamsLoading extends TeamsState {}

class TeamsSuccess extends TeamsState {
  final List<Team> teams;

  const TeamsSuccess(this.teams);

  @override
  List<Object?> get props => [teams];
}

class TeamsEmpty extends TeamsState {}

class TeamsError extends TeamsState {
  final String message;

  const TeamsError(this.message);

  @override
  List<Object?> get props => [message];
}
