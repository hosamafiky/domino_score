import 'package:equatable/equatable.dart';

enum MatchType { oneVOne, triple, twoVTwo }

extension MatchTypeX on MatchType {
  String get value {
    switch (this) {
      case MatchType.oneVOne:
        return '1v1';
      case MatchType.triple:
        return 'triple';
      case MatchType.twoVTwo:
        return '2v2';
    }
  }

  static MatchType fromString(String s) {
    switch (s) {
      case '1v1':
        return MatchType.oneVOne;
      case 'triple':
        return MatchType.triple;
      case '2v2':
        return MatchType.twoVTwo;
      default:
        return MatchType.oneVOne;
    }
  }
}

class Session extends Equatable {
  final String id;
  final String title;
  final DateTime date;
  final MatchType matchType;
  final List<String> participantIds; // playerIds or teamIds
  final String status; // "active" | "ended"
  final DateTime createdAt;
  final DateTime? endedAt;

  const Session({
    required this.id,
    required this.title,
    required this.date,
    required this.matchType,
    required this.participantIds,
    required this.status,
    required this.createdAt,
    this.endedAt,
  });

  bool get isActive => status == 'active';

  @override
  List<Object?> get props => [id, title, date, matchType, participantIds, status, createdAt, endedAt];
}
