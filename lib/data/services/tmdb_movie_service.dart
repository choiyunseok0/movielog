import 'package:dio/dio.dart';

import '../models/tmdb_genre_dto.dart';
import '../models/tmdb_movie_dto.dart';

class TmdbMovieService {
  TmdbMovieService(this._dio);

  final Dio _dio;


  // 4. tmdb_movie_service.dart  : TMDB 요청  (5.tmdb_movie_dto.dart)
  Future<TmdbMoviePageDto> fetchPopular({int page = 1}) async {
    // 공통 Client로 인기 영화 API를 호출한다
    final response = await _dio.get<Map<String, dynamic>>(
      '/movie/popular',
      queryParameters: {'language': 'ko-KR', 'page': page},
    );

    // 서버의 JSON으로 된 응답을 DTO로 변환해 ViewModel에 돌려줌
    return TmdbMoviePageDto.fromJson(response.data!);
  }



  ////2-6. tmdb_movie_service.dart — Discover API 호출 (2-7.tmdb_movie_dto.dart)
  Future<TmdbMoviePageDto> discoverMovies({
    int page = 1,
    String? withGenres,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/discover/movie',
      queryParameters: {
        'language': 'ko-KR',
        'page': page,
        'sort_by': 'popularity.desc',
        'include_adult': false,
        'include_video': false,

        // 장르 조건이 있을 때만 요청에 포함한다
        if (withGenres != null && withGenres.isNotEmpty)
          'with_genres': withGenres,
      },
    );
    // 응답 JSON을 페이지 DTO로 변환해 반환한다
    return TmdbMoviePageDto.fromJson(response.data!);
  }

  Future<List<TmdbGenreDto>> fetchGenres() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/genre/movie/list',
      queryParameters: {'language': 'ko'},
    );
    final genres = response.data!['genres'] as List<dynamic>;
    return genres
        .map((genre) => TmdbGenreDto.fromJson(genre as Map<String, dynamic>))
        .toList();
  }
}
