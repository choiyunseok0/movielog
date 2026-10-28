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
        if (withGenres != null && withGenres.isNotEmpty)
          'with_genres': withGenres,
      },
    );
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
