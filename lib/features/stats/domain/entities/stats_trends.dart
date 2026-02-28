import 'package:equatable/equatable.dart';

class StatsTrends extends Equatable {
  final Map<String, int> matchTypeDistribution; // "1v1", "triple", "2v2" -> count
  final List<MapEntry<DateTime, int>> winsOverTime; // date -> wins count (simplified)

  const StatsTrends({
    this.matchTypeDistribution = const {},
    this.winsOverTime = const [],
  });

  @override
  List<Object?> get props => [matchTypeDistribution, winsOverTime];
}
