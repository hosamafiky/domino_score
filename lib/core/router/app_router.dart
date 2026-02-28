import 'package:domino_score/core/localization/app_localizations.dart';
import 'package:domino_score/features/home/presentation/pages/home_page.dart';
import 'package:domino_score/features/matches/presentation/pages/congratulations_page.dart';
import 'package:domino_score/features/matches/presentation/pages/match_page.dart';
import 'package:domino_score/features/sessions/presentation/pages/create_session_page.dart';
import 'package:domino_score/features/sessions/presentation/pages/session_details_page.dart';
import 'package:domino_score/features/sessions/presentation/pages/sessions_list_page.dart';
import 'package:domino_score/features/settings/presentation/pages/settings_page.dart';
import 'package:domino_score/features/stats/presentation/pages/stats_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => _MainShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => const NoTransitionPage(child: HomePage()),
          ),
          GoRoute(
            path: '/sessions',
            pageBuilder: (context, state) => const NoTransitionPage(child: SessionsListPage()),
          ),
          GoRoute(
            path: '/stats',
            pageBuilder: (context, state) => const NoTransitionPage(child: StatsPage()),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(child: SettingsPage()),
          ),
        ],
      ),
      GoRoute(path: '/sessions/create', parentNavigatorKey: _rootNavigatorKey, builder: (context, state) => const CreateSessionPage()),
      GoRoute(
        path: '/sessions/:sessionId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final sessionId = state.pathParameters['sessionId']!;
          return SessionDetailsPage(sessionId: sessionId);
        },
      ),
      GoRoute(
        path: '/sessions/:sessionId/match/:matchId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final sessionId = state.pathParameters['sessionId']!;
          final matchId = state.pathParameters['matchId']!;
          return MatchPage(sessionId: sessionId, matchId: matchId);
        },
      ),
      GoRoute(
        path: '/congratulations',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, String>?;
          return CongratulationsPage(winnerName: extra?['winnerName'] ?? '', sessionTitle: extra?['sessionTitle'] ?? '', sessionId: extra?['sessionId'] ?? '');
        },
      ),
    ],
  );
}

class _MainShell extends StatelessWidget {
  const _MainShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex(context),
        onDestinationSelected: (i) => _onTap(context, i),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home), label: l10n.tabHome),
          NavigationDestination(icon: const Icon(Icons.event_note), label: l10n.tabSessions),
          NavigationDestination(icon: const Icon(Icons.bar_chart), label: l10n.tabStats),
          NavigationDestination(icon: const Icon(Icons.settings), label: l10n.tabSettings),
        ],
      ),
    );
  }

  int _selectedIndex(BuildContext context) {
    final loc = GoRouterState.of(context).uri.path;
    if (loc.startsWith('/sessions') && loc == '/sessions') return 1;
    if (loc.startsWith('/stats') && loc == '/stats') return 2;
    if (loc.startsWith('/settings') && loc == '/settings') return 3;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/sessions');
        break;
      case 2:
        context.go('/stats');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }
}
