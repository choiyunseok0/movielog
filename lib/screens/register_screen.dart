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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _agreedToTerms = false;

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return '이메일을 입력해 주세요.';
    if (!RegExp(r'^[^\s@]+@[^\s@.]+(?:\.[^\s@.]+)+$').hasMatch(email)) {
      return '올바른 이메일 형식을 입력해 주세요.';
    }
    return null;
  }

  bool get _canSubmit =>
      _nicknameController.text.trim().length >= 2 &&
      _validateEmail(_emailController.text) == null &&
      _passwordController.text.length >= 8 &&
      _agreedToTerms;

  @override
  void dispose() {
    _nicknameController.dispose();
    _nicknameFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || !_agreedToTerms) return;
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('입력 확인이 완료되었습니다. 실제 회원가입은 연결하지 않습니다.')),
    );
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
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    final nickname = value?.trim() ?? '';
                    if (nickname.isEmpty) return '닉네임을 입력해 주세요.';
                    if (nickname.length < 2) return '닉네임은 두 글자 이상 입력해 주세요.';
                    return null;
                  },
                  onChanged: (_) => setState(() {}),
                  onFieldSubmitted: (_) => _emailFocusNode.requestFocus(),
                ),
                const SizedBox(height: 16),
                _NicknamePreview(nickname: _nicknameController.text.trim()),
                const SizedBox(height: 24),
                TextFormField(
                  key: const Key('emailField'),
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  decoration: const InputDecoration(
                    labelText: '이메일',
                    hintText: 'example@email.com',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.next,
                  validator: _validateEmail,
                  onChanged: (_) => setState(() {}),
                  onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('passwordField'),
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  decoration: const InputDecoration(
                    labelText: '비밀번호',
                    helperText: '8자 이상 입력해 주세요.',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) return '비밀번호를 입력해 주세요.';
                    if (value.length < 8) return '비밀번호는 8자 이상이어야 합니다.';
                    return null;
                  },
                  onChanged: (_) => setState(() {}),
                  onFieldSubmitted: (_) {
                    if (_canSubmit) {
                      _submit();
                    } else {
                      _passwordFocusNode.unfocus();
                    }
                  },
                ),
                const SizedBox(height: 16),
                _TermsAgreement(
                  value: _agreedToTerms,
                  onChanged: (value) => setState(() => _agreedToTerms = value),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  key: const Key('registerButton'),
                  onPressed: _canSubmit ? _submit : null,
                  child: const Text('가입하기'),
                ),
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

class _TermsAgreement extends StatelessWidget {
  const _TermsAgreement({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      key: const Key('termsCheckbox'),
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      title: const Text('이용약관 및 개인정보 처리방침에 동의합니다. (필수)'),
      value: value,
      onChanged: (value) => onChanged(value ?? false),
    );
  }
}
