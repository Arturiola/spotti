import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/spotti_button.dart';
import '../widgets/spotti_text_field.dart';
import '../repositories/auth_repository.dart';
import '../utils/validators.dart';
import '../widgets/app_feedback.dart';


class ChangePasswordScreen extends StatefulWidget {
  final VoidCallback? onChangePasswordSuccess;
  final VoidCallback? onBackPressed;

  const ChangePasswordScreen({
    super.key,
    this.onChangePasswordSuccess,
    this.onBackPressed,
  });

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthRepository();
  bool _busy = false;

  Future<void> _changePassword() async {
    if (_busy || !_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      await _auth.changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );
      if (!mounted) return;
      showAppMessage(context, 'Пароль успішно змінено');
      widget.onChangePasswordSuccess?.call();
    } catch (error) {
      if (mounted) showAppError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBackPressed ?? () => Navigator.of(context).pop(),
        ),
        title: const Text('Зміна пароля'),
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
                  'Введіть поточний пароль і новий пароль двічі.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 28),
                // Current password
                SpottiTextField(
                  label: 'Поточний пароль',
                  controller: _currentPasswordController,
                  validator: InputValidators.requiredPassword,
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                // New password
                SpottiTextField(
                  label: 'Пароль',
                  controller: _newPasswordController,
                  validator: InputValidators.newPassword,
                  isPassword: true,
                  helperText: '8–100 символів',
                ),
                const SizedBox(height: 20),
                // Confirm new password
                SpottiTextField(
                  label: 'Підтвердження нового пароля',
                  controller: _confirmPasswordController,
                  validator: (value) => value == _newPasswordController.text ? null : 'Паролі не збігаються',
                  isPassword: true,
                ),
                const SizedBox(height: 32),
                // Submit button
                SpottiButton(
                  text: _busy ? 'Збереження...' : 'Змінити пароль',
                  type: SpottiButtonType.primary,
                  onPressed: _busy ? null : _changePassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
