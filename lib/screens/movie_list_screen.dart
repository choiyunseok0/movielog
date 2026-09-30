import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/mock_movies.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  static const _genres = ['전체', '드라마', 'SF', '스릴러', '애니메이션'];

  String _selectedGenre = '전체';

  List<Movie> get _filteredMovies {
    if (_selectedGenre == '전체') return mockMovies;
    return mockMovies.where((movie) => movie.genre == _selectedGenre).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredMovies = _filteredMovies;

    return Scaffold(
      appBar: AppBar(title: const Text('영화')),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 52,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _genres.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final genre = _genres[index];
                  return ChoiceChip(
                    label: Text(genre),
                    selected: genre == _selectedGenre,
                    onSelected: (_) {
                      setState(() {
                        _selectedGenre = genre;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                key: ValueKey(_selectedGenre),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                itemCount: filteredMovies.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.52,
                ),
                itemBuilder: (context, index) {
                  final movie = filteredMovies[index];
                  return MovieCard(
                    movie: movie,
                    imageAspectRatio: 2 / 3,
                    onTap: () => context.push('/movies/${movie.id}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
