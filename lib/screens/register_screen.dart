import 'package:flutter/material.dart';

import '../widgets/common_app_bar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _nicknameFocusNode = FocusNode();

  @override
  void dispose() {
    _nicknameController.dispose();
    _nicknameFocusNode.dispose();
    super.dispose();
  }

  void _validateNickname() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _nicknameFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: '회원가입'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _RegisterHeader(),
                const SizedBox(height: 32),
                TextFormField(
                  key: const Key('nicknameField'),
                  controller: _nicknameController,
                  focusNode: _nicknameFocusNode,
                  decoration: const InputDecoration(
                    labelText: '닉네임',
                    hintText: '두 글자 이상 입력해 주세요.',
                    border: OutlineInputBorder(),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    final nickname = value?.trim() ?? '';
                    if (nickname.isEmpty) return '닉네임을 입력해 주세요.';
                    if (nickname.length < 2) return '닉네임은 두 글자 이상 입력해 주세요.';
                    return null;
                  },
                  onChanged: (_) => setState(() {}),
                  onFieldSubmitted: (_) => _validateNickname(),
                ),
                const SizedBox(height: 16),
                _NicknamePreview(nickname: _nicknameController.text.trim()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 3주차 회원가입 화면의 안내 문구를 재사용합니다.
class _RegisterHeader extends StatelessWidget {
  const _RegisterHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('MovieLog를 시작해 볼까요?', style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text('프로필에 사용할 정보를 입력해 주세요.', style: textTheme.bodyLarge),
      ],
    );
  }
}

class _NicknamePreview extends StatelessWidget {
  const _NicknamePreview({required this.nickname});

  final String nickname;

  @override
  Widget build(BuildContext context) {
    return Text(
      nickname.isEmpty ? '닉네임을 입력하면 여기에 표시됩니다.' : '사용할 닉네임: $nickname',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
