import 'package:flutter/foundation.dart';

import '../data/models/tmdb_movie_dto.dart';
import '../data/services/tmdb_movie_service.dart';

enum MovieHomeLoadStatus { idle, loading, success, empty, error }

class MovieHomeViewModel extends ChangeNotifier {
  MovieHomeViewModel(this._service);

  final TmdbMovieService _service;
  List<TmdbMovieDto> popularMovies = const [];
  MovieHomeLoadStatus status = MovieHomeLoadStatus.idle;
  String? message;
  bool _disposed = false;

  // 3. movie_home_view_model.dart : 요청 전 로딩 상태 알리기 (tmdb_movie_service.dart)
  // 즉 loadPopular()를 호출할 때 마다 먼저 실행됌
  Future<void> loadPopular() async {
    // 이미 요청중이거나 종료된 VM이면 중복 요청 X 
    if (_disposed || status == MovieHomeLoadStatus.loading) return;

    // 화면에 로딩을 표시하도록 상태 변경
    status = MovieHomeLoadStatus.loading;

    // 이전 오류메시지를 지움
    message = null;

    // 구독 중인 화면에 상태 변경을 알림
    notifyListeners();

    try {
      // 실제 요청 보내는 부분 - Service에 인기 영화 조회를 요청
      // 응답이 올 때까지 이 함수의 다음 작업을 기다림

      // ------------------------------------------------
      // 6. movie_home_view_model.dart — ④ 최대 5개 저장 (7. home_screen.dart)
      final page = await _service.fetchPopular();

      if (_disposed) return;
      // 성공 처리
      // 응답 영화 중 앞에서 최대 5개를 홈 데이터로 저장함
      popularMovies = page.results.take(5).toList();
      status = popularMovies.isEmpty
          ? MovieHomeLoadStatus.empty
          : MovieHomeLoadStatus.success;
    } catch (_) {
      // 실패 처리
      if (_disposed) return;
      status = MovieHomeLoadStatus.error;
      message = '인기 영화를 불러오지 못했어요.';
    }
    // 성공, 실패처리가 끝나면 바뀐 목록과 상태를 화면에 알림
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
