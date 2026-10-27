import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../view_models/movie_list_view_model.dart';
import '../widgets/genre_filter_sheet.dart';
import '../widgets/movie_card.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key, this.selectedGenres = const []});

  final List<int> selectedGenres;

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  @override
  void didUpdateWidget(covariant MovieListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.selectedGenres, oldWidget.selectedGenres)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final vm = context.read<MovieListViewModel>();
        if (!listEquals(widget.selectedGenres, vm.selectedGenreIds)) {
          vm.load(genreIds: widget.selectedGenres);
        }
      });
    }
  }

  Future<void> _openGenreFilter() async {
    final vm = context.read<MovieListViewModel>();
    if (vm.isLoading) return;
    final ids = await showModalBottomSheet<List<int>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GenreFilterSheet(
        initialGenres: vm.selectedGenreIds,
        genres: vm.genres,
      ),
    );
    if (!mounted || ids == null || vm.isLoading) return;
    vm.selectGenres(ids);
    context.go(
      Uri(
        path: '/movies',
        queryParameters: ids.isEmpty ? null : {'genres': ids.join(',')},
      ).toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieListViewModel>(
      builder: (context, vm, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            '영화',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              onPressed: vm.isLoading || vm.genres.isEmpty
                  ? null
                  : _openGenreFilter,
              tooltip: '장르 필터',
              icon: Badge(
                isLabelVisible: vm.selectedGenreIds.isNotEmpty,
                label: Text('${vm.selectedGenreIds.length}'),
                child: const Icon(Icons.filter_list_rounded),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(child: _buildBody(vm)),
      ),
    );
  }

  Widget _buildBody(MovieListViewModel vm) {
    switch (vm.status) {
      case MovieListLoadStatus.idle:
      case MovieListLoadStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case MovieListLoadStatus.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(vm.message!),
              TextButton(
                onPressed: () => vm.load(),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        );
      case MovieListLoadStatus.empty:
        return const Center(child: Text('선택한 장르의 영화가 없습니다.'));
      case MovieListLoadStatus.success:
        return GridView.builder(
          key: ValueKey(vm.selectedGenreIds.join(',')),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          itemCount: vm.movies.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 24,
            childAspectRatio: 0.5,
          ),
          itemBuilder: (context, index) {
            final movie = vm.movies[index];
            return MovieCard.tmdb(
              movie: movie,
              imageAspectRatio: 0.65,
              compact: true,
              showRating: true,
              ratingOverlay: true,
              onTap: () => context.push('/movies/${movie.id}', extra: movie),
            );
          },
        );
    }
  }
}
