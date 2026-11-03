import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/services/tmdb_movie_service.dart';
import '../data/models/tmdb_movie_dto.dart';
import '../view_models/movie_home_view_model.dart';

import '../view_models/movie_list_view_model.dart';
import '../screens/home_screen.dart';
import '../screens/main_screen.dart';
import '../screens/movie_detail_screen.dart';
import '../screens/movie_list_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/register_screen.dart';
import '../screens/start_screen.dart';

abstract final class AppRouter {
  static const startPath = '/start';
  static const registerPath = '/register';
  static const homePath = '/home';
  static const moviesPath = '/movies';
  static const myPagePath = '/my';

  static final router = GoRouter(
    initialLocation: startPath,
    routes: [
      GoRoute(
        path: startPath,
        builder: (context, state) => const StartScreen(),
      ),
      GoRoute(
        path: registerPath,
        builder: (context, state) =>
            RegisterScreen(onRegistered: () => context.go(homePath)),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: homePath,
                builder: (context, state) => ChangeNotifierProvider(
                  create: (context) =>
                      MovieHomeViewModel(context.read<TmdbMovieService>())
                        ..loadPopular(),
                  child: const HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: moviesPath,
                builder: (context, state) {
                  final genres =
                      state.uri.queryParameters['genres']
                          ?.split(',')
                          .map(int.tryParse)
                          .whereType<int>()
                          .where((id) => id > 0)
                          .toSet()
                          .toList() ??
                      const <int>[];
                  return ChangeNotifierProvider(
                    create: (context) =>
                        MovieListViewModel(context.read<TmdbMovieService>())
                          ..load(genreIds: genres),
                    child: MovieListScreen(selectedGenres: genres),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: myPagePath,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '$moviesPath/:movieId',
        builder: (context, state) {
          final movieId = int.tryParse(state.pathParameters['movieId'] ?? '');

          if (movieId == null) {
            return const Scaffold(
              body: Center(child: Text('영화 정보를 찾을 수 없습니다.')),
            );
          }

          final movie = state.extra is TmdbMovieDto
              ? state.extra as TmdbMovieDto
              : null;
          if (movie != null && movie.id != movieId) {
            return const Scaffold(
              body: Center(child: Text('영화 정보를 찾을 수 없습니다.')),
            );
          }
          return MovieDetailScreen(movieId: movieId, tmdbMovie: movie);
        },
      ),
    ],
  );
}
