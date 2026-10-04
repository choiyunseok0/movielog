import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movielog/screens/rating_practice_screen.dart';

void main() {
  testWidgets('별점 선택 전에는 저장할 수 없고 선택 후 저장할 수 있다', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RatingPracticeScreen()));
    final button = find.byKey(const Key('saveRatingButton'));
    expect(tester.widget<ElevatedButton>(button).onPressed, isNull);

    await tester.tap(find.byIcon(Icons.star_rounded).at(3));
    await tester.pumpAndSettle();
    expect(find.text('선택한 평점: 4.0점'), findsOneWidget);
    expect(tester.widget<ElevatedButton>(button).onPressed, isNotNull);

    await tester.tap(button);
    await tester.pump();
    expect(find.text('저장한 평점: 4.0점'), findsOneWidget);
  });
}
