import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/mock_movies.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final featuredMovie = mockMovies.first;

    return Scaffold(
      appBar: AppBar(title: const Text('MovieLog')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            Text(
              '오늘은 어떤 영화를 볼까요?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '무비로그가 추천하는 영화를 만나보세요.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 28),
            MovieCard(
              movie: featuredMovie,
              onTap: () => context.push('/movies/${featuredMovie.id}'),
            ),
          ],
        ),
      ),
    );
  }
}
