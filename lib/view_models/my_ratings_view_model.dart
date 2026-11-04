import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../data/models/rating_with_movie.dart';
import '../data/models/tmdb_movie_dto.dart';
import '../data/services/rating_api_service.dart';
import '../data/services/tmdb_movie_service.dart';

enum MyRatingsLoadStatus { idle, loading, empty, error, success }

class MyRatingsViewModel extends ChangeNotifier {
  MyRatingsViewModel(this._ratingsService, this._movieService);

  static const sampleMemberId = 1;
  final RatingApiService _ratingsService;
  final TmdbMovieService _movieService;
  final _movies = <int, TmdbMovieDto?>{};
  bool _disposed = false;

  var status = MyRatingsLoadStatus.idle;
  List<RatingWithMovie> ratings = [];
  String? message;

  Future<void> load() async {
    if (_disposed || status == MyRatingsLoadStatus.loading) return;
    status = MyRatingsLoadStatus.loading;
    message = null;
    notifyListeners();

    try {
      final result = await _ratingsService.fetchMyRatings(sampleMemberId);
      if (_disposed) return;
      final entries = <RatingWithMovie>[];
      for (final rating in result) {
        final movie = await _findMovie(rating.movieId);
        if (_disposed) return;
        entries.add(RatingWithMovie(rating: rating, movie: movie));
      }
      ratings = entries;
      status = entries.isEmpty
          ? MyRatingsLoadStatus.empty
          : MyRatingsLoadStatus.success;
    } on DioException catch (error) {
      message = writeMyRatingsErrorMessage(error);
      status = MyRatingsLoadStatus.error;
    } catch (_) {
      message = '평점을 불러오지 못했습니다. 잠시 후 다시 시도해 주세요.';
      status = MyRatingsLoadStatus.error;
    }
    if (!_disposed) notifyListeners();
  }

  Future<TmdbMovieDto?> _findMovie(int id) async {
    if (_movies.containsKey(id)) return _movies[id];
    try {
      return _movies[id] = await _movieService.findMovieById(id);
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
