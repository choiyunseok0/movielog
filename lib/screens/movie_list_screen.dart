import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/mock_movies.dart';
import '../models/movie.dart';
import '../widgets/genre_filter_sheet.dart';
import '../widgets/movie_card.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key, this.selectedGenres = const {}});

  final Set<String> selectedGenres;

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  late Set<String> _selectedGenres = {...widget.selectedGenres};

  @override
  void didUpdateWidget(covariant MovieListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!setEquals(widget.selectedGenres, _selectedGenres)) {
      _selectedGenres = {...widget.selectedGenres};
    }
  }

  List<Movie> get _filteredMovies {
    if (_selectedGenres.isEmpty) return mockMovies;
    return mockMovies
        .where((movie) => _selectedGenres.contains(movie.genre))
        .toList();
  }

  Future<void> _openGenreFilter() async {
    final selectedGenres = await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GenreFilterSheet(initialGenres: _selectedGenres);
      },
    );

    if (!mounted || selectedGenres == null) return;

    final orderedGenres = movieGenres.where(selectedGenres.contains).toList();
    setState(() {
      _selectedGenres = orderedGenres.toSet();
    });

    final location = Uri(
      path: '/movies',
      queryParameters: orderedGenres.isEmpty
          ? null
          : {'genres': orderedGenres.join(',')},
    ).toString();
    context.go(location);
  }

  @override
  Widget build(BuildContext context) {
    final filteredMovies = _filteredMovies;

    return Scaffold(
      appBar: AppBar(
        title: const Text('영화'),
        actions: [
          IconButton(
            onPressed: _openGenreFilter,
            tooltip: '장르 필터',
            icon: Badge(
              isLabelVisible: _selectedGenres.isNotEmpty,
              label: Text('${_selectedGenres.length}'),
              child: const Icon(Icons.filter_list_rounded),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: filteredMovies.isEmpty
            ? const Center(child: Text('선택한 장르의 영화가 없습니다.'))
            : GridView.builder(
                key: ValueKey(_selectedGenres.join(',')),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
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
                    imageAspectRatio: 0.65,
                    compact: true,
                    showRating: true,
                    onTap: () => context.push('/movies/${movie.id}'),
                  );
                },
              ),
      ),
    );
  }
}
