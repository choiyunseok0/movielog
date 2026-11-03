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

  //// 2-4. _fetchMovies() — 영화 모을 공간 준비
  Future<List<TmdbMovieDto>> _fetchMovies(
    List<int> genreIds,
    int version,
  ) async {
    // 영화 ID를 키로 사용해서 중복 제거
    final byId = <int, TmdbMovieDto>{};
    var pageNumber = 1;

    //// 2-5. _fetchMovies() → Service — 한 페이지 요청 (2-6.tmdb_movie_service.dart)
    // 중복 없는 영화가 30개 미만인 동안 반복한다
    while (byId.length < 30) {
      final page = await _service.discoverMovies(
        page: pageNumber,

        // 선택한 장르 없으면 조건 생략
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


//// 2-2. movie_list_view_model.dart — 조회 준비
  Future<void> load({List<int>? genreIds, bool keepMovies = false}) async {
    
    // 이미 종료된 ViewModel이면 작업하지 않는다
    if (_disposed) return;

    // 이번 요청의 번호를 만든다
    final version = ++_requestVersion;

    // 전달받은 장르가 있으면 적용
    // 없으면 현재 선택한 장르 유지
    selectedGenreIds = List.of(genreIds ?? selectedGenreIds);

    // 이번 요청에 사용할 장르 목록을 복사해 둠
    final requestedGenres = List<int>.of(selectedGenreIds);

    // 새로 고침인지 저장하고 로딩 상태 알려줌
    isRefreshing = keepMovies;
    status = MovieListLoadStatus.loading;
    message = null;
    notifyListeners();

    //// 2-3. 처음엔 Genre API도 먼저 호출함
    try {

      //  장르 목록이 없으면 먼저 가져옴
      // 이 데이터는 장르 선택 바텀시트에서 사용하는거임
      if (genres.isEmpty) {
        final result = await _service.fetchGenres();
        if (_disposed || version != _requestVersion) return;
        genres = result;
      }

      // 준비한 조건으로 영화 최대 30개 가져오기
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
