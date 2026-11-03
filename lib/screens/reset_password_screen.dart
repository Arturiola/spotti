import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/spotti_button.dart';
import '../widgets/spotti_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  final VoidCallback? onPasswordResetSuccess;
  final VoidCallback? onBackPressed;

  const ResetPasswordScreen({
    super.key,
    this.onPasswordResetSuccess,
    this.onBackPressed,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
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
                'Новий пароль',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Створіть новий пароль і введіть його двічі.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              // New Password
              SpottiTextField(
                label: 'Пароль',
                controller: _newPasswordController,
                isPassword: true,
                helperText: '8–100 символів',
              ),
              const SizedBox(height: 20),
              // Confirm Password
              SpottiTextField(
                label: 'Підтвердження нового пароля',
                controller: _confirmPasswordController,
                isPassword: true,
              ),
              const SizedBox(height: 32),
              // Update Password button
              SpottiButton(
                text: 'Оновити пароль',
                type: SpottiButtonType.primary,
                onPressed: widget.onPasswordResetSuccess ?? () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
