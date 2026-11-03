import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/spotti_button.dart';
import '../widgets/spotti_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final VoidCallback? onSendInstructionPressed;
  final VoidCallback? onBackPressed;

  const ForgotPasswordScreen({
    super.key,
    this.onSendInstructionPressed,
    this.onBackPressed,
  });

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
                'Відновлення пароля',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ми надішлемо посилання для скидання пароля.',
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
              const SizedBox(height: 32),
              // Send Instruction button
              SpottiButton(
                text: 'Надіслати інструкцію',
                type: SpottiButtonType.primary,
                onPressed: widget.onSendInstructionPressed ?? () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
