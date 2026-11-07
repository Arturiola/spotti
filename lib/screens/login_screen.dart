import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/spotti_button.dart';
import '../widgets/spotti_text_field.dart';
import '../repositories/auth_repository.dart';
import '../utils/validators.dart';
import '../widgets/app_feedback.dart';
import '../services/analytics_service.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onLoginSuccess;
  final VoidCallback? onForgotPasswordPressed;
  final VoidCallback? onRegisterPressed;
  final VoidCallback? onBackPressed;

  const LoginScreen({
    super.key,
    this.onLoginSuccess,
    this.onForgotPasswordPressed,
    this.onRegisterPressed,
    this.onBackPressed,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthRepository();
  bool _busy = false;

  Future<void> _login() async {
    if (_busy || !_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      await _auth.signIn(email: _emailController.text.trim(), password: _passwordController.text);
      // Login succeeds only after a real Firebase response.
      if (!mounted) return;
      widget.onLoginSuccess?.call();
      // Analytics must never turn a successful login into an error.
      try { await AnalyticsService.login(); } catch (_) {}
    } catch (error) {
      if (mounted) showAppError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: widget.onBackPressed != null
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBackPressed,
        )
            : null,
        title: const Text('Spotti'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'З поверненням!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Увійдіть, щоб відкрити свій щоденник.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                // Email input
                SpottiTextField(
                  label: 'Електронна пошта',
                  controller: _emailController,
                  validator: InputValidators.email,
                  keyboardType: TextInputType.emailAddress,
                  hint: 'name@example.com',
                ),
                const SizedBox(height: 20),
                // Password input
                SpottiTextField(
                  label: 'Пароль',
                  controller: _passwordController,
                  validator: InputValidators.requiredPassword,
                  isPassword: true,
                ),
                const SizedBox(height: 8),
                // Forgot password link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: widget.onForgotPasswordPressed,
                    child: const Text(
                      'Забули пароль?',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Login button
                SpottiButton(
                  text: _busy ? 'Вхід...' : 'Увійти',
                  type: SpottiButtonType.primary,
                  onPressed: _busy ? null : _login,
                ),
                const SizedBox(height: 24),
                // Register link footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Ще не маєте акаунту? ',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onRegisterPressed,
                      child: const Text(
                        'Зареєструватися',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
