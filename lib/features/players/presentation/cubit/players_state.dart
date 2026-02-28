import 'package:domino_score/features/players/domain/entities/player.dart';
import 'package:equatable/equatable.dart';

abstract class PlayersState extends Equatable {
  const PlayersState();

  @override
  List<Object?> get props => [];
}

class PlayersInitial extends PlayersState {}

class PlayersLoading extends PlayersState {}

class PlayersSuccess extends PlayersState {
  final List<Player> players;

  const PlayersSuccess(this.players);

  @override
  List<Object?> get props => [players];
}

class PlayersEmpty extends PlayersState {}

class PlayersError extends PlayersState {
  final String message;

  const PlayersError(this.message);

  @override
  List<Object?> get props => [message];
}
