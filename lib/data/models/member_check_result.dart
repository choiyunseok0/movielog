// 서버의 중복 확인 답을 담는 상자
// 서버에서 보내는 응답을 플러터에서 편하게 사용하도록 CheckResult라는 객체에 담음
class CheckResult {
  const CheckResult({required this.available});

  final bool available;

  factory CheckResult.fromJson(Map<String, dynamic> json) {
    return CheckResult(available: json['available'] as bool);
  }
}
