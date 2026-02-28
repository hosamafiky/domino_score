import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domino_score/features/stats/domain/entities/player_stats.dart';
import 'package:domino_score/features/stats/domain/entities/stats_trends.dart';
import 'package:domino_score/features/stats/domain/entities/team_stats.dart';
import 'package:domino_score/firebase/firestore_refs.dart';

class StatsRemoteDatasource {
  StatsRemoteDatasource(this._refs);

  final FirestoreRefs _refs;

  Future<List<PlayerStats>> getPlayerLeaderboard() async {
    final playersSnap = await _refs.players.get();
    final matchesSnap = await _refs.matches.get();

    final playerNames = <String, String>{};
    final playerColors = <String, String>{};
    for (final d in playersSnap.docs) {
      final data = d.data();
      playerNames[d.id] = data['name'] as String? ?? '';
      playerColors[d.id] = data['avatarColor'] as String? ?? '#1976D2';
    }

    final matchesPlayed = <String, int>{};
    final wins = <String, int>{};
    final sessionIds = <String>{};
    for (final d in matchesSnap.docs) {
      final data = d.data();
      final matchType = data['matchType'] as String? ?? '1v1';
      if (matchType == '2v2') continue;
      final participantIds = (data['participantIds'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
      final winnerId = data['winnerId'] as String?;
      for (final id in participantIds) {
        matchesPlayed[id] = (matchesPlayed[id] ?? 0) + 1;
        if (winnerId == id) wins[id] = (wins[id] ?? 0) + 1;
      }
      final sessionId = data['sessionId'] as String?;
      if (sessionId != null) sessionIds.add(sessionId);
    }

    final sessionsParticipated = <String, int>{};
    for (final sid in sessionIds) {
      final sessionDoc = await _refs.session(sid).get();
      if (!sessionDoc.exists) continue;
      final participantIds = (sessionDoc.data()?['participantIds'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
      for (final id in participantIds) {
        sessionsParticipated[id] = (sessionsParticipated[id] ?? 0) + 1;
      }
    }

    final list = <PlayerStats>[];
    for (final id in playerNames.keys) {
      list.add(
        PlayerStats(
          playerId: id,
          name: playerNames[id]!,
          avatarColor: playerColors[id],
          matchesPlayed: matchesPlayed[id] ?? 0,
          wins: wins[id] ?? 0,
          sessionsParticipated: sessionsParticipated[id] ?? 0,
        ),
      );
    }
    list.sort((a, b) => b.wins.compareTo(a.wins));
    return list;
  }

  Future<List<TeamStats>> getTeamLeaderboard() async {
    final teamsSnap = await _refs.teams.get();
    final matchesSnap = await _refs.matches.get();

    final teamNames = <String, String>{};
    for (final d in teamsSnap.docs) {
      teamNames[d.id] = d.data()['name'] as String? ?? '';
    }

    final matchesPlayed = <String, int>{};
    final wins = <String, int>{};
    final sessionIds = <String>{};
    for (final d in matchesSnap.docs) {
      final data = d.data();
      if ((data['matchType'] as String? ?? '') != '2v2') continue;
      final participantIds = (data['participantIds'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
      final winnerId = data['winnerId'] as String?;
      for (final id in participantIds) {
        matchesPlayed[id] = (matchesPlayed[id] ?? 0) + 1;
        if (winnerId == id) wins[id] = (wins[id] ?? 0) + 1;
      }
      final sessionId = data['sessionId'] as String?;
      if (sessionId != null) sessionIds.add(sessionId);
    }

    final sessionsParticipated = <String, int>{};
    for (final sid in sessionIds) {
      final sessionDoc = await _refs.session(sid).get();
      if (!sessionDoc.exists) continue;
      final participantIds = (sessionDoc.data()?['participantIds'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
      for (final id in participantIds) {
        sessionsParticipated[id] = (sessionsParticipated[id] ?? 0) + 1;
      }
    }

    final list = <TeamStats>[];
    for (final id in teamNames.keys) {
      list.add(
        TeamStats(
          teamId: id,
          name: teamNames[id]!,
          matchesPlayed: matchesPlayed[id] ?? 0,
          wins: wins[id] ?? 0,
          sessionsParticipated: sessionsParticipated[id] ?? 0,
        ),
      );
    }
    list.sort((a, b) => b.wins.compareTo(a.wins));
    return list;
  }

  Future<StatsTrends> getTrends() async {
    final matchesSnap = await _refs.matches.get();
    final distribution = <String, int>{'1v1': 0, 'triple': 0, '2v2': 0};
    final winsByDate = <DateTime, int>{};
    for (final d in matchesSnap.docs) {
      final data = d.data();
      final matchType = data['matchType'] as String? ?? '1v1';
      distribution[matchType] = (distribution[matchType] ?? 0) + 1;
      final endedAt = data['endedAt'];
      if (endedAt != null && data['winnerId'] != null) {
        final date = endedAt is Timestamp ? endedAt.toDate() : (endedAt as DateTime);
        final day = DateTime(date.year, date.month, date.day);
        winsByDate[day] = (winsByDate[day] ?? 0) + 1;
      }
    }
    final winsOverTime = winsByDate.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    return StatsTrends(matchTypeDistribution: distribution, winsOverTime: winsOverTime);
  }
}
