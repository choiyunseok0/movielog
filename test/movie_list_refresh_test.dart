import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:movielog/data/models/tmdb_genre_dto.dart';
import 'package:movielog/data/models/tmdb_movie_dto.dart';
import 'package:movielog/data/services/tmdb_movie_service.dart';
import 'package:movielog/screens/movie_list_screen.dart';
import 'package:movielog/view_models/movie_list_view_model.dart';

class _Service extends TmdbMovieService {
  _Service() : super(Dio());

  final pages = <int>[];
  final filters = <String?>[];
  Completer<void>? gate;
  bool fail = false;
  bool empty = false;
  int generation = 0;

  @override
  Future<List<TmdbGenreDto>> fetchGenres() async => [
    const TmdbGenreDto(id: 28, name: '액션'),
    const TmdbGenreDto(id: 12, name: '모험'),
  ];

  @override
  Future<TmdbMoviePageDto> discoverMovies({
    int page = 1,
    String? withGenres,
  }) async {
    pages.add(page);
    filters.add(withGenres);
    if (gate != null) await gate!.future;
    if (fail) throw Exception('offline');
    return TmdbMoviePageDto(
      page: page,
      totalPages: 2,
      totalResults: empty ? 0 : 40,
      results: empty
          ? []
          : List.generate(
              20,
              (i) => TmdbMovieDto.fromJson({
                'id': generation * 100 + (page - 1) * 20 + i,
                'title': '영화 $generation-$page-$i',
              }),
            ),
    );
  }
}

void main() {
  test('새로고침은 기존 목록과 조건을 유지하고 1페이지부터 교체한다', () async {
    final service = _Service();
    final vm = MovieListViewModel(service);
    await vm.load(genreIds: [28, 12]);
    final previous = vm.movies;
    service.generation = 1;
    service.gate = Completer();
    final refresh = vm.refresh();
    expect(vm.isLoading, isTrue);
    expect(vm.movies, same(previous));
    final requests = service.pages.length;
    await vm.refresh();
    await vm.selectGenres([]);
    expect(service.pages.length, requests);
    expect(vm.selectedGenreIds, [28, 12]);
    service.gate!.complete();
    await refresh;
    expect(service.pages, [1, 2, 1, 2]);
    expect(service.filters.every((value) => value == '28|12'), isTrue);
    expect(vm.movies.length, 30);
    expect(vm.movies.first.id, 100);
    vm.dispose();
  });

  test('장르 요청 실패도 최근 성공 목록을 보존하고 같은 조건으로 재시도한다', () async {
    final service = _Service();
    final vm = MovieListViewModel(service);
    await vm.load();
    final previous = vm.movies;
    service.fail = true;
    await vm.selectGenres([28, 12]);
    expect(vm.status, MovieListLoadStatus.error);
    expect(vm.movies, same(previous));
    vm.dismissError();
    expect(vm.status, MovieListLoadStatus.success);
    service.fail = false;
    await vm.refresh();
    expect(service.pages[service.pages.length - 2], 1);
    expect(service.filters.last, '28|12');
    expect(vm.status, MovieListLoadStatus.success);
    service.empty = true;
    await vm.refresh();
    expect(vm.status, MovieListLoadStatus.empty);
    expect(vm.movies, isEmpty);
    vm.dispose();
  });

  testWidgets('첫 로딩 실패도 팝업을 표시하고 취소 후 반복하지 않는다', (tester) async {
    final service = _Service()..fail = true;
    final vm = MovieListViewModel(service);
    await vm.load();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: vm,
        child: const MaterialApp(home: MovieListScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(find.text('취소'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    await tester.pump();
    expect(find.byType(AlertDialog), findsNothing);
    await tester.tap(find.text('다시 시도'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    service.fail = false;
    await tester.tap(find.widgetWithText(FilledButton, '다시 시도'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byType(GridView), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    vm.dispose();
  });

  testWidgets('당겨 새로고침 실패 시 목록 유지, 취소와 재시도 동작', (tester) async {
    final service = _Service();
    final vm = MovieListViewModel(service);
    await vm.load(genreIds: [28, 12]);
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: vm,
        child: const MaterialApp(
          home: MovieListScreen(selectedGenres: [28, 12]),
        ),
      ),
    );
    await tester.pumpAndSettle();
    service.fail = true;
    service.gate = Completer();
    await tester.drag(find.byType(GridView), const Offset(0, 800));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(vm.isLoading, isTrue);
    expect(find.text('영화 0-1-0'), findsOneWidget);
    expect(
      tester
          .widget<IconButton>(
            find.byWidgetPredicate(
              (widget) => widget is IconButton && widget.tooltip == '장르 필터',
            ),
          )
          .onPressed,
      isNull,
    );
    final requests = service.pages.length;
    await tester.drag(find.byType(GridView), const Offset(0, 800));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(service.pages.length, requests);
    service.gate!.complete();
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('영화 0-1-0'), findsOneWidget);
    await tester.tap(find.text('취소'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('영화 0-1-0'), findsOneWidget);

    service.gate = null;
    await vm.refresh();
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    service.fail = false;
    service.generation = 1;
    await tester.tap(find.text('다시 시도'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('영화 1-1-0'), findsOneWidget);
    expect(service.filters.last, '28|12');
    expect(service.pages.sublist(service.pages.length - 2), [1, 2]);
    await tester.pumpWidget(const SizedBox());
    vm.dispose();
  });
}
