import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';
import '../services/analytics_service.dart';
import '../widgets/app_feedback.dart';
import 'start_screen.dart';
import 'register_screen.dart';
import 'email_sent_screen.dart';
import 'login_screen.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';

enum ScreenType { start, register, emailSent, login, forgotPassword, home, profile, editProfile, changePassword }

class ScreenNavigator extends StatefulWidget {
  const ScreenNavigator({super.key});
  @override
  State<ScreenNavigator> createState() => _ScreenNavigatorState();
}

class _ScreenNavigatorState extends State<ScreenNavigator> {
  final AuthRepository _auth = AuthRepository();
  late final Stream<User?> _users;
  ScreenType _currentScreen = ScreenType.start;
  bool _loggedInitialScreen = false;

  @override
  void initState() {
    super.initState();
    _users = _auth.userChanges();
  }

  Future<void> _logScreen(String name) async {
    try { await AnalyticsService.screen(name); } catch (_) {}
  }

  void _navigateTo(ScreenType screen) {
    if (!mounted) return;
    setState(() => _currentScreen = screen);
    unawaited(_logScreen(screen.name));
  }

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      _navigateTo(ScreenType.start);
    } catch (error) {
      if (mounted) showAppError(context, error);
    }
  }

  Future<void> _deleteAccount() async {
    String pendingPassword = '';
    try {
      final password = await showDialog<String>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Видалення облікового запису'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Цю дію неможливо скасувати. Для підтвердження введіть поточний пароль.'),
              TextField(
                onChanged: (value) => pendingPassword = value,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Поточний пароль'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Скасувати')),
            TextButton(
              onPressed: () {
                if (pendingPassword.isNotEmpty) Navigator.pop(dialogContext, pendingPassword);
              },
              child: const Text('Видалити'),
            ),
          ],
        ),
      );
      if (password == null || !mounted) return;
      await _auth.deleteAccount(currentPassword: password);
      if (mounted) _navigateTo(ScreenType.start);
    } catch (error) {
      if (mounted) showAppError(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _users,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return const Scaffold(body: Center(child: Text('Не вдалося перевірити сеанс. Перезапустіть застосунок.')));
        }
        final user = snapshot.data;
        if (!_loggedInitialScreen) {
          _loggedInitialScreen = true;
          final initialScreen = user == null ? _currentScreen.name
              : user.emailVerified ? 'home' : 'emailSent';
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) unawaited(_logScreen(initialScreen));
          });
        }
        if (user == null) {
          // These screens are available without a Firebase session.
          switch (_currentScreen) {
            case ScreenType.register:
              return RegisterScreen(
                onRegisterSuccess: () => _navigateTo(ScreenType.emailSent),
                onLoginPressed: () => _navigateTo(ScreenType.login),
                onBackPressed: () => _navigateTo(ScreenType.start),
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
                // The password reset is finished using Firebase's email action link.
                onSendInstructionPressed: () {},
                onBackPressed: () => _navigateTo(ScreenType.login),
              );
            default:
              return StartScreen(
                onLoginPressed: () => _navigateTo(ScreenType.login),
                onRegisterPressed: () => _navigateTo(ScreenType.register),
              );
          }
        }

        if (!user.emailVerified) {
          // Never display privileged screens before email verification.
          return EmailSentScreen(
            onLoginPressed: () => _navigateTo(ScreenType.home),
            onBackPressed: _logout,
          );
        }

        // Authenticated and verified: only private screens can be displayed.
        switch (_currentScreen) {
          case ScreenType.profile:
            return ProfileScreen(
              onEditProfilePressed: () => _navigateTo(ScreenType.editProfile),
              onChangePasswordPressed: () => _navigateTo(ScreenType.changePassword),
              onLogoutPressed: _logout,
              onDeleteAccountPressed: _deleteAccount,
              onNavTap: (index) { if (index == 0) _navigateTo(ScreenType.home); },
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
          default:
            return HomeScreen(
              onNavTap: (index) {
                if (index == 3) _navigateTo(ScreenType.profile);
              },
              onCreateReviewPressed: () => showAppMessage(context, 'Створення відгуків буде додано в наступних лабораторних.'),
            );
        }
      },
    );
  }
}

