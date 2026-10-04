import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

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
  }

  Widget _input({
    required String label,
    required String hint,
    required String fieldKey,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String? Function(String?) validator,
    required VoidCallback onSubmitted,
    bool isPassword = false,
    bool isEmail = false,
  }) {
    final hasInput = controller.text.isNotEmpty;
    final error = validator(controller.text);
    final hasError = hasInput && error != null;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.inputBorder),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          key: Key(fieldKey),
          controller: controller,
          focusNode: focusNode,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.outline),
            filled: true,
            fillColor: hasError
                ? AppColors.inputErrorBackground
                : AppColors.inputBackground,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: border,
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            errorBorder: border.copyWith(
              borderSide: const BorderSide(color: AppColors.inputError),
            ),
            focusedErrorBorder: border.copyWith(
              borderSide: const BorderSide(color: AppColors.inputError),
            ),
            errorStyle: const TextStyle(
              color: AppColors.inputError,
              fontSize: 12,
            ),
            errorMaxLines: 2,
            suffixIcon: hasInput
                ? Icon(
                    hasError ? Icons.error_outline : Icons.check_circle,
                    color: hasError ? AppColors.inputError : AppColors.primary,
                    size: 20,
                  )
                : null,
          ),
          obscureText: isPassword,
          keyboardType: isEmail
              ? TextInputType.emailAddress
              : TextInputType.text,
          autocorrect: !isEmail && !isPassword,
          enableSuggestions: !isPassword,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textInputAction: isPassword
              ? TextInputAction.done
              : TextInputAction.next,
          validator: validator,
          onChanged: (_) => setState(() {}),
          onFieldSubmitted: (_) => onSubmitted(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '회원가입',
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(color: AppColors.primary, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 22),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: (constraints.maxHeight - 48).clamp(
                  0,
                  double.infinity,
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _RegisterHeader(),
                        const SizedBox(height: 48),
                        _input(
                          label: '닉네임',
                          hint: '닉네임을 입력해주세요',
                          fieldKey: 'nicknameField',
                          controller: _nicknameController,
                          focusNode: _nicknameFocusNode,
                          validator: (value) {
                            final nickname = value?.trim() ?? '';
                            if (nickname.isEmpty) return '닉네임을 입력해 주세요.';
                            if (nickname.length < 2) {
                              return '닉네임은 2자 이상이어야 합니다.';
                            }
                            return null;
                          },
                          onSubmitted: () => _emailFocusNode.requestFocus(),
                        ),
                        const SizedBox(height: 16),
                        _input(
                          label: '이메일',
                          hint: '이메일 주소를 입력해주세요',
                          fieldKey: 'emailField',
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          validator: _validateEmail,
                          isEmail: true,
                          onSubmitted: () => _passwordFocusNode.requestFocus(),
                        ),
                        const SizedBox(height: 16),
                        _input(
                          label: '비밀번호',
                          hint: '비밀번호를 입력해주세요',
                          fieldKey: 'passwordField',
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '비밀번호를 입력해 주세요.';
                            }
                            if (value.length < 8) return '비밀번호는 8자 이상이어야 합니다.';
                            return null;
                          },
                          onSubmitted: () {
                            if (_canSubmit) {
                              _submit();
                            } else {
                              _passwordFocusNode.unfocus();
                            }
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 48),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _TermsAgreement(
                            value: _agreedToTerms,
                            onChanged: (value) =>
                                setState(() => _agreedToTerms = value),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            key: const Key('registerButton'),
                            onPressed: _canSubmit ? _submit : null,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(56),
                              elevation: 0,
                              disabledBackgroundColor:
                                  AppColors.disabledPrimary,
                              disabledForegroundColor: AppColors.onPrimary,
                            ),
                            child: const Text('가입하기'),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('이미 계정이 있나요?'),
                              TextButton(
                                onPressed: () {},
                                child: const Text('로그인'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterHeader extends StatelessWidget {
  const _RegisterHeader();

  @override
  Widget build(BuildContext context) {
    return Text(
      '환영합니다!\n간단한 정보만 입력하고 시작해보세요.',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium
          ?.copyWith(height: 1.6, fontWeight: FontWeight.w600),
    );
  }
}

class _TermsAgreement extends StatelessWidget {
  const _TermsAgreement({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            key: const Key('termsCheckbox'),
            value: value,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: const BorderSide(color: AppColors.inputBorder),
            onChanged: (value) => onChanged(value ?? false),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '필수 약관에 동의합니다',
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
