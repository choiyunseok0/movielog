import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movielog/app.dart';
import 'package:movielog/screens/profile_screen.dart';
import 'package:movielog/theme/app_theme.dart';

void main() {
  testWidgets('앱을 실행하면 2주차 회원가입 화면이 표시된다', (tester) async {
    await tester.pumpWidget(const MovieLogApp());

    expect(find.text('회원가입'), findsOneWidget);
    expect(find.text('환영합니다!\n간단한 정보만 입력하고 시작해보세요.'), findsOneWidget);
    expect(find.byKey(const Key('nicknameField')), findsOneWidget);
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
