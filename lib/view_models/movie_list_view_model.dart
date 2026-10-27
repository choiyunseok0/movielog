import 'package:flutter/foundation.dart';

import '../data/models/tmdb_genre_dto.dart';
import '../data/models/tmdb_movie_dto.dart';
import '../data/services/tmdb_movie_service.dart';

enum MovieListLoadStatus { idle, loading, success, empty, error }

class MovieListViewModel extends ChangeNotifier {
  MovieListViewModel(this._service);

  final TmdbMovieService _service;
  List<TmdbMovieDto> movies = const [];
  List<TmdbGenreDto> genres = const [];
  List<int> selectedGenreIds = const [];
  MovieListLoadStatus status = MovieListLoadStatus.idle;
  String? message;
  bool isRefreshing = false;
  int _requestVersion = 0;
  bool _disposed = false;

  bool get isLoading => status == MovieListLoadStatus.loading;

  Future<List<TmdbMovieDto>> _fetchMovies(
    List<int> genreIds,
    int version,
  ) async {
    final byId = <int, TmdbMovieDto>{};
    var pageNumber = 1;
    while (byId.length < 30) {
      final page = await _service.discoverMovies(
        page: pageNumber,
        withGenres: genreIds.isEmpty ? null : genreIds.join('|'),
      );
      if (_disposed || version != _requestVersion) return const [];
      for (final movie in page.results) {
        byId[movie.id] = movie;
        if (byId.length == 30) break;
      }
      if (pageNumber >= page.totalPages || page.results.isEmpty) break;
      pageNumber++;
    }
    return byId.values.toList();
  }

  Future<void> load({List<int>? genreIds, bool keepMovies = false}) async {
    if (_disposed) return;
    final version = ++_requestVersion;
    selectedGenreIds = List.of(genreIds ?? selectedGenreIds);
    final requestedGenres = List<int>.of(selectedGenreIds);
    isRefreshing = keepMovies;
    status = MovieListLoadStatus.loading;
    message = null;
    notifyListeners();
    try {
      if (genres.isEmpty) {
        final result = await _service.fetchGenres();
        if (_disposed || version != _requestVersion) return;
        genres = result;
      }
      final result = await _fetchMovies(requestedGenres, version);
      if (_disposed || version != _requestVersion) return;
      movies = result;
      status = movies.isEmpty
          ? MovieListLoadStatus.empty
          : MovieListLoadStatus.success;
    } catch (_) {
      if (_disposed || version != _requestVersion) return;
      status = MovieListLoadStatus.error;
      message = '영화를 불러오지 못했어요. 다시 시도해 주세요.';
    }
    isRefreshing = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    if (isLoading || _disposed) return;
    await load(keepMovies: true);
  }

  void dismissError() {
    if (_disposed || movies.isEmpty) return;
    message = null;
    status = MovieListLoadStatus.success;
    notifyListeners();
  }

  Future<void> selectGenres(List<int> ids) async {
    if (isLoading || listEquals(ids, selectedGenreIds)) return;
    await load(genreIds: ids);
  }

  @override
  void dispose() {
    _disposed = true;
    _requestVersion++;
    super.dispose();
  }
}
