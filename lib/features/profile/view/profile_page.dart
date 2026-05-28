import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet/core/common/app_dialog.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';
import 'package:velvet/features/auth/controllers/auth_controller.dart';
import 'package:velvet/routes/routes_name.dart';

// ─────────────────────────────────────────────────────────
//  ProfilePage
//
//  • Avatar + name + email header
//  • Settings sections: Account, Preferences, Support
//  • Logout button
// ─────────────────────────────────────────────────────────

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AuthController>();
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppPallete.scaffold,
      appBar: AppBar(
        backgroundColor: AppPallete.scaffold,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text('Profile', style: AppTextStyle.s16w6()),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 8, 16, bottomPadding + 24),
        child: Column(
          children: [
            // ── User info header ──────────────────────────
            _ProfileHeader(controller: c),

            const SizedBox(height: 24),

            // ── Account section ───────────────────────────
            _SettingsSection(
              title: 'Account',
              items: [
                _SettingsItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Edit Profile',
                  onTap: () => Get.toNamed(RoutesName.editProfile),
                ),
                _SettingsItem(
                  icon: Icons.location_on_outlined,
                  label: 'Saved Addresses',
                  onTap: () => Get.toNamed(RoutesName.addresses),
                ),
                _SettingsItem(
                  icon: Icons.credit_card_outlined,
                  label: 'Payment Methods',
                  onTap: () => Get.toNamed(RoutesName.payments),
                ),
                _SettingsItem(
                  icon: Icons.local_shipping_outlined,
                  label: 'My Orders',
                  onTap: () => Get.toNamed(RoutesName.orders),
                  showBadge: true,
                  badgeCount: 2,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Preferences section ───────────────────────
            _SettingsSection(
              title: 'Preferences',
              items: [
                _SettingsItem(
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                  onTap: () => Get.toNamed(RoutesName.notifications),
                  trailing: _ToggleTrailing(),
                ),
                _SettingsItem(
                  icon: Icons.language_outlined,
                  label: 'Language',
                  onTap: () {},
                  subtitle: 'English',
                ),
                _SettingsItem(
                  icon: Icons.dark_mode_outlined,
                  label: 'Dark Mode',
                  onTap: () {},
                  trailing: _ToggleTrailing(),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Support section ───────────────────────────
            _SettingsSection(
              title: 'Support',
              items: [
                _SettingsItem(
                  icon: Icons.help_outline_rounded,
                  label: 'Help & FAQ',
                  onTap: () => Get.toNamed(RoutesName.help),
                ),
                _SettingsItem(
                  icon: Icons.privacy_tip_outlined,
                  label: 'Privacy Policy',
                  onTap: () => Get.toNamed(RoutesName.privacy),
                ),
                _SettingsItem(
                  icon: Icons.info_outline_rounded,
                  label: 'About velvet.',
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => const AppDialog(
                      type: DialogType.info,
                      title: 'About velvet.',
                      message:
                          'Velvet is a demo e-commerce app built with Flutter.',
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Logout button ─────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () => _showLogoutDialog(c),
                icon: const Icon(
                  Icons.logout_rounded,
                  color: AppPallete.error,
                  size: 18,
                ),
                label: Text(
                  'Log Out',
                  style: AppTextStyle.button(color: AppPallete.error),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppPallete.error, width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // App version
            Text(
              'velvet. v1.0.0',
              style: AppTextStyle.s10w4(color: AppPallete.extraAsh),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(AuthController c) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppPallete.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Log Out', style: AppTextStyle.s16w6()),
        content: Text(
          'Are you sure you want to log out?',
          style: AppTextStyle.s14w4(color: AppPallete.subTextColor),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              'Cancel',
              style: AppTextStyle.s14w6(color: AppPallete.subTextColor),
            ),
          ),
          TextButton(
            onPressed: () {
              c.logout();
            },
            child: Text(
              'Log Out',
              style: AppTextStyle.s14w6(color: AppPallete.error),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Profile Header
// ─────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  final AuthController controller;

  const _ProfileHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppPallete.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppPallete.primary.withValues(alpha: 0.12),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              Obx(
                () => CircleAvatar(
                  radius: 36,
                  backgroundColor: AppPallete.background,
                  backgroundImage: controller.user.value?.avatarUrl != null
                      ? NetworkImage(controller.user.value!.avatarUrl!)
                      : null,
                  child: controller.user.value?.avatarUrl == null
                      ? Icon(
                          Icons.person_rounded,
                          size: 36,
                          color: AppPallete.primary,
                        )
                      : null,
                ),
              ),
              // Edit avatar badge
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => Get.toNamed(RoutesName.editProfile),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppPallete.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppPallete.surface, width: 2),
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      size: 12,
                      color: AppPallete.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // Name + email
          Expanded(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.user.value?.name ?? 'Guest User',
                    style: AppTextStyle.s16w6(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.user.value?.email ?? '',
                    style: AppTextStyle.s12w4(color: AppPallete.subTextColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Member badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppPallete.background,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.diamond_outlined,
                          size: 12,
                          color: AppPallete.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Velvet Member',
                          style: AppTextStyle.s10w4(color: AppPallete.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Settings Section
// ─────────────────────────────────────────────────────────

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;

  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            title,
            style: AppTextStyle.s12w5(color: AppPallete.subTextColor),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppPallete.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppPallete.primary.withValues(alpha: 0.06),
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: List.generate(items.length, (i) {
              final isLast = i == items.length - 1;
              return Column(
                children: [
                  items[i],
                  if (!isLast)
                    Divider(color: AppPallete.stroke, height: 1, indent: 52),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Settings Item
// ─────────────────────────────────────────────────────────

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool showBadge;
  final int badgeCount;

  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
    this.trailing,
    this.showBadge = false,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppPallete.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: AppPallete.indigoNavy),
            ),

            const SizedBox(width: 14),

            // Label + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyle.s14w6().copyWith(
                      color: AppPallete.bodyText,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTextStyle.s12w4(color: AppPallete.subTextColor),
                    ),
                  ],
                ],
              ),
            ),

            // Badge or toggle or chevron
            if (showBadge && badgeCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppPallete.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$badgeCount',
                  style: AppTextStyle.s10w4(color: AppPallete.white),
                ),
              )
            else if (trailing != null)
              trailing!
            else
              const Icon(
                Icons.chevron_right_rounded,
                color: AppPallete.extraAsh,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Toggle trailing widget
// ─────────────────────────────────────────────────────────

class _ToggleTrailing extends StatefulWidget {
  @override
  State<_ToggleTrailing> createState() => _ToggleTrailingState();
}

class _ToggleTrailingState extends State<_ToggleTrailing> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.8,
      child: Switch(
        value: _value,
        onChanged: (v) => setState(() => _value = v),
        activeThumbColor: AppPallete.primary,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
