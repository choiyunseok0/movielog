import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movielog/screens/register_screen.dart';

void main() {
  testWidgets('닉네임은 공백과 한 글자를 거부하고 두 글자 이상을 허용한다', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
    final field = find.byKey(const Key('nicknameField'));

    await tester.enterText(field, '   ');
    await tester.pump();
    expect(find.text('닉네임을 입력해 주세요.'), findsOneWidget);

    await tester.enterText(field, '리');
    await tester.pump();
    expect(find.text('닉네임은 두 글자 이상 입력해 주세요.'), findsOneWidget);

    await tester.enterText(field, ' 리야 ');
    await tester.pump();
    expect(find.text('닉네임은 두 글자 이상 입력해 주세요.'), findsNothing);
    expect(find.text('사용할 닉네임: 리야'), findsOneWidget);
  });

  testWidgets('키보드가 화면을 가려도 입력 영역을 스크롤할 수 있다', (tester) async {
    tester.view.physicalSize = const Size(390, 500);
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
    await tester.enterText(find.byKey(const Key('nicknameField')), '리야');
    await tester.pump();
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
