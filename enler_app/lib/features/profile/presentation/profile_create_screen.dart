import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';

/// Profile creation onboarding screen (Step 1 of the entry flow).
///
/// Collects username, display name, and emoji avatar before the user
/// proceeds to add their quiz questions.
class ProfileCreateScreen extends ConsumerStatefulWidget {
  const ProfileCreateScreen({super.key});

  @override
  ConsumerState<ProfileCreateScreen> createState() =>
      _ProfileCreateScreenState();
}

class _ProfileCreateScreenState extends ConsumerState<ProfileCreateScreen> {
  final _usernameController = TextEditingController();
  final _displayNameController = TextEditingController();
  Timer? _debounce;

  // ── Local state ──────────────────────────────────────────────────────
  int _currentStep = 0; // 0 = info, 1 = avatar
  bool _isCheckingUsername = false;
  bool? _isUsernameAvailable;
  List<String> _selectedEmojis = [];
  int _selectedCategoryIndex = 0;

  // ── Emoji data ───────────────────────────────────────────────────────
  static const _emojiCategories = [
    _EmojiCategory(
      label: 'Yüzler', // TODO: localize
      icon: '😊',
      emojis: [
        '😊', '😎', '🤩', '😇', '🥳', '😏', '🤗', '🫠',
        '🤓', '😜', '🥹', '😈', '🤪', '🫡', '😴', '🤑',
        '🧐', '😤', '🥶', '🤠', '👻', '🤖', '👽', '💀',
      ],
    ),
    _EmojiCategory(
      label: 'Hayvanlar', // TODO: localize
      icon: '🐱',
      emojis: [
        '🐱', '🐶', '🦊', '🐻', '🐼', '🦁', '🐸', '🦋',
        '🦄', '🐙', '🦈', '🐧', '🦉', '🐝', '🐬', '🦜',
        '🐨', '🦩', '🐺', '🦧', '🐢', '🦎', '🐍', '🦚',
      ],
    ),
    _EmojiCategory(
      label: 'Müzik', // TODO: localize
      icon: '🎸',
      emojis: [
        '🎸', '🎹', '🎤', '🎵', '🎶', '🎷', '🥁', '🎺',
        '🎻', '🪕', '🎧', '🪗', '📻', '🎼', '🪘', '🔊',
      ],
    ),
    _EmojiCategory(
      label: 'Spor', // TODO: localize
      icon: '⚽',
      emojis: [
        '⚽', '🏀', '🎾', '🏈', '⚾', '🏐', '🏓', '🥊',
        '🎯', '🏊', '🚴', '🏋️', '⛷️', '🤸', '🧗', '🏄',
        '🎳', '🥅', '🏆', '🥇', '🏅', '🎖️', '🏇', '🤺',
      ],
    ),
    _EmojiCategory(
      label: 'Yemek', // TODO: localize
      icon: '🍕',
      emojis: [
        '🍕', '🍔', '🌮', '🍣', '🍦', '🍰', '🧁', '🍩',
        '☕', '🍿', '🥐', '🍜', '🌯', '🥗', '🍪', '🧋',
        '🍫', '🍇', '🍓', '🥑', '🌶️', '🍱', '🥨', '🧀',
      ],
    ),
    _EmojiCategory(
      label: 'Semboller', // TODO: localize
      icon: '🌟',
      emojis: [
        '🌟', '⭐', '💫', '✨', '🔥', '💎', '🌈', '☀️',
        '🌙', '⚡', '💜', '💙', '❤️', '💚', '🖤', '💛',
        '🦷', '👑', '🎭', '🪄', '🧿', '🫧', '🎪', '🎨',
      ],
    ),
  ];

  @override
  void dispose() {
    _usernameController.dispose();
    _displayNameController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onUsernameChanged(String value) {
    _debounce?.cancel();
    setState(() {
      _isUsernameAvailable = null;
      _isCheckingUsername = value.length >= 3;
    });

    if (value.length < 3) return;

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _checkUsernameAvailability(value);
    });
  }

  Future<void> _checkUsernameAvailability(String username) async {
    if (!mounted) return;
    setState(() => _isCheckingUsername = true);

    // TODO: Replace with actual Supabase username check
    // final available = await ref.read(
    //   checkUsernameProvider(username).future,
    // );
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final available = true; // Simulated result

    if (!mounted) return;
    setState(() {
      _isCheckingUsername = false;
      _isUsernameAvailable = available;
    });
  }

  void _toggleEmoji(String emoji) {
    setState(() {
      if (_selectedEmojis.contains(emoji)) {
        _selectedEmojis.remove(emoji);
      } else if (_selectedEmojis.length < 3) {
        _selectedEmojis = [..._selectedEmojis, emoji];
      }
    });
  }

  bool get _canProceed {
    if (_currentStep == 0) {
      return _usernameController.text.length >= 3 &&
          _isUsernameAvailable == true &&
          _displayNameController.text.trim().isNotEmpty;
    }
    return _selectedEmojis.isNotEmpty;
  }

  void _onContinue() {
    if (_currentStep == 0) {
      setState(() => _currentStep = 1);
      return;
    }

    // TODO: Save profile via Riverpod provider
    // ref.read(profileControllerProvider.notifier).createProfile(
    //   username: _usernameController.text,
    //   displayName: _displayNameController.text,
    //   emojiAvatar: _selectedEmojis.join(),
    // );
    context.go(AppRoutes.questionAdd);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Profilini Oluştur', // TODO: localize
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => setState(() => _currentStep = 0),
              )
            : null,
      ),
      body: Column(
        children: [
          // ── Step indicator ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            child: _StepIndicator(currentStep: _currentStep),
          ),

          // ── Content ───────────────────────────────────────────────
          Expanded(
            child: AnimatedSwitcher(
              duration: 300.ms,
              child: _currentStep == 0
                  ? _InfoStep(
                      key: const ValueKey('info'),
                      usernameController: _usernameController,
                      displayNameController: _displayNameController,
                      isCheckingUsername: _isCheckingUsername,
                      isUsernameAvailable: _isUsernameAvailable,
                      onUsernameChanged: _onUsernameChanged,
                    )
                  : _AvatarStep(
                      key: const ValueKey('avatar'),
                      selectedEmojis: _selectedEmojis,
                      selectedCategoryIndex: _selectedCategoryIndex,
                      onCategoryChanged: (i) =>
                          setState(() => _selectedCategoryIndex = i),
                      onEmojiToggled: _toggleEmoji,
                      categories: _emojiCategories,
                    ),
            ),
          ),

          // ── Continue button ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: _PrimaryGradientButton(
              label: _currentStep == 0
                  ? 'Devam Et' // TODO: localize
                  : 'Devam Et', // TODO: localize
              enabled: _canProceed,
              onTap: _onContinue,
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.15, end: 0, duration: 400.ms),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 1: Username + Display Name
// ─────────────────────────────────────────────────────────────────────────────

class _InfoStep extends StatelessWidget {
  const _InfoStep({
    super.key,
    required this.usernameController,
    required this.displayNameController,
    required this.isCheckingUsername,
    required this.isUsernameAvailable,
    required this.onUsernameChanged,
  });

  final TextEditingController usernameController;
  final TextEditingController displayNameController;
  final bool isCheckingUsername;
  final bool? isUsernameAvailable;
  final ValueChanged<String> onUsernameChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Username field
          Text(
            'Kullanıcı Adı', // TODO: localize
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideX(begin: -0.1, end: 0, duration: 400.ms),

          const SizedBox(height: 8),

          TextField(
            controller: usernameController,
            onChanged: onUsernameChanged,
            decoration: InputDecoration(
              prefixText: '@ ',
              prefixStyle: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              hintText: 'kullanici_adi', // TODO: localize
              suffixIcon: _buildUsernameSuffix(),
            ),
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          )
              .animate()
              .fadeIn(delay: 100.ms, duration: 400.ms)
              .slideY(begin: 0.1, end: 0, duration: 400.ms),

          const SizedBox(height: 24),

          // Display name field
          Text(
            'Görünen Ad', // TODO: localize
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 400.ms)
              .slideX(begin: -0.1, end: 0, duration: 400.ms),

          const SizedBox(height: 8),

          TextField(
            controller: displayNameController,
            decoration: InputDecoration(
              hintText: 'Adın Soyadın', // TODO: localize
            ),
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
            textCapitalization: TextCapitalization.words,
          )
              .animate()
              .fadeIn(delay: 300.ms, duration: 400.ms)
              .slideY(begin: 0.1, end: 0, duration: 400.ms),
        ],
      ),
    );
  }

  Widget? _buildUsernameSuffix() {
    if (isCheckingUsername) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      );
    }

    if (isUsernameAvailable == null) return null;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Icon(
        isUsernameAvailable! ? Icons.check_circle_rounded : Icons.cancel_rounded,
        color: isUsernameAvailable! ? AppColors.success : AppColors.error,
        size: 22,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 2: Emoji Avatar Picker
// ─────────────────────────────────────────────────────────────────────────────

class _AvatarStep extends StatelessWidget {
  const _AvatarStep({
    super.key,
    required this.selectedEmojis,
    required this.selectedCategoryIndex,
    required this.onCategoryChanged,
    required this.onEmojiToggled,
    required this.categories,
  });

  final List<String> selectedEmojis;
  final int selectedCategoryIndex;
  final ValueChanged<int> onCategoryChanged;
  final ValueChanged<String> onEmojiToggled;
  final List<_EmojiCategory> categories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 8),

          // ── Avatar preview ────────────────────────────────────────
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: Center(
              child: Text(
                selectedEmojis.isEmpty ? '?' : selectedEmojis.join(),
                style: TextStyle(
                  fontSize: selectedEmojis.length > 2 ? 24 : 36,
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.0, 1.0),
                duration: 400.ms,
              ),

          const SizedBox(height: 4),

          Text(
            '1-3 emoji seç', // TODO: localize
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textTertiary,
            ),
          ),

          const SizedBox(height: 16),

          // ── Category tabs ─────────────────────────────────────────
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = index == selectedCategoryIndex;
                return GestureDetector(
                  onTap: () => onCategoryChanged(index),
                  child: AnimatedContainer(
                    duration: 200.ms,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: isSelected
                          ? null
                          : Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(cat.icon, style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 4),
                        Text(
                          cat.label,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.textOnPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
              .animate()
              .fadeIn(delay: 100.ms, duration: 400.ms),

          const SizedBox(height: 16),

          // ── Emoji grid ────────────────────────────────────────────
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: categories[selectedCategoryIndex].emojis.length,
              itemBuilder: (context, index) {
                final emoji =
                    categories[selectedCategoryIndex].emojis[index];
                final isSelected = selectedEmojis.contains(emoji);
                return GestureDetector(
                  onTap: () => onEmojiToggled(emoji),
                  child: AnimatedContainer(
                    duration: 200.ms,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.12)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.borderLight,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(
                      delay: (index * 30).ms,
                      duration: 300.ms,
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared Widgets
// ─────────────────────────────────────────────────────────────────────────────

/// Two-step progress dots indicator.
class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < 2; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          AnimatedContainer(
            duration: 300.ms,
            width: i == currentStep ? 28 : 10,
            height: 10,
            decoration: BoxDecoration(
              color: i <= currentStep
                  ? AppColors.primary
                  : AppColors.border,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ],
    );
  }
}

/// Full-width button with the indigo-violet gradient.
class _PrimaryGradientButton extends StatelessWidget {
  const _PrimaryGradientButton({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: AnimatedOpacity(
        duration: 200.ms,
        opacity: enabled ? 1.0 : 0.45,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              if (enabled)
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: enabled ? onTap : null,
              borderRadius: BorderRadius.circular(12),
              child: Center(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Data class for emoji category tabs.
class _EmojiCategory {
  const _EmojiCategory({
    required this.label,
    required this.icon,
    required this.emojis,
  });

  final String label;
  final String icon;
  final List<String> emojis;
}
