import 'package:flutter/material.dart';

import 'screens/rating_practice_screen.dart';
import 'theme/app_theme.dart';

// 실행: flutter run -t lib/main_rating.dart
void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const RatingPracticeScreen(),
    ),
  );
}
