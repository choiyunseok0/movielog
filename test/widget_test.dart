import 'package:flutter_test/flutter_test.dart';
import 'package:movielog/app.dart';

void main() {
  testWidgets('프로필 헤더의 주요 정보가 표시된다', (tester) async {
    await tester.pumpWidget(const MovieLogApp());

    expect(find.text('내 프로필'), findsOneWidget);
    expect(find.text('무비러버'), findsOneWidget);
    expect(find.text('좋아하는 영화를 기록하고 있어요'), findsOneWidget);
  });
}
