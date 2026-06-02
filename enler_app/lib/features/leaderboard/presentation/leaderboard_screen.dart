import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';

/// Leaderboard screen (Tab 3).
///
/// Shows "Seni En İyi Tanıyanlar 🏆" with a top-3 podium display
/// and a scrollable ranked list below.
class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  // ── Mock Data ──────────────────────────────────────────────────────────
  // TODO(riverpod): Replace with ref.watch(leaderboardProvider)
  static final List<_MockLeaderboardEntry> _mockEntries = [
    _MockLeaderboardEntry('Zeynep', '🕵️', 'Stalker', 100, '1 saat önce', AppColors.badgeSoulmate),
    _MockLeaderboardEntry('Elif', '💪', 'Kanka', 87, '2 dk önce', AppColors.badgeBestFriend),
    _MockLeaderboardEntry('Mert', '🙌', 'Yakın Dost', 75, '5 saat önce', AppColors.badgeCloseFriend),
    _MockLeaderboardEntry('Can', '😄', 'Arkadaş', 60, '1 gün önce', AppColors.badgeFriend),
    _MockLeaderboardEntry('Ayşe', '😄', 'Arkadaş', 55, '2 gün önce', AppColors.badgeFriend),
    _MockLeaderboardEntry('Ali', '😅', 'Tanıdık', 40, '3 gün önce', AppColors.badgeAcquaintance),
    _MockLeaderboardEntry('Deniz', '😅', 'Tanıdık', 35, '4 gün önce', AppColors.badgeAcquaintance),
    _MockLeaderboardEntry('Selin', '🤔', 'Yabancı', 20, '1 hafta önce', AppColors.badgeStranger),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasEntries = _mockEntries.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Safe area spacer ───────────────────────────────────────
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.paddingOf(context).top + 16),
          ),

          // ── Title ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Seni En İyi Tanıyanlar 🏆',
                style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1, end: 0, duration: 500.ms),
          ),

          if (hasEntries) ...[
            // ── Podium ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: _buildPodium(),
            ),

            // ── Remaining list ─────────────────────────────────────
            if (_mockEntries.length > 3)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                  child: Text(
                    'Diğerleri',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ).animate().fadeIn(duration: 500.ms, delay: 400.ms),
              ),

            if (_mockEntries.length > 3)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final realIndex = index + 3;
                    if (realIndex >= _mockEntries.length) return null;
                    return _buildRankTile(realIndex);
                  },
                  childCount: _mockEntries.length - 3,
                ),
              ),
          ] else
            // ── Empty State ────────────────────────────────────────
            SliverFillRemaining(child: _buildEmptyState()),

          // ── Bottom spacing ─────────────────────────────────────────
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  // ── Podium ───────────────────────────────────────────────────────────
  Widget _buildPodium() {
    final first = _mockEntries.isNotEmpty ? _mockEntries[0] : null;
    final second = _mockEntries.length > 1 ? _mockEntries[1] : null;
    final third = _mockEntries.length > 2 ? _mockEntries[2] : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd place — left
          if (second != null)
            Expanded(
              child: _PodiumItem(
                entry: second,
                rank: 2,
                accentColor: const Color(0xFFC0C0C0), // Silver
                height: 120,
              ),
            )
          else
            const Expanded(child: SizedBox()),

          const SizedBox(width: 8),

          // 1st place — center, taller
          if (first != null)
            Expanded(
              child: _PodiumItem(
                entry: first,
                rank: 1,
                accentColor: AppColors.reward, // Gold
                height: 150,
              ),
            )
          else
            const Expanded(child: SizedBox()),

          const SizedBox(width: 8),

          // 3rd place — right
          if (third != null)
            Expanded(
              child: _PodiumItem(
                entry: third,
                rank: 3,
                accentColor: const Color(0xFFCD7F32), // Bronze
                height: 100,
              ),
            )
          else
            const Expanded(child: SizedBox()),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 150.ms)
        .slideY(begin: 0.08, end: 0, duration: 600.ms, delay: 150.ms);
  }

  // ── Rank Tile ────────────────────────────────────────────────────────
  Widget _buildRankTile(int index) {
    final entry = _mockEntries[index];
    final rank = index + 1;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 4, 20, 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank number
          SizedBox(
            width: 28,
            child: Text(
              '#$rank',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textTertiary,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Name + badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(entry.badgeEmoji,
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text(
                      entry.badgeName,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: entry.badgeColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Percentage with bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '%${entry.percentage}',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: entry.badgeColor,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 60,
                height: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: entry.percentage / 100,
                    backgroundColor: AppColors.surfaceAlt,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(entry.badgeColor),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                entry.timeAgo,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: (450 + (index - 3) * 60).ms)
        .slideX(begin: 0.05, end: 0, duration: 400.ms, delay: (450 + (index - 3) * 60).ms);
  }

  // ── Empty State ──────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🏆', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              'Henüz kimse çözmemiş',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Link\'ini paylaşarak arkadaşlarını davet et!',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                // TODO(share): Implement share_plus link sharing
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '🔗 Link\'ini Paylaş!',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Private Widgets
// ═══════════════════════════════════════════════════════════════════════════

/// A single podium item for top 3 display.
class _PodiumItem extends StatelessWidget {
  const _PodiumItem({
    required this.entry,
    required this.rank,
    required this.accentColor,
    required this.height,
  });

  final _MockLeaderboardEntry entry;
  final int rank;
  final Color accentColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Badge emoji
        Text(entry.badgeEmoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        // Name
        Text(
          entry.name,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        // Percentage
        Text(
          '%${entry.percentage}',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: accentColor,
          ),
        ),
        const SizedBox(height: 8),
        // Podium bar
        Container(
          height: height,
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.15),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border(
              top: BorderSide(color: accentColor, width: 3),
            ),
          ),
          child: Center(
            child: Text(
              '$rank',
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: accentColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Mock Data Model ──────────────────────────────────────────────────────

class _MockLeaderboardEntry {
  const _MockLeaderboardEntry(
    this.name,
    this.badgeEmoji,
    this.badgeName,
    this.percentage,
    this.timeAgo,
    this.badgeColor,
  );

  final String name;
  final String badgeEmoji;
  final String badgeName;
  final int percentage;
  final String timeAgo;
  final Color badgeColor;
}
