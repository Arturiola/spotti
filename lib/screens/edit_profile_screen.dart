import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/spotti_button.dart';
import '../widgets/spotti_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  final VoidCallback? onSavePressed;
  final VoidCallback? onCancelPressed;
  final VoidCallback? onBackPressed;

  const EditProfileScreen({
    super.key,
    this.onSavePressed,
    this.onCancelPressed,
    this.onBackPressed,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Семенишин Артур');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBackPressed ?? widget.onCancelPressed,
        ),
        title: const Text('Редагувати профіль'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar section
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: AppColors.primaryContainer,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/avatar_edit.png',
                              width: 96,
                              height: 96,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.person,
                                size: 60,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: AppColors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.upload_file, color: AppColors.primary, size: 18),
                      label: const Text(
                        'Завантажити фото',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Text(
                      'JPG/JPEG/PNG/WEBP < 5MB',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Name input field
              SpottiTextField(
                label: 'Ім’я',
                controller: _nameController,
                helperText:
                    '1–100 символів або пробіли, дефіси, апострофи. Ім’я не може бути порожнім.',
              ),
              const SizedBox(height: 36),

              // Action Buttons
              SpottiButton(
                text: 'Зберегти',
                type: SpottiButtonType.primary,
                onPressed: widget.onSavePressed ?? () {},
              ),
              const SizedBox(height: 12),
              SpottiButton(
                text: 'Скасувати',
                type: SpottiButtonType.secondary,
                onPressed: widget.onCancelPressed ?? () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
