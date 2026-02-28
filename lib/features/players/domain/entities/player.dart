import 'package:equatable/equatable.dart';

class Player extends Equatable {
  final String id;
  final String name;
  final String avatarColor;
  final DateTime createdAt;

  const Player({required this.id, required this.name, required this.avatarColor, required this.createdAt});

  @override
  List<Object?> get props => [id, name, avatarColor, createdAt];
}
