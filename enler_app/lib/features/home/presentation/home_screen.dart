import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';

/// Main home screen shown after login.
///
/// Displays a greeting, profile summary card with share CTA,
/// recent quiz takers, and profile improvement suggestions.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // ── Mock Data ──────────────────────────────────────────────────────────
  // TODO(riverpod): Replace with ref.watch(currentUserProvider)
  static const _mockDisplayName = 'Ahmet';
  static const _mockAvatarEmoji = '😎';
  static const _mockUsername = 'ahmet_yilmaz';
  static const _mockQuestionCount = 7;
  static const _mockTotalPlays = 24;

  // TODO(riverpod): Replace with ref.watch(recentQuizTakersProvider)
  static final List<_MockRecentPlayer> _mockRecentPlayers = [
    _MockRecentPlayer('Elif', '💪', 87, '2 dk önce'),
    _MockRecentPlayer('Can', '😄', 60, '15 dk önce'),
    _MockRecentPlayer('Zeynep', '🕵️', 100, '1 saat önce'),
    _MockRecentPlayer('Mert', '😅', 30, '3 saat önce'),
  ];

  Future<void> _onRefresh() async {
    // TODO(riverpod): ref.invalidate(homeDataProvider)
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primary,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            // ── Safe area spacer ───────────────────────────────────────
            SliverToBoxAdapter(
              child: SizedBox(height: MediaQuery.paddingOf(context).top + 16),
            ),

            // ── Greeting ───────────────────────────────────────────────
            SliverToBoxAdapter(child: _buildGreeting()),

            // ── Profile Summary Card ───────────────────────────────────
            SliverToBoxAdapter(child: _buildProfileCard()),

            // ── Recent Quiz Takers ─────────────────────────────────────
            SliverToBoxAdapter(child: _buildRecentSection()),

            // ── Profile Improvement ────────────────────────────────────
            SliverToBoxAdapter(child: _buildImprovementSection()),

            // ── Bottom spacing ─────────────────────────────────────────
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  // ── Greeting ─────────────────────────────────────────────────────────
  Widget _buildGreeting() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Merhaba, $_mockDisplayName! $_mockAvatarEmoji',
        style: GoogleFonts.outfit(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideX(begin: -0.1, end: 0, duration: 500.ms);
  }

  // ── Profile Summary Card ─────────────────────────────────────────────
  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Large emoji avatar
          Text(
            _mockAvatarEmoji,
            style: const TextStyle(fontSize: 64),
          ),
          const SizedBox(height: 12),

          // Username
          Text(
            '@$_mockUsername',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$_mockQuestionCount soru',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '•',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
              Text(
                '$_mockTotalPlays kişi çözdü',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Share CTA button
          _GradientButton(
            label: '🔗 Link\'ini Paylaş!',
            onTap: () {
              // TODO(share): Implement share_plus link sharing
            },
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 100.ms)
        .slideY(begin: 0.05, end: 0, duration: 500.ms, delay: 100.ms);
  }

  // ── Recent Quiz Takers ───────────────────────────────────────────────
  Widget _buildRecentSection() {
    final hasPlayers = _mockRecentPlayers.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Son Çözenler',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          if (hasPlayers)
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _mockRecentPlayers.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final player = _mockRecentPlayers[index];
                  return _RecentPlayerCard(player: player);
                },
              ),
            )
          else
            _buildEmptyState(),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 200.ms)
        .slideY(begin: 0.05, end: 0, duration: 500.ms, delay: 200.ms);
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('🤷', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 8),
          Text(
            'Henüz kimse çözmemiş.\nLink\'ini paylaşarak başla!',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── Profile Improvement Section ──────────────────────────────────────
  Widget _buildImprovementSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profilini Geliştir',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          if (_mockQuestionCount < AppConstants.maxQuestions)
            _ImprovementCard(
              emoji: '➕',
              title: 'Yeni soru ekle',
              subtitle:
                  '$_mockQuestionCount/${AppConstants.maxQuestions} soru eklendi',
              onTap: () => context.push(AppRoutes.questionAdd),
            ),
          const SizedBox(height: 8),
          _ImprovementCard(
            emoji: '✏️',
            title: 'Profili düzenle',
            subtitle: 'Avatar, isim ve kullanıcı adını güncelle',
            onTap: () => context.push(AppRoutes.profileEdit),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 300.ms)
        .slideY(begin: 0.05, end: 0, duration: 500.ms, delay: 300.ms);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Private Widgets
// ═══════════════════════════════════════════════════════════════════════════

/// Gradient primary button used for CTA actions.
class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textOnPrimary,
          ),
        ),
      ),
    );
  }
}

/// Card showing a recent quiz taker with badge and percentage.
class _RecentPlayerCard extends StatelessWidget {
  const _RecentPlayerCard({required this.player});

  final _MockRecentPlayer player;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(player.badgeEmoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(
            player.name,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            '%${player.percentage}',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          Text(
            player.timeAgo,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Card for profile improvement actions.
class _ImprovementCard extends StatelessWidget {
  const _ImprovementCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Mock Data Model ──────────────────────────────────────────────────────

class _MockRecentPlayer {
  const _MockRecentPlayer(this.name, this.badgeEmoji, this.percentage, this.timeAgo);

  final String name;
  final String badgeEmoji;
  final int percentage;
  final String timeAgo;
}
