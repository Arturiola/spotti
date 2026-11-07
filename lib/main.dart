import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'screens/screen_navigator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const SpottiApp());
}

class SpottiApp extends StatelessWidget {
  const SpottiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotti',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const ScreenNavigator(),
    );
  }
}