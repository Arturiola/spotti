import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'start_screen.dart';
import 'register_screen.dart';
import 'email_sent_screen.dart';
import 'login_screen.dart';
import 'forgot_password_screen.dart';
import 'reset_password_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';

enum ScreenType {
  start('FR 4.1.1 · Старт'),
  register('FR 4.1.1 · Реєстрація'),
  emailSent('FR 4.1.1 · Лист із посиланням'),
  login('FR 4.1.2 · Вхід'),
  forgotPassword('FR 4.1.3 · Відновлення пароля'),
  resetPassword('FR 4.1.3 · Новий пароль'),
  home('FR 4.1.5 + 4.1.13 · Головна'),
  profile('FR 4.1.10 · Профіль Артура'),
  editProfile('FR 4.1.10 · Редагувати ім’я та аватар'),
  changePassword('FR 4.1.11 · Зміна пароля');

  final String title;
  const ScreenType(this.title);
}

class ScreenNavigator extends StatefulWidget {
  const ScreenNavigator({super.key});

  @override
  State<ScreenNavigator> createState() => _ScreenNavigatorState();
}

class _ScreenNavigatorState extends State<ScreenNavigator> {
  ScreenType _currentScreen = ScreenType.start;

  void _navigateTo(ScreenType screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Current Screen View
          _buildCurrentScreen(),

          // Floating Screen Picker Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 6,
            right: 12,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _showScreenSelector,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.layers, color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        _currentScreen.title.split('·').last.trim(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_drop_down, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentScreen) {
      case ScreenType.start:
        return StartScreen(
          onLoginPressed: () => _navigateTo(ScreenType.login),
          onRegisterPressed: () => _navigateTo(ScreenType.register),
        );

      case ScreenType.register:
        return RegisterScreen(
          onRegisterSuccess: () => _navigateTo(ScreenType.emailSent),
          onLoginPressed: () => _navigateTo(ScreenType.login),
          onBackPressed: () => _navigateTo(ScreenType.start),
        );

      case ScreenType.emailSent:
        return EmailSentScreen(
          onLoginPressed: () => _navigateTo(ScreenType.login),
          onBackPressed: () => _navigateTo(ScreenType.register),
        );

      case ScreenType.login:
        return LoginScreen(
          onLoginSuccess: () => _navigateTo(ScreenType.home),
          onForgotPasswordPressed: () => _navigateTo(ScreenType.forgotPassword),
          onRegisterPressed: () => _navigateTo(ScreenType.register),
          onBackPressed: () => _navigateTo(ScreenType.start),
        );

      case ScreenType.forgotPassword:
        return ForgotPasswordScreen(
          onSendInstructionPressed: () => _navigateTo(ScreenType.resetPassword),
          onBackPressed: () => _navigateTo(ScreenType.login),
        );

      case ScreenType.resetPassword:
        return ResetPasswordScreen(
          onPasswordResetSuccess: () => _navigateTo(ScreenType.login),
          onBackPressed: () => _navigateTo(ScreenType.forgotPassword),
        );

      case ScreenType.home:
        return HomeScreen(
          onNavTap: (index) {
            if (index == 3) {
              _navigateTo(ScreenType.profile);
            }
          },
          onCreateReviewPressed: () {},
        );

      case ScreenType.profile:
        return ProfileScreen(
          onEditProfilePressed: () => _navigateTo(ScreenType.editProfile),
          onChangePasswordPressed: () => _navigateTo(ScreenType.changePassword),
          onLogoutPressed: () => _navigateTo(ScreenType.start),
          onDeleteAccountPressed: () => _navigateTo(ScreenType.start),
          onNavTap: (index) {
            if (index == 0) {
              _navigateTo(ScreenType.home);
            }
          },
        );

      case ScreenType.editProfile:
        return EditProfileScreen(
          onSavePressed: () => _navigateTo(ScreenType.profile),
          onCancelPressed: () => _navigateTo(ScreenType.profile),
          onBackPressed: () => _navigateTo(ScreenType.profile),
        );

      case ScreenType.changePassword:
        return ChangePasswordScreen(
          onChangePasswordSuccess: () => _navigateTo(ScreenType.profile),
          onBackPressed: () => _navigateTo(ScreenType.profile),
        );
    }
  }

  void _showScreenSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Оберіть екран для перегляду',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: ScreenType.values.length,
                    itemBuilder: (context, index) {
                      final screen = ScreenType.values[index];
                      final isSelected = screen == _currentScreen;
                      return ListTile(
                        dense: true,
                        leading: Icon(
                          isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                          color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        ),
                        title: Text(
                          screen.title,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? AppColors.primary : AppColors.textPrimary,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _navigateTo(screen);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
