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

class SessionsListPage extends StatelessWidget {
  const SessionsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SessionsCubit>(),
      child: const _SessionsListView(),
    );
  }
}

class _SessionsListView extends StatelessWidget {
  const _SessionsListView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Directionality(
      textDirection: l10n.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.sessionsTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => context.push('/sessions/create'),
            ),
          ],
        ),
        body: BlocBuilder<SessionsCubit, SessionsState>(
          builder: (context, state) {
            if (state is SessionsInitial || state is SessionsLoading) {
              return const LoadingWidget();
            }
            if (state is SessionsError) {
              return ErrorView(message: state.message);
            }
            if (state is SessionsEmpty) {
              return EmptyView(
                message: l10n.empty,
                action: FilledButton.icon(
                  onPressed: () => context.push('/sessions/create'),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.createSession),
                ),
              );
            }
            if (state is SessionsSuccess) {
              final sessions = state.sessions;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: sessions.length,
                itemBuilder: (context, i) {
                  final s = sessions[i];
                  return Card(
                    child: ListTile(
                      title: Text(s.title),
                      subtitle: Text('${s.matchType.value} • ${s.status} • ${s.date.toString().substring(0, 10)}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/sessions/${s.id}'),
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
