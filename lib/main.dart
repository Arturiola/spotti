import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/screen_navigator.dart';

void main() {
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
