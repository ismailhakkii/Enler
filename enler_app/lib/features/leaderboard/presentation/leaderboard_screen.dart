import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_colors.dart';
import '../../profile/data/profile_repository.dart';
import '../../quiz/data/quiz_repository.dart';
import '../../quiz/domain/quiz_session_model.dart';
import '../../../shared/models/badge_info.dart';

/// Leaderboard screen (Tab 3).
///
/// Shows "Seni En İyi Tanıyanlar 🏆" with a top-3 podium display
/// and a scrollable ranked list below.
class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  List<QuizSession> _entries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final profile = await ref.read(currentProfileProvider.future);
      if (profile == null) return;
      final quizRepo = ref.read(quizRepositoryProvider);
      final sessions = await quizRepo.getLeaderboard(profile.id);
      if (!mounted) return;
      setState(() {
        _entries = sessions;
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'şimdi';
    if (diff.inMinutes < 60) return '${diff.inMinutes} dk önce';
    if (diff.inHours < 24) return '${diff.inHours} saat önce';
    return '${diff.inDays} gün önce';
  }

  @override
  Widget build(BuildContext context) {
    final hasEntries = _entries.isNotEmpty;

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
            if (_entries.length > 3)
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

            if (_entries.length > 3)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final realIndex = index + 3;
                    if (realIndex >= _entries.length) return null;
                    return _buildRankTile(realIndex);
                  },
                  childCount: _entries.length - 3,
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
    final first = _entries.isNotEmpty ? _entries[0] : null;
    final second = _entries.length > 1 ? _entries[1] : null;
    final third = _entries.length > 2 ? _entries[2] : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd place — left
          if (second != null)
            Expanded(
              child: _PodiumItem(
                session: second,
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
                session: first,
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
                session: third,
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
    final session = _entries[index];
    final rank = index + 1;
    final badge = BadgeInfo.fromPercentage(session.percentage);
    final timeAgo = _formatTimeAgo(session.completedAt ?? session.createdAt);

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
                  session.playerName,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(badge.emoji,
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text(
                      badge.nameTr,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: badge.color,
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
                '%${session.percentage}',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: badge.color,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 60,
                height: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: session.percentage / 100,
                    backgroundColor: AppColors.surfaceAlt,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(badge.color),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                timeAgo,
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
                Share.share(
                  'Beni ne kadar tanıyorsun? 🤔 Test et: enlerapp.com',
                );
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
    required this.session,
    required this.rank,
    required this.accentColor,
    required this.height,
  });

  final QuizSession session;
  final int rank;
  final Color accentColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final badge = BadgeInfo.fromPercentage(session.percentage);
    return Column(
      children: [
        // Badge emoji
        Text(badge.emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        // Name
        Text(
          session.playerName,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        // Percentage
        Text(
          '%${session.percentage}',
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

