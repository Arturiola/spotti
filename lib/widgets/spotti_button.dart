import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum SpottiButtonType { primary, secondary, text, danger }

class SpottiButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final SpottiButtonType type;
  final IconData? icon;

  const SpottiButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = SpottiButtonType.primary,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case SpottiButtonType.primary:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 0,
          ),
          child: _buildChild(),
        );

      case SpottiButtonType.secondary:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.primaryContainer,
            foregroundColor: AppColors.onPrimaryContainer,
            minimumSize: const Size.fromHeight(52),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 0,
          ),
          child: _buildChild(),
        );

      case SpottiButtonType.text:
        return TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            minimumSize: const Size.fromHeight(48),
          ),
          child: _buildChild(),
        );

      case SpottiButtonType.danger:
        return TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.error,
            minimumSize: const Size.fromHeight(48),
          ),
          child: _buildChild(),
        );
    }
  }

  Widget _buildChild() {
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }
    return Text(text);
  }
}
