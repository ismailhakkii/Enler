import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';

/// Settings screen.
///
/// Shows user info, account settings, notifications, about section,
/// and danger zone (sign out / delete account).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  // ── Mock Data ──────────────────────────────────────────────────────────
  // TODO(riverpod): Replace with ref.watch(currentUserProvider)
  static const _mockDisplayName = 'Ahmet Yılmaz';
  static const _mockUsername = 'ahmet_yilmaz';
  static const _mockAvatarEmoji = '😎';
  static const _mockAppVersion = '0.1.0';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Ayarlar',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          // ── User Info Card ──────────────────────────────────────────
          _buildUserCard()
              .animate()
              .fadeIn(duration: 500.ms)
              .slideY(begin: 0.05, end: 0, duration: 500.ms),
          const SizedBox(height: 24),

          // ── Hesap (Account) ────────────────────────────────────────
          _buildSectionHeader('Hesap')
              .animate()
              .fadeIn(duration: 400.ms, delay: 100.ms),
          const SizedBox(height: 8),
          _buildSettingsGroup([
            _SettingsTile(
              icon: Icons.edit_outlined,
              iconColor: AppColors.primary,
              title: 'Profili Düzenle',
              onTap: () => context.push(AppRoutes.profileEdit),
            ),
            _SettingsTile(
              icon: Icons.emoji_emotions_outlined,
              iconColor: AppColors.warmAccent,
              title: 'Emoji Değiştir',
              trailing: const Text('😎', style: TextStyle(fontSize: 20)),
              onTap: () {
                // TODO(navigation): Navigate to emoji picker
              },
            ),
          ])
              .animate()
              .fadeIn(duration: 400.ms, delay: 150.ms),
          const SizedBox(height: 20),

          // ── Bildirimler (Notifications) ────────────────────────────
          _buildSectionHeader('Bildirimler')
              .animate()
              .fadeIn(duration: 400.ms, delay: 200.ms),
          const SizedBox(height: 8),
          _buildSettingsGroup([
            _SettingsToggleTile(
              icon: Icons.notifications_outlined,
              iconColor: AppColors.reward,
              title: 'Bildirimler',
              value: true,
              onChanged: (value) {
                // TODO(riverpod): ref.read(settingsProvider.notifier).setNotifications(value)
              },
            ),
          ])
              .animate()
              .fadeIn(duration: 400.ms, delay: 250.ms),
          const SizedBox(height: 20),

          // ── Hakkında (About) ───────────────────────────────────────
          _buildSectionHeader('Hakkında')
              .animate()
              .fadeIn(duration: 400.ms, delay: 300.ms),
          const SizedBox(height: 8),
          _buildSettingsGroup([
            _SettingsTile(
              icon: Icons.info_outline_rounded,
              iconColor: AppColors.primary,
              title: 'Versiyon',
              trailing: Text(
                _mockAppVersion,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textTertiary,
                ),
              ),
              onTap: null,
            ),
            _SettingsTile(
              icon: Icons.privacy_tip_outlined,
              iconColor: AppColors.secondary,
              title: 'Gizlilik Politikası',
              onTap: () {
                // TODO(url): Launch privacy policy URL
              },
            ),
            _SettingsTile(
              icon: Icons.description_outlined,
              iconColor: AppColors.secondary,
              title: 'Kullanım Şartları',
              onTap: () {
                // TODO(url): Launch terms of service URL
              },
            ),
          ])
              .animate()
              .fadeIn(duration: 400.ms, delay: 350.ms),
          const SizedBox(height: 20),

          // ── Tehlikeli Bölge (Danger Zone) ──────────────────────────
          _buildSectionHeader('Tehlikeli Bölge')
              .animate()
              .fadeIn(duration: 400.ms, delay: 400.ms),
          const SizedBox(height: 8),
          _buildSettingsGroup([
            _SettingsTile(
              icon: Icons.logout_rounded,
              iconColor: AppColors.textSecondary,
              title: 'Çıkış Yap',
              onTap: () => _showSignOutDialog(context, ref),
            ),
            _SettingsTile(
              icon: Icons.delete_forever_outlined,
              iconColor: AppColors.error,
              title: 'Hesabı Sil',
              titleColor: AppColors.error,
              onTap: () => _showDeleteAccountDialog(context, ref),
            ),
          ])
              .animate()
              .fadeIn(duration: 400.ms, delay: 450.ms),
        ],
      ),
    );
  }

  // ── User Info Card ───────────────────────────────────────────────────
  Widget _buildUserCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Emoji avatar
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceAlt,
            ),
            child: const Center(
              child: Text(_mockAvatarEmoji, style: TextStyle(fontSize: 32)),
            ),
          ),
          const SizedBox(width: 14),
          // Name + username
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _mockDisplayName,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '@$_mockUsername',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Section Header ───────────────────────────────────────────────────
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textTertiary,
        letterSpacing: 0.5,
      ),
    );
  }

  // ── Settings Group (card container) ──────────────────────────────────
  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              const Divider(
                height: 1,
                indent: 52,
                color: AppColors.borderLight,
              ),
          ],
        ],
      ),
    );
  }

  // ── Dialogs ──────────────────────────────────────────────────────────
  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Çıkış Yap',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Çıkış yapmak istediğine emin misin?',
          style: GoogleFonts.inter(
            fontSize: 15,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'İptal',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // TODO(riverpod): ref.read(authProvider.notifier).signOut()
            },
            child: Text(
              'Çıkış Yap',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: AppColors.error, size: 24),
            const SizedBox(width: 8),
            Text(
              'Hesabı Sil',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
          ],
        ),
        content: Text(
          'Hesabını silmek istediğine emin misin? Bu işlem geri alınamaz. '
          'Tüm soruların, quiz sonuçların ve profil bilgilerin kalıcı olarak silinecek.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'İptal',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // TODO(riverpod): ref.read(authProvider.notifier).deleteAccount()
            },
            child: Text(
              'Hesabı Sil',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Private Widgets
// ═══════════════════════════════════════════════════════════════════════════

/// Settings list tile with icon, title, and optional trailing widget.
class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.trailing,
    this.titleColor,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final Color? titleColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: titleColor ?? AppColors.textPrimary,
                ),
              ),
            ),
            if (trailing != null)
              trailing!
            else if (onTap != null)
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textTertiary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

/// Settings toggle tile with switch.
class _SettingsToggleTile extends StatefulWidget {
  const _SettingsToggleTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  State<_SettingsToggleTile> createState() => _SettingsToggleTileState();
}

class _SettingsToggleTileState extends State<_SettingsToggleTile> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: widget.iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(widget.icon, size: 18, color: widget.iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.title,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Switch.adaptive(
            value: _value,
            onChanged: (val) {
              setState(() => _value = val);
              widget.onChanged(val);
            },
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
