import 'package:flutter/foundation.dart';

abstract final class StudyCapture {
  static const enabled = kDebugMode && bool.fromEnvironment('STUDY_CAPTURE');
  static const ratings = String.fromEnvironment('STUDY_RATINGS');

  static Future<void> pause() async {
    if (enabled) await Future<void>.delayed(const Duration(seconds: 5));
  }
}
