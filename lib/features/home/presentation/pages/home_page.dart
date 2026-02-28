import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domino_score/core/localization/app_localizations.dart';
import 'package:domino_score/core/widgets/loading_widget.dart';
import 'package:domino_score/core/widgets/error_view.dart';
import 'package:domino_score/core/widgets/empty_view.dart';
import 'package:domino_score/core/di/injection.dart';
import 'package:domino_score/features/sessions/presentation/cubit/sessions_cubit.dart';
import 'package:domino_score/features/sessions/presentation/cubit/sessions_state.dart';
import 'package:domino_score/features/sessions/domain/entities/session.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SessionsCubit>(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Directionality(
      textDirection: l10n.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.homeTitle)),
        body: BlocBuilder<SessionsCubit, SessionsState>(
          builder: (context, state) {
            if (state is SessionsLoading) return const LoadingWidget();
            if (state is SessionsError) {
              return ErrorView(message: state.message);
            }
            if (state is SessionsEmpty) {
              return EmptyView(
                message: l10n.empty,
                action: FilledButton.icon(
                  onPressed: () => context.push('/sessions/create'),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.newSession),
                ),
              );
            }
            if (state is SessionsSuccess) {
              final sessions = state.sessions.take(5).toList();
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  FilledButton.icon(
                    onPressed: () => context.push('/sessions/create'),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.newSession),
                  ),
                  const SizedBox(height: 24),
                  Text(l10n.recentSessions, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...sessions.map((s) => Card(
                    child: ListTile(
                      title: Text(s.title),
                      subtitle: Text('${s.matchType.value} • ${s.status}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/sessions/${s.id}'),
                    ),
                  )),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
