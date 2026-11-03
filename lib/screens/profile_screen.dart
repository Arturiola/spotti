import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/spotti_bottom_nav.dart';
import '../widgets/spotti_button.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onEditProfilePressed;
  final VoidCallback? onChangePasswordPressed;
  final VoidCallback? onLogoutPressed;
  final VoidCallback? onDeleteAccountPressed;
  final Function(int)? onNavTap;

  const ProfileScreen({
    super.key,
    this.onEditProfilePressed,
    this.onChangePasswordPressed,
    this.onLogoutPressed,
    this.onDeleteAccountPressed,
    this.onNavTap,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentNavIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Профіль'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                children: [
                  // User Profile Header Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.primaryContainer,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/avatar.png',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.person,
                                size: 50,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Семенишин Артур',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'sem_artur@gmail.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SpottiButton(
                          text: 'Редагувати профіль',
                          type: SpottiButtonType.secondary,
                          icon: Icons.edit_outlined,
                          onPressed: widget.onEditProfilePressed ?? () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Personal Data & Settings Section
                  const Text(
                    'Особисті дані',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      children: [
                        _buildSettingsTile(
                          icon: Icons.person_outline,
                          title: 'Ім’я та фото профілю',
                          onTap: widget.onEditProfilePressed,
                        ),
                        const Divider(height: 1, indent: 56),
                        _buildSettingsTile(
                          icon: Icons.lock_outline,
                          title: 'Змінити пароль',
                          onTap: widget.onChangePasswordPressed,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // App Settings Section
                  const Text(
                    'Налаштування додатку',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      children: [
                        _buildSettingsTile(
                          icon: Icons.palette_outlined,
                          title: 'Тема оформления',
                          trailingText: 'Системна',
                          onTap: () {},
                        ),
                        const Divider(height: 1, indent: 56),
                        _buildSettingsTile(
                          icon: Icons.language_outlined,
                          title: 'Мова',
                          trailingText: 'Системна',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Actions Section (Logout / Delete Account)
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      children: [
                        _buildSettingsTile(
                          icon: Icons.logout,
                          title: 'Вийти',
                          titleColor: AppColors.primary,
                          iconColor: AppColors.primary,
                          showChevron: false,
                          onTap: widget.onLogoutPressed,
                        ),
                        const Divider(height: 1, indent: 56),
                        _buildSettingsTile(
                          icon: Icons.delete_outline,
                          title: 'Видалити обліковий запис',
                          titleColor: AppColors.error,
                          iconColor: AppColors.error,
                          showChevron: false,
                          onTap: widget.onDeleteAccountPressed,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Bottom Navigation Bar
            SpottiBottomNav(
              currentIndex: _currentNavIndex,
              onTap: (index) {
                setState(() {
                  _currentNavIndex = index;
                });
                if (widget.onNavTap != null) {
                  widget.onNavTap!(index);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? trailingText,
    Color? titleColor,
    Color? iconColor,
    bool showChevron = true,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor ?? AppColors.textSecondary),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: titleColor ?? AppColors.textPrimary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null) ...[
            Text(
              trailingText,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 6),
          ],
          if (showChevron)
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
        ],
      ),
    );
  }
}
