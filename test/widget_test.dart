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
  testWidgets('앱을 실행하면 시작 화면이 표시된다', (tester) async {
    await tester.pumpWidget(const MovieLogApp());

    expect(find.text('FLUTTER 1주차'), findsOneWidget);
    expect(find.text('영화의 순간을\n기록하세요'), findsOneWidget);
    expect(find.text('시작하기'), findsOneWidget);
  });

  testWidgets('시작하기 버튼을 누르면 회원가입 화면으로 이동한다', (tester) async {
    await tester.pumpWidget(const MovieLogApp());

    await tester.tap(find.text('시작하기'));
    await tester.pumpAndSettle();

    expect(find.text('회원가입'), findsWidgets);
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

    expect(find.text('영화 상세'), findsOneWidget);
    expect(find.text(featuredMovie.title), findsOneWidget);
    expect(find.textContaining(featuredMovie.genre), findsOneWidget);

    AppRouter.router.go('/start');
    await tester.pumpAndSettle();
  });

  testWidgets('영화 목록에서 선택한 장르의 영화만 표시된다', (tester) async {
    await tester.pumpWidget(const MovieLogApp());
    AppRouter.router.go('/movies');
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsOneWidget);
    expect(find.text('별빛 아래 우리'), findsOneWidget);

    await tester.tap(find.text('SF'));
    await tester.pumpAndSettle();

    expect(find.byType(MovieCard), findsOneWidget);
    expect(find.text('공허의 메아리'), findsOneWidget);
    expect(find.text('별빛 아래 우리'), findsNothing);

    AppRouter.router.go('/start');
    await tester.pumpAndSettle();
  });

  testWidgets('NavigationBar 탭을 바꿔도 영화 장르 선택이 유지된다', (tester) async {
    await tester.pumpWidget(const MovieLogApp());
    AppRouter.router.go('/movies');
    await tester.pumpAndSettle();

    await tester.tap(find.text('SF'));
    await tester.pumpAndSettle();
    expect(find.text('공허의 메아리'), findsOneWidget);

    await tester.tap(find.text('홈'));
    await tester.pumpAndSettle();
    expect(find.text('오늘은 어떤 영화를 볼까요?'), findsOneWidget);

    await tester.tap(find.text('영화'));
    await tester.pumpAndSettle();
    expect(find.text('공허의 메아리'), findsOneWidget);
    expect(find.text('별빛 아래 우리'), findsNothing);

    final navigationBar = tester.widget<NavigationBar>(
      find.byType(NavigationBar),
    );
    expect(navigationBar.selectedIndex, 1);

    await tester.tap(find.text('마이'));
    await tester.pumpAndSettle();
    expect(find.text('내 프로필'), findsOneWidget);

    AppRouter.router.go('/start');
    await tester.pumpAndSettle();
  });

  testWidgets('영화 상세에서 즐겨찾기 결과를 표시한다', (tester) async {
    await tester.pumpWidget(const MovieLogApp());
    AppRouter.router.go('/movies/1');
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

    expect(find.text('4.5'), findsOneWidget);

    final ratingButton = find.widgetWithText(ElevatedButton, '평점 남기기');
    await tester.ensureVisible(ratingButton);
    await tester.pumpAndSettle();
    await tester.tap(ratingButton);
    await tester.pumpAndSettle();
    expect(find.text('영화는 어떠셨나요?'), findsOneWidget);
    expect(find.byType(MovieRatingInput), findsOneWidget);

    final saveButton = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, '저장'),
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
