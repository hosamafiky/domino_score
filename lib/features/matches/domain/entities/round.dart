import 'package:equatable/equatable.dart';

class Round extends Equatable {
  final String id;
  final String matchId;
  final int index;
  final String winnerId;
  final int pointsDelta;
  final String? notes;
  final DateTime createdAt;

  const Round({
    required this.id,
    required this.matchId,
    required this.index,
    required this.winnerId,
    required this.pointsDelta,
    this.notes,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, matchId, index, winnerId, pointsDelta, notes, createdAt];
}
