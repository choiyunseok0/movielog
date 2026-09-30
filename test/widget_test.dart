import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movielog/app.dart';
import 'package:movielog/data/mock_movies.dart';
import 'package:movielog/router/app_router.dart';
import 'package:movielog/screens/profile_screen.dart';
import 'package:movielog/theme/app_theme.dart';

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
