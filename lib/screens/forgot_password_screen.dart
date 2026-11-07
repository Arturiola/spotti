import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/spotti_button.dart';
import '../widgets/spotti_text_field.dart';
import '../repositories/auth_repository.dart';
import '../utils/validators.dart';
import '../widgets/app_feedback.dart';
import '../services/analytics_service.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthRepository();
  bool _busy = false;

  Future<void> _sendReset() async {
    if (_busy || !_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      await _auth.sendPasswordReset(email: _emailController.text.trim());
      if (!mounted) return;
      showAppMessage(context, 'Якщо адреса зареєстрована, перевірте пошту для відновлення пароля.');
      widget.onSendInstructionPressed?.call();
      try { await AnalyticsService.passwordResetRequested(); } catch (_) {}
    } catch (error) {
      if (mounted) showAppError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

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
          child: Form(
            key: _formKey,
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
                  validator: InputValidators.email,
                  keyboardType: TextInputType.emailAddress,
                  hint: 'name@example.com',
                ),
                const SizedBox(height: 32),
                // Send Instruction button
                SpottiButton(
                  text: _busy ? 'Надсилання...' : 'Надіслати інструкцію',
                  type: SpottiButtonType.primary,
                  onPressed: _busy ? null : _sendReset,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
