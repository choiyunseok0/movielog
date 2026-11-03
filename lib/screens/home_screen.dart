import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../view_models/movie_home_view_model.dart';

import '../data/mock_movies.dart';
import '../widgets/featured_movie_card.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final featuredMovie = mockMovies.first;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MovieLog',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text(
                '오늘은 어떤 영화를 볼까요?',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FeaturedMovieCard(
                movie: featuredMovie,
                onTap: () => context.push('/movies/${featuredMovie.id}'),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '인기 영화',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/movies'),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('전체보기'),
                        SizedBox(width: 2),
                        Icon(Icons.chevron_right_rounded, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 270,
              child: Consumer<MovieHomeViewModel>(
                builder: (context, viewModel, child) {
                  switch (viewModel.status) {
                    case MovieHomeLoadStatus.idle:
                    case MovieHomeLoadStatus.loading:
                      return const Center(child: CircularProgressIndicator());
                    case MovieHomeLoadStatus.error:
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(viewModel.message!),
                          TextButton(
                            onPressed: viewModel.loadPopular,
                            child: const Text('다시 시도'),
                          ),
                        ],
                      );
                    case MovieHomeLoadStatus.empty:
                      return const Center(child: Text('인기 영화가 없습니다.'));
                    case MovieHomeLoadStatus.success:
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: viewModel.popularMovies.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final movie = viewModel.popularMovies[index];
                          return SizedBox(
                            width: 140,
                            child: MovieCard.tmdb(
                              movie: movie,
                              imageAspectRatio: 0.68,
                              compact: true,
                              showRating: true,
                              showMetadata: false,
                              rank: index + 1,
                              onTap: () => context.push(
                                '/movies/${movie.id}',
                                extra: movie,
                              ),
                            ),
                          );
                        },
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
