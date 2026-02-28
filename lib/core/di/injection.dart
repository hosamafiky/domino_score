import 'package:domino_score/features/matches/data/datasources/matches_remote_datasource.dart';
import 'package:domino_score/features/matches/data/repositories/matches_repository_impl.dart';
import 'package:domino_score/features/matches/domain/repositories/matches_repository.dart';
import 'package:domino_score/features/matches/domain/usecases/add_match.dart';
import 'package:domino_score/features/matches/domain/usecases/add_round.dart';
import 'package:domino_score/features/matches/domain/usecases/end_match.dart';
import 'package:domino_score/features/matches/domain/usecases/get_match.dart';
import 'package:domino_score/features/matches/domain/usecases/undo_last_round.dart';
import 'package:domino_score/features/matches/domain/usecases/watch_match.dart';
import 'package:domino_score/features/matches/domain/usecases/watch_matches_for_session.dart';
import 'package:domino_score/features/matches/domain/usecases/watch_rounds.dart';
import 'package:domino_score/features/matches/presentation/cubit/match_cubit.dart';
import 'package:domino_score/features/players/data/datasources/players_remote_datasource.dart';
import 'package:domino_score/features/players/data/repositories/players_repository_impl.dart';
import 'package:domino_score/features/players/domain/repositories/players_repository.dart';
import 'package:domino_score/features/players/domain/usecases/add_player.dart';
import 'package:domino_score/features/players/domain/usecases/get_players.dart';
import 'package:domino_score/features/players/domain/usecases/update_player.dart';
import 'package:domino_score/features/players/presentation/cubit/players_cubit.dart';
import 'package:domino_score/features/sessions/data/datasources/sessions_remote_datasource.dart';
import 'package:domino_score/features/sessions/data/repositories/sessions_repository_impl.dart';
import 'package:domino_score/features/sessions/domain/repositories/sessions_repository.dart';
import 'package:domino_score/features/sessions/domain/usecases/create_session.dart';
import 'package:domino_score/features/sessions/domain/usecases/end_session.dart';
import 'package:domino_score/features/sessions/domain/usecases/get_session.dart';
import 'package:domino_score/features/sessions/domain/usecases/get_sessions.dart';
import 'package:domino_score/features/sessions/presentation/cubit/session_details_cubit.dart';
import 'package:domino_score/features/sessions/presentation/cubit/sessions_cubit.dart';
import 'package:domino_score/features/settings/data/datasources/settings_remote_datasource.dart';
import 'package:domino_score/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:domino_score/features/settings/domain/repositories/settings_repository.dart';
import 'package:domino_score/features/settings/domain/usecases/get_settings.dart';
import 'package:domino_score/features/settings/domain/usecases/seed_sample_data.dart';
import 'package:domino_score/features/settings/domain/usecases/update_settings.dart';
import 'package:domino_score/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:domino_score/features/stats/data/datasources/stats_remote_datasource.dart';
import 'package:domino_score/features/stats/data/repositories/stats_repository_impl.dart';
import 'package:domino_score/features/stats/domain/repositories/stats_repository.dart';
import 'package:domino_score/features/stats/domain/usecases/compute_stats.dart';
import 'package:domino_score/features/stats/presentation/cubit/stats_cubit.dart';
import 'package:domino_score/features/teams/data/datasources/teams_remote_datasource.dart';
import 'package:domino_score/features/teams/data/repositories/teams_repository_impl.dart';
import 'package:domino_score/features/teams/domain/repositories/teams_repository.dart';
import 'package:domino_score/features/teams/domain/usecases/add_team.dart';
import 'package:domino_score/features/teams/domain/usecases/get_teams.dart';
import 'package:domino_score/features/teams/presentation/cubit/teams_cubit.dart';
import 'package:domino_score/core/locale/locale_cubit.dart';
import 'package:domino_score/firebase/firebase_init.dart';
import 'package:domino_score/firebase/firestore_refs.dart';
import 'package:domino_score/firebase/messaging_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);
  sl.registerLazySingleton<LocaleCubit>(() => LocaleCubit(sl()));

  await initFirebase();
  sl.registerLazySingleton<MessagingService>(() => MessagingService(sl()));

  _initFirestoreRefs();
  _initPlayers();
  _initTeams();
  _initSessions();
  _initMatches();
  _initSettings();
  _initStats();
}

void _initFirestoreRefs() {
  sl.registerLazySingleton<FirestoreRefs>(() => FirestoreRefs());
}

void _initPlayers() {
  sl.registerLazySingleton<PlayersRemoteDatasource>(() => PlayersRemoteDatasource(sl()));
  sl.registerLazySingleton<PlayersRepository>(() => PlayersRepositoryImpl(sl()));
  sl.registerLazySingleton<GetPlayers>(() => GetPlayers(sl()));
  sl.registerLazySingleton<AddPlayer>(() => AddPlayer(sl()));
  sl.registerLazySingleton<UpdatePlayer>(() => UpdatePlayer(sl()));
  sl.registerFactory<PlayersCubit>(() => PlayersCubit(sl(), sl(), sl()));
}

void _initTeams() {
  sl.registerLazySingleton<TeamsRemoteDatasource>(() => TeamsRemoteDatasource(sl()));
  sl.registerLazySingleton<TeamsRepository>(() => TeamsRepositoryImpl(sl()));
  sl.registerLazySingleton<GetTeams>(() => GetTeams(sl()));
  sl.registerLazySingleton<AddTeam>(() => AddTeam(sl()));
  sl.registerFactory<TeamsCubit>(() => TeamsCubit(sl(), sl()));
}

void _initSessions() {
  sl.registerLazySingleton<SessionsRemoteDatasource>(() => SessionsRemoteDatasource(sl()));
  sl.registerLazySingleton<SessionsRepository>(() => SessionsRepositoryImpl(sl()));
  sl.registerLazySingleton<CreateSession>(() => CreateSession(sl()));
  sl.registerLazySingleton<GetSessions>(() => GetSessions(sl()));
  sl.registerLazySingleton<GetSession>(() => GetSession(sl()));
  sl.registerLazySingleton<EndSession>(() => EndSession(sl()));
  sl.registerFactory<SessionsCubit>(() => SessionsCubit(sl(), sl()));
  sl.registerFactory<SessionDetailsCubit>(() => SessionDetailsCubit(sl(), sl(), sl(), sl()));
}

void _initMatches() {
  sl.registerLazySingleton<MatchesRemoteDatasource>(() => MatchesRemoteDatasource(sl()));
  sl.registerLazySingleton<MatchesRepository>(() => MatchesRepositoryImpl(sl()));
  sl.registerLazySingleton<AddMatch>(() => AddMatch(sl()));
  sl.registerLazySingleton<GetMatch>(() => GetMatch(sl()));
  sl.registerLazySingleton<WatchMatch>(() => WatchMatch(sl()));
  sl.registerLazySingleton<WatchMatchesForSession>(() => WatchMatchesForSession(sl()));
  sl.registerLazySingleton<WatchRounds>(() => WatchRounds(sl()));
  sl.registerLazySingleton<AddRound>(() => AddRound(sl()));
  sl.registerLazySingleton<UndoLastRound>(() => UndoLastRound(sl()));
  sl.registerLazySingleton<EndMatch>(() => EndMatch(sl()));
  sl.registerFactory<MatchCubit>(() => MatchCubit(sl(), sl(), sl(), sl(), sl(), sl()));
}

void _initSettings() {
  sl.registerLazySingleton<SettingsRemoteDatasource>(() => SettingsRemoteDatasource(sl()));
  sl.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(sl()));
  sl.registerLazySingleton<GetSettings>(() => GetSettings(sl()));
  sl.registerLazySingleton<UpdateSettings>(() => UpdateSettings(sl()));
  sl.registerLazySingleton<SeedSampleData>(() => SeedSampleData(sl(), sl(), sl(), sl()));
  sl.registerFactory<SettingsCubit>(() => SettingsCubit(sl<SettingsRepository>(), sl(), sl()));
}

void _initStats() {
  sl.registerLazySingleton<StatsRemoteDatasource>(() => StatsRemoteDatasource(sl()));
  sl.registerLazySingleton<StatsRepository>(() => StatsRepositoryImpl(sl()));
  sl.registerLazySingleton<ComputeStats>(() => ComputeStats(sl()));
  sl.registerFactory<StatsCubit>(() => StatsCubit(sl()));
}
