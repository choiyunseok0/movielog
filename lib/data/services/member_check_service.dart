import 'package:dio/dio.dart';

import '../../core/network/study_capture.dart';
import '../models/member_check_result.dart';

class MemberCheckService {
  MemberCheckService(this._dio);

  final Dio _dio;

  Future<bool> checkNickname(String nickname) async {
    if (StudyCapture.enabled) {
      await StudyCapture.pause();
      return nickname.trim() != '영화광';
    }
    final encoded = Uri.encodeComponent(nickname.trim());
    final response = await _dio.get<Map<String, dynamic>>(
      '/v5/members/nickname/$encoded',
    );
    return CheckResult.fromJson(response.data!).available;
  }

  Future<bool> checkEmail(String email) async {
    if (StudyCapture.enabled) {
      await StudyCapture.pause();
      return email.trim() != 'movie@umc.com';
    }
    final encoded = Uri.encodeComponent(email.trim());
    final response = await _dio.get<Map<String, dynamic>>(
      '/v5/members/email/$encoded',
    );
    return CheckResult.fromJson(response.data!).available;
  }
}
