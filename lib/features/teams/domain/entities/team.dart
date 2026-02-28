import 'package:equatable/equatable.dart';

class Team extends Equatable {
  final String id;
  final String name;
  final List<String> playerIds; // length 2
  final DateTime createdAt;

  const Team({required this.id, required this.name, required this.playerIds, required this.createdAt});

  @override
  List<Object?> get props => [id, name, playerIds, createdAt];
}
