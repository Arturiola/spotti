import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/spotti_button.dart';

class EmailSentScreen extends StatefulWidget {
  final VoidCallback? onLoginPressed;
  final VoidCallback? onBackPressed;

  const EmailSentScreen({
    super.key,
    this.onLoginPressed,
    this.onBackPressed,
  });

  @override
  State<EmailSentScreen> createState() => _EmailSentScreenState();
}

class _EmailSentScreenState extends State<EmailSentScreen> {
  bool _resent = false;

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
              const SizedBox(height: 12),
              // Email icon card
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.mark_email_unread_outlined,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Перевірте пошту',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Інструкція надходить у листі від Spotti.\nЛист із посиланням підтвердження надіслано на вашу електронну пошту.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Перейдіть за посиланням у листі, щоб підтвердити електронну пошту.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 32),
              // Resent notification card
              if (_resent) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: AppColors.primary, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Лист надіслано повторно. Перевірте також спам.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.onPrimaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              // Resend Button
              SpottiButton(
                text: 'Повторно надіслати лист',
                type: SpottiButtonType.primary,
                onPressed: () {
                  setState(() {
                    _resent = true;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Go to login button
              SpottiButton(
                text: 'Перейти до входу',
                type: SpottiButtonType.secondary,
                onPressed: widget.onLoginPressed ?? () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
