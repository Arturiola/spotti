import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/spotti_button.dart';
import '../widgets/spotti_text_field.dart';
import '../repositories/auth_repository.dart';
import '../utils/validators.dart';
import '../widgets/app_feedback.dart';
import '../services/analytics_service.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback? onRegisterSuccess;
  final VoidCallback? onLoginPressed;
  final VoidCallback? onBackPressed;

  const RegisterScreen({
    super.key,
    this.onRegisterSuccess,
    this.onLoginPressed,
    this.onBackPressed,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthRepository();
  bool _busy = false;

  Future<void> _register() async {
    if (_busy || !_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      await _auth.signUp(email: _emailController.text.trim(), password: _passwordController.text);
      await _auth.sendEmailVerification();
      if (!mounted) return;
      widget.onRegisterSuccess?.call();
      try { await AnalyticsService.signUp(); } catch (_) {}
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
                  'Створити акаунт',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Зберігайте власну історію відвіданих місць.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                // Email field
                SpottiTextField(
                  label: 'Електронна пошта',
                  controller: _emailController,
                  validator: InputValidators.email,
                  keyboardType: TextInputType.emailAddress,
                  hint: 'name@example.com',
                ),
                const SizedBox(height: 20),
                // Password field
                SpottiTextField(
                  label: 'Пароль',
                  controller: _passwordController,
                  validator: InputValidators.newPassword,
                  isPassword: true,
                  helperText: '8–100 символів',
                ),
                const SizedBox(height: 32),
                // Register Button
                SpottiButton(
                  text: _busy ? 'Реєстрація...' : 'Зареєструватися',
                  type: SpottiButtonType.primary,
                  onPressed: _busy ? null : _register,
                ),
                const SizedBox(height: 24),
                // Login footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Вже маєте акаунт? ',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onLoginPressed,
                      child: const Text(
                        'Увійти',
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
