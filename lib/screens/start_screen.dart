import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/spotti_button.dart';

class StartScreen extends StatelessWidget {
  final VoidCallback? onLoginPressed;
  final VoidCallback? onRegisterPressed;

  const StartScreen({
    super.key,
    this.onLoginPressed,
    this.onRegisterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header logo
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Spotti',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Tagline
              const Text(
                'Зберігайте відгуки, фото та враження з улюблених закладів.',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
              ),
              const Spacer(),
              // Center illustration image
              Center(
                child: Image.asset(
                  'assets/images/start_hero.png',
                  height: 260,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.map_outlined,
                        size: 80,
                        color: AppColors.primary,
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              // Bottom Action Buttons
              SpottiButton(
                text: 'Увійти',
                type: SpottiButtonType.primary,
                onPressed: onLoginPressed ?? () {},
              ),
              const SizedBox(height: 12),
              SpottiButton(
                text: 'Зареєструватися',
                type: SpottiButtonType.secondary,
                onPressed: onRegisterPressed ?? () {},
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
