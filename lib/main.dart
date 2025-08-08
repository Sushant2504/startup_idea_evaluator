import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/app.dart';
import 'src/data/datasources/idea_local_data_source.dart';
import 'src/data/repositories/idea_repository_impl.dart';
import 'src/domain/repositories/idea_repository.dart';
import 'src/presentation/bloc/theme_cubit.dart';

final getIt = GetIt.instance;

Future<void> _setupDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);
  getIt
    ..registerLazySingleton<IdeaLocalDataSource>(() => IdeaLocalDataSource(prefs: getIt()))
    ..registerLazySingleton<IdeaRepository>(() => IdeaRepositoryImpl(local: getIt()));
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setupDependencies();
  runApp(
    OKToast(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeCubit(getIt<SharedPreferences>())..load()),
        ],
        child: const StartupIdeaApp(),
      ),
    ),
  );
}
