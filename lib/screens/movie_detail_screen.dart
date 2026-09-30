import 'package:flutter/material.dart';

import '../data/mock_movies.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key, required this.movieId});

  final int movieId;

  @override
  Widget build(BuildContext context) {
    final movie = findMovieById(movieId);

    if (movie == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('영화 정보를 찾을 수 없습니다.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('영화 상세')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset(
              movie.posterAsset,
              fit: BoxFit.cover,
              semanticLabel: '${movie.title} 포스터',
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  '${movie.genre} · ${movie.year} · ★ ${movie.averageRating}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                Text('줄거리', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  movie.synopsis,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
