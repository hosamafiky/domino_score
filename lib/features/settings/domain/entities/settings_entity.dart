import 'package:equatable/equatable.dart';

class SettingsEntity extends Equatable {
  final int targetScore1v1;
  final int targetScoreTriple;
  final int targetScore2v2;
  final bool notificationsMatchEnd;
  final bool notificationsSessionReminders;
  final DateTime? updatedAt;

  const SettingsEntity({
    this.targetScore1v1 = 100,
    this.targetScoreTriple = 100,
    this.targetScore2v2 = 100,
    this.notificationsMatchEnd = true,
    this.notificationsSessionReminders = false,
    this.updatedAt,
  });

  @override
  List<Object?> get props =>
      [targetScore1v1, targetScoreTriple, targetScore2v2, notificationsMatchEnd, notificationsSessionReminders, updatedAt];
}
