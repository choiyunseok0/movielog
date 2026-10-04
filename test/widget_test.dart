import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movielog/app.dart';
import 'package:movielog/data/mock_movies.dart';
import 'package:movielog/router/app_router.dart';
import 'package:movielog/screens/profile_screen.dart';
import 'package:movielog/theme/app_theme.dart';
import 'package:movielog/widgets/movie_card.dart';
import 'package:movielog/widgets/movie_rating_input.dart';

void main() {
  setUp(() => AppRouter.router.go('/start'));

  testWidgets('앱을 실행하면 시작 화면이 표시된다', (tester) async {
    await tester.pumpWidget(const MovieLogApp());
    await tester.pumpAndSettle();
    expect(find.text('FLUTTER 1주차'), findsOneWidget);
    expect(find.text('시작하기'), findsOneWidget);
  });

  testWidgets('시작하기를 누르면 2주차 회원가입 화면이 열린다', (tester) async {
    await tester.pumpWidget(const MovieLogApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('시작하기'));
    await tester.pumpAndSettle();
    expect(find.text('환영합니다!\n간단한 정보만 입력하고 시작해보세요.'), findsOneWidget);
  });

  testWidgets('입력과 약관 검증이 완료되면 홈으로 이동하고 뒤로 가지 않는다', (tester) async {
    await tester.pumpWidget(const MovieLogApp());
    AppRouter.router.go('/register');
    await tester.pumpAndSettle();
    final button = find.byKey(const Key('registerButton'));
    expect(tester.widget<ElevatedButton>(button).onPressed, isNull);
    for (final entry in {
      'nicknameField': '무비러버',
      'emailField': 'movie@example.com',
      'passwordField': 'password123',
    }.entries) {
      final field = find.byKey(Key(entry.key));
      await tester.ensureVisible(field);
      await tester.enterText(field, entry.value);
    }
    await tester.pump();
    expect(tester.widget<ElevatedButton>(button).onPressed, isNull);
    final terms = find.byKey(const Key('termsCheckbox'));
    await tester.ensureVisible(terms);
    await tester.tap(terms);
    await tester.pump();
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(find.text('오늘은 어떤 영화를 볼까요?'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('오늘은 어떤 영화를 볼까요?'), findsOneWidget);
    AppRouter.router.go('/start');
    await tester.pumpAndSettle();
  });

  testWidgets('홈 영화 카드를 누르면 같은 영화의 상세 화면이 열린다', (tester) async {
    await tester.pumpWidget(const MovieLogApp());
    AppRouter.router.go('/home');
    await tester.pumpAndSettle();

    final featuredMovie = mockMovies.first;
    expect(featuredMovie.title, '별빛 아래 우리');
    expect(find.text(featuredMovie.title), findsOneWidget);

    await tester.ensureVisible(find.text(featuredMovie.title));
    await tester.pumpAndSettle();
    await tester.tap(find.text(featuredMovie.title));
    await tester.pumpAndSettle();

    expect(find.text('Cinema Archive'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();
    expect(find.text(featuredMovie.title), findsOneWidget);
    expect(
      find.text(
        '${featuredMovie.year} · ${featuredMovie.genre} · ${featuredMovie.durationMinutes}분',
      ),
      findsOneWidget,
    );

    AppRouter.router.go('/start');
    await tester.pumpAndSettle();
  });

  testWidgets('영화 목록에서 선택한 장르의 영화만 표시된다', (tester) async {
    await tester.pumpWidget(const MovieLogApp());
    AppRouter.router.go('/movies');
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsOneWidget);
    expect(find.text('별빛 아래 우리'), findsOneWidget);

    await tester.tap(find.byTooltip('장르 필터'));
    await tester.pumpAndSettle();
    expect(find.text('장르 필터'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('genre-SF')));
    await tester.pump();
    expect(find.text('별빛 아래 우리'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, '확인'));
    await tester.pumpAndSettle();

    expect(find.byType(MovieCard), findsOneWidget);
    expect(find.text('공허의 메아리'), findsOneWidget);
    expect(find.text('별빛 아래 우리'), findsNothing);
    expect(
      AppRouter
          .router
          .routeInformationProvider
          .value
          .uri
          .queryParameters['genres'],
      'SF',
    );

    AppRouter.router.go('/start');
    await tester.pumpAndSettle();
  });

  testWidgets('NavigationBar 탭을 바꿔도 영화 장르 선택이 유지된다', (tester) async {
    await tester.pumpWidget(const MovieLogApp());
    AppRouter.router.go('/movies?genres=SF');
    await tester.pumpAndSettle();

    expect(find.text('공허의 메아리'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('navigation-홈')));
    await tester.pumpAndSettle();
    expect(find.text('오늘은 어떤 영화를 볼까요?'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('navigation-영화')));
    await tester.pumpAndSettle();
    expect(find.text('공허의 메아리'), findsOneWidget);
    expect(find.text('별빛 아래 우리'), findsNothing);

    final navigationBar = tester.widget<NavigationBar>(
      find.byType(NavigationBar),
    );
    expect(navigationBar.selectedIndex, 1);

    await tester.tap(find.byKey(const ValueKey('navigation-마이')));
    await tester.pumpAndSettle();
    expect(find.text('내 프로필'), findsOneWidget);

    AppRouter.router.go('/start');
    await tester.pumpAndSettle();
  });

  testWidgets('영화 상세에서 즐겨찾기 결과를 표시한다', (tester) async {
    await tester.pumpWidget(const MovieLogApp());
    AppRouter.router.go('/movies/1');
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();
    expect(find.text('4.5'), findsOneWidget);

    await tester.tap(find.byTooltip('즐겨찾기 추가'));
    await tester.pump();
    expect(find.text('즐겨찾기에 추가했습니다.'), findsOneWidget);
    expect(find.byTooltip('즐겨찾기 삭제'), findsOneWidget);

    AppRouter.router.go('/start');
    await tester.pumpAndSettle();
  });

  testWidgets('영화 상세에서 평점 Dialog를 표시한다', (tester) async {
    await tester.pumpWidget(const MovieLogApp());
    AppRouter.router.go('/movies/1');
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -800));
    await tester.pumpAndSettle();

    final ratingButton = find.widgetWithText(ElevatedButton, '평점 남기기');
    await tester.ensureVisible(ratingButton);
    await tester.pumpAndSettle();
    await tester.tap(ratingButton);
    await tester.pumpAndSettle();
    expect(find.text('영화는 어떠셨나요?'), findsOneWidget);
    expect(find.byType(MovieRatingInput), findsOneWidget);

    final saveButton = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, '확인'),
    );
    expect(saveButton.onPressed, isNull);

    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();
    AppRouter.router.go('/start');
    await tester.pumpAndSettle();
  });

  testWidgets('Figma 기준 프로필 정보가 표시된다', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const ProfileScreen()),
    );

    expect(find.text('내 프로필'), findsOneWidget);
    expect(find.text('무비러버'), findsOneWidget);
    expect(find.text('342'), findsOneWidget);
    expect(find.text('4.2'), findsOneWidget);
    expect(find.text('58'), findsOneWidget);
    expect(find.text('선호하는 장르'), findsOneWidget);
    expect(find.text('프로필 수정'), findsOneWidget);
  });
}
