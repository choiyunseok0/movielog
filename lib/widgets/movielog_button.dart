// movielod_button을 만드는 이유
// => 닉네임 확인 버튼과 이메일 확인 버튼에 같은 동작을 반복해서 작성하기 않기 위함
// 두 버튼은 눌렀을 때 하는 일이나 디자인은 다르지만, 통신 중이면 글자 대신 로딩 표시를 보여주고
// 다시 누르지 못하게 한다는 규칙은 같음 

// 그 규칙을 공용 버튼에 넣어두고 화면에서는 버튼 이름과 눌렀을 때 할 일, 통신 중인지 여부만 넘겨주면 됌

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MovieLogButton extends StatelessWidget {
  const MovieLogButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.width,
  });

  final String label;   // 버튼에 보여줄 글자
  // VoidCallback : 입력값 없이 실행하고 결과 값을 돌려주지 않는 함수 타입
  // Flutter에서는 버튼을 눌렀을 때 실행할 동작을 넘겨줄 때 자주 씀
  // ?를 써서 null을 전달할 수 있고 -> 'required'가 붙어있는 onPressed를 null이라고 명시해서 넘겨줄 수 있음
  final VoidCallback? onPressed;  // 눌렀을 때 할 일. (값이 null이면 누를 수 없음)
  final bool isLoading;   // 지금 통신 중인지. (생략하면 값은 false)
  final double? width;    // 버튼 너비. (생략하면 부모가 허용하는 범위 & 내용에 맞춤)

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,   // 밖에서 받은 너비를 내부 위젯에 그대로 전달한다는 뜻 
      height: 44,
      child: ElevatedButton(
        // 통신 중에는 못 누르게 하기 위함
        // isLoading = true이면 버튼에 null을 넘겨서 못누르고
        // isLoading = false이면 받은 onPressed를 그대로 넘김
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, 44),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          disabledBackgroundColor: AppColors.outlineVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.onPrimary,
                ),
              )
            : Text(label),
      ),
    );
  }
}
