import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/home_screen.dart';
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
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(path: homePath, builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: moviesPath,
        builder: (context, state) => const MovieListScreen(),
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

          return MovieDetailScreen(movieId: movieId);
        },
      ),
      GoRoute(
        path: myPagePath,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}
