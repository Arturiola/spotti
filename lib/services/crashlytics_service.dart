import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsService {
  /// A controlled, nonfatal test report, invoked manually from the debug-only UI.
  static Future<void> sendTestReport() => FirebaseCrashlytics.instance.recordError(
    StateError('Spotti Lab 4: test nonfatal error'),
    StackTrace.current,
    reason: 'Manual verification of Crashlytics integration',
    fatal: false,
  );
}
