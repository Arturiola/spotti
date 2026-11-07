import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static Future<void> screen(String name) => _analytics.logScreenView(screenName: name);
  static Future<void> login() => _analytics.logLogin(loginMethod: 'email');
  static Future<void> signUp() => _analytics.logSignUp(signUpMethod: 'email');
  static Future<void> passwordResetRequested() =>
      _analytics.logEvent(name: 'password_reset_requested');
  static Future<void> profileUpdated() => _analytics.logEvent(name: 'profile_updated');
}
