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
  bool _errorDialogOpen = false;
  bool _errorHandled = false;

  void _checkError(MovieListViewModel vm) {
    if (vm.status != MovieListLoadStatus.error) {
      _errorHandled = false;
      return;
    }
    if (_errorDialogOpen || _errorHandled) return;
    _errorHandled = true;
    _errorDialogOpen = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || vm.status != MovieListLoadStatus.error) {
        _errorDialogOpen = false;
        return;
      }
      final retry = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
          content: SizedBox(
            width: 320,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0EAF9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.restart_alt_rounded,
                    size: 40,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '영화를 불러오지 못했어요',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF29272D),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '네트워크 상태를 확인하고\n다시 시도해 주세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Color(0xFF746E7D),
                  ),
                ),
                const SizedBox(height: 36),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFF5EFFB),
                          foregroundColor: Theme.of(context)
                              .colorScheme
                              .primary,
                          minimumSize: const Size(0, 56),
                          shape: const StadiumBorder(),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('취소'),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 56),
                          shape: const StadiumBorder(),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('다시 시도'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      _errorDialogOpen = false;
      if (!mounted) return;
      vm.dismissError();
      if (retry == true) {
        _errorHandled = false;
        vm.refresh();
      }
    });
  }

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
      builder: (context, vm, child) {
        _checkError(vm);
        return Scaffold(
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
        );
      },
    );
  }

  Widget _buildBody(MovieListViewModel vm) {
    if (vm.movies.isNotEmpty &&
        (vm.status == MovieListLoadStatus.success ||
            vm.status == MovieListLoadStatus.error ||
            vm.isRefreshing)) {
      return _buildMovieList(vm);
    }
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
                onPressed: () {
                  _errorHandled = false;
                  vm.load();
                },
                child: const Text('다시 시도'),
              ),
            ],
          ),
        );
      case MovieListLoadStatus.empty:
        return RefreshIndicator(
          onRefresh: vm.refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(height: 160),
              Center(child: Text('선택한 장르의 영화가 없습니다.')),
            ],
          ),
        );
      case MovieListLoadStatus.success:
        return _buildMovieList(vm);
    }
  }

  Widget _buildMovieList(MovieListViewModel vm) {
    return RefreshIndicator(
      onRefresh: vm.refresh,
      notificationPredicate: (notification) =>
          !vm.isLoading && notification.depth == 0,
      child: GridView.builder(
        physics: vm.isLoading
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
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
            onTap: vm.isLoading
                ? () {}
                : () => context.push('/movies/${movie.id}', extra: movie),
          );
        },
      ),
    );
  }
}
