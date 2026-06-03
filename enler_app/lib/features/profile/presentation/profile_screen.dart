import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../data/profile_repository.dart';
import '../domain/profile_model.dart';
import '../domain/question_model.dart';

/// Profile view screen (Tab 2).
///
/// Shows the current user's emoji avatar with gradient ring,
/// stats, questions list, and action buttons.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Profile? _profile;
  List<Question> _questions = [];
  bool _showAnswers = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final profile = await ref.read(currentProfileProvider.future);
      List<Question> questions = [];
      if (profile != null) {
        final repo = ref.read(profileRepositoryProvider);
        questions = await repo.getQuestionsByProfileId(profile.id);
      }
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _questions = questions;
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Safe area spacer ───────────────────────────────────────
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.paddingOf(context).top + 16),
          ),

          // ── Header with avatar and info ────────────────────────────
          SliverToBoxAdapter(child: _buildHeader()),

          // ── Stats Row ──────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildStats()),

          // ── Action Buttons ─────────────────────────────────────────
          SliverToBoxAdapter(child: _buildActionButtons()),

          // ── Questions Section ──────────────────────────────────────
          SliverToBoxAdapter(child: _buildQuestionsHeader()),

          // ── Question List ──────────────────────────────────────────
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildQuestionTile(index),
              childCount: _questions.length,
            ),
          ),

          // ── Share Link Section ─────────────────────────────────────
          SliverToBoxAdapter(child: _buildShareSection()),

          // ── Bottom spacing ─────────────────────────────────────────
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  // ── Header ───────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 8),
        // Emoji avatar with gradient ring
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
          ),
          child: Container(
            width: 88,
            height: 88,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
            ),
            child: Center(
              child: Text(
                _profile?.avatarEmoji ?? '😊',
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _profile?.displayName ?? '',
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '@${_profile?.username ?? ''}',
          style: GoogleFonts.inter(
            fontSize: 15,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: 500.ms);
  }

  // ── Stats ────────────────────────────────────────────────────────────
  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              value: '${_profile?.questionCount ?? 0}',
              label: 'Soru',
              icon: Icons.quiz_outlined,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              value: '${_profile?.totalPlays ?? 0}',
              label: 'Çözen',
              icon: Icons.people_outline_rounded,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              value: '${_profile?.shareCount ?? 0}',
              label: 'Paylaşım',
              icon: Icons.share_outlined,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 100.ms)
        .slideY(begin: 0.05, end: 0, duration: 500.ms, delay: 100.ms);
  }

  // ── Action Buttons ───────────────────────────────────────────────────
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: _buildOutlinedBtn(
              icon: Icons.edit_outlined,
              label: 'Profili Düzenle',
              onTap: () => context.push(AppRoutes.profileEdit),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildGradientBtn(
              label: '➕ Soru Ekle',
              onTap: () => context.push(AppRoutes.questionAdd),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 200.ms);
  }

  Widget _buildOutlinedBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientBtn({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textOnPrimary,
          ),
        ),
      ),
    );
  }

  // ── Questions Header ─────────────────────────────────────────────────
  Widget _buildQuestionsHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Sorularım',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _showAnswers = !_showAnswers),
            child: Row(
              children: [
                Icon(
                  _showAnswers
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  _showAnswers ? 'Gizle' : 'Göster',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 300.ms);
  }

  // ── Question Tile ────────────────────────────────────────────────────
  Widget _buildQuestionTile(int index) {
    final question = _questions[index];
    // Extract emoji from category name or use default
    final emoji = question.category.contains('?') ? '❓' : '💬';

    return Dismissible(
      key: ValueKey('question_${question.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.fromLTRB(20, 4, 20, 4),
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.textOnPrimary),
      ),
      onDismissed: (_) async {
        final q = _questions.removeAt(index);
        setState(() {});
        try {
          final repo = ref.read(profileRepositoryProvider);
          await repo.deleteQuestion(q.id);
        } catch (_) {}
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 4, 20, 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
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
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.questionText,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  AnimatedCrossFade(
                    firstChild: Text(
                      '• • • • •',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textTertiary,
                        letterSpacing: 2,
                      ),
                    ),
                    secondChild: Text(
                      question.correctAnswer,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    crossFadeState: _showAnswers
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 200),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: (350 + index * 50).ms)
        .slideX(begin: 0.05, end: 0, duration: 400.ms, delay: (350 + index * 50).ms);
  }

  // ── Share Section ────────────────────────────────────────────────────
  Widget _buildShareSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              '🔗 Link\'ini arkadaşlarınla paylaş!',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textOnPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'enlerapp.com/${_profile?.username ?? ''}',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textOnPrimary.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                final username = _profile?.username ?? '';
                Share.share(
                  'Beni ne kadar tanıyorsun? 🤔 Test et: enlerapp.com/$username',
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Paylaş',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 600.ms)
        .slideY(begin: 0.05, end: 0, duration: 500.ms, delay: 600.ms);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Private Widgets
// ═══════════════════════════════════════════════════════════════════════════

/// Mini stat card for Questions / Plays / Shares.
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
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
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

