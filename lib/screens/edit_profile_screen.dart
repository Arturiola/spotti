import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/spotti_button.dart';
import '../widgets/spotti_text_field.dart';
import '../repositories/auth_repository.dart';
import '../utils/validators.dart';
import '../widgets/app_feedback.dart';
import '../services/analytics_service.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthRepository();
  bool _busy = false;
  late TextEditingController _urlController;

  Future<void> _save() async {
    if (_busy || !_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      await _auth.updateProfile(
        name: _nameController.text.trim(),
        photoUrl: _urlController.text.trim(),
      );
      if (!mounted) return;
      showAppMessage(context, 'Профіль оновлено');
      widget.onSavePressed?.call();
      try { await AnalyticsService.profileUpdated(); } catch (_) {}
    } catch (error) {
      if (mounted) showAppError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _choosePhoto() async {
    String pendingUrl = _urlController.text;
    final url = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Фото профілю'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Вставте HTTPS-посилання на зображення. Файл у Firebase Storage не завантажується.'),
            TextFormField(initialValue: pendingUrl, keyboardType: TextInputType.url,
                onChanged: (value) => pendingUrl = value,
                decoration: const InputDecoration(hintText: 'https://example.com/photo.jpg')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Скасувати')),
          TextButton(onPressed: () => Navigator.pop(dialogContext, pendingUrl.trim()), child: const Text('Обрати')),
        ],
      ),
    );
    if (!mounted || url == null) return;
    final error = InputValidators.httpsImageUrl(url);
    if (error != null) { showAppMessage(context, error); return; }
    setState(() => _urlController.text = url);
  }

  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _auth.currentUser?.displayName ?? '');
    _urlController = TextEditingController(text: _auth.currentUser?.photoURL ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
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
          child: Form(
            key: _formKey,
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
                              child: (_urlController.text.isNotEmpty
                                  ? Image.network(_urlController.text,
                                width: 96,
                                height: 96,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 60, color: AppColors.primary),
                              )
                                  : Image.asset('assets/images/avatar_edit.png', width: 96, height: 96,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 60, color: AppColors.primary))),
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
                        onPressed: _busy ? null : _choosePhoto,
                        icon: const Icon(Icons.upload_file, color: AppColors.primary, size: 18),
                        label: const Text(
                          'Змінити фото (HTTPS)',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Text(
                        'Вставте HTTPS-посилання на зображення',
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
                  validator: InputValidators.name,
                  helperText:
                  '1–100 символів або пробіли, дефіси, апострофи. Ім’я не може бути порожнім.',
                ),
                const SizedBox(height: 36),

                // Action Buttons
                SpottiButton(
                  text: _busy ? 'Збереження...' : 'Зберегти',
                  type: SpottiButtonType.primary,
                  onPressed: _busy ? null : _save,
                ),
                const SizedBox(height: 12),
                SpottiButton(
                  text: 'Скасувати',
                  type: SpottiButtonType.secondary,
                  onPressed: _busy ? null : widget.onCancelPressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
