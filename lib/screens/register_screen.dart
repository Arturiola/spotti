import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/spotti_button.dart';
import '../widgets/spotti_text_field.dart';

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
                keyboardType: TextInputType.emailAddress,
                hint: 'name@example.com',
              ),
              const SizedBox(height: 20),
              // Password field
              SpottiTextField(
                label: 'Пароль',
                controller: _passwordController,
                isPassword: true,
                helperText: '8–100 символів',
              ),
              const SizedBox(height: 32),
              // Register Button
              SpottiButton(
                text: 'Зареєструватися',
                type: SpottiButtonType.primary,
                onPressed: widget.onRegisterSuccess ?? () {},
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
    );
  }
}
