import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/badge_info.dart';
import '../../profile/data/profile_repository.dart';
import '../../profile/domain/profile_model.dart';
import '../data/quiz_repository.dart';
import '../domain/quiz_session_model.dart';

/// Result screen shown after completing a quiz.
///
/// Receives [sessionId] from the router and loads the completed session
/// from Supabase. Features animated percentage ring, badge display,
/// FOMO text, share buttons, and confetti for high scores.
class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen>
    with SingleTickerProviderStateMixin {
  QuizSession? _session;
  Profile? _owner;
  BadgeInfo? _badge;
  int _betterThanCount = 0;
  bool _isLoading = true;

  late AnimationController _ringController;
  late Animation<double> _ringAnimation;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _ringAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.easeOutCubic),
    );
    _loadResult();
  }

  Future<void> _loadResult() async {
    try {
      final quizRepo = ref.read(quizRepositoryProvider);
      final profileRepo = ref.read(profileRepositoryProvider);

      final session = await quizRepo.getSessionById(widget.sessionId);
      if (session == null || !mounted) return;

      final owner = await profileRepo.getProfileById(session.profileId);

      // Count how many people scored better
      final leaderboard = await quizRepo.getLeaderboard(session.profileId);
      int betterCount = 0;
      for (final s in leaderboard) {
        if (s.percentage > session.percentage) betterCount++;
      }

      final badge = BadgeInfo.fromPercentage(session.percentage);

      if (!mounted) return;
      setState(() {
        _session = session;
        _owner = owner;
        _badge = badge;
        _betterThanCount = betterCount;
        _isLoading = false;
      });

      // Update ring animation target
      _ringAnimation = Tween<double>(
        begin: 0,
        end: session.percentage / 100,
      ).animate(
        CurvedAnimation(parent: _ringController, curve: Curves.easeOutCubic),
      );

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _ringController.forward();
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _session == null || _badge == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    final session = _session!;
    final badge = _badge!;
    final isHighScore = session.percentage > 80;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // ── Back button ──────────────────────────────────────
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => context.go(AppRoutes.home),
                      child: Container(
                        width: 40,
                        height: 40,
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
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Owner emoji avatar ───────────────────────────────
                  _buildOwnerAvatar(badge)
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1, 1),
                        duration: 500.ms,
                      ),
                  const SizedBox(height: 24),

                  // ── Percentage ring ──────────────────────────────────
                  _buildPercentageRing(badge)
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 200.ms),
                  const SizedBox(height: 20),

                  // ── Badge pill ───────────────────────────────────────
                  _buildBadgePill(badge)
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 500.ms)
                      .slideY(
                          begin: 0.2, end: 0, duration: 500.ms, delay: 500.ms),
                  const SizedBox(height: 8),

                  // ── Slogan ───────────────────────────────────────────
                  Text(
                    badge.sloganTr,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 700.ms),
                  const SizedBox(height: 16),

                  // ── FOMO text ────────────────────────────────────────
                  if (_betterThanCount > 0)
                    Text(
                      'Senden daha iyi bilen: $_betterThanCount kişi var 😏',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 900.ms),
                  const SizedBox(height: 32),

                  // ── Share Story button ───────────────────────────────
                  _buildShareStoryButton(session, badge)
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 1100.ms)
                      .slideY(
                          begin: 0.1,
                          end: 0,
                          duration: 500.ms,
                          delay: 1100.ms),
                  const SizedBox(height: 12),

                  // ── Create yours button ──────────────────────────────
                  _buildCreateButton()
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 1200.ms)
                      .slideY(
                          begin: 0.1,
                          end: 0,
                          duration: 500.ms,
                          delay: 1200.ms),
                  const SizedBox(height: 32),

                  // ── Share card preview ───────────────────────────────
                  _buildShareCardPreview(session, badge)
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 1400.ms)
                      .slideY(
                          begin: 0.1,
                          end: 0,
                          duration: 600.ms,
                          delay: 1400.ms),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // ── Confetti for high scores ──────────────────────────────
          if (isHighScore) ..._buildConfettiParticles(),
        ],
      ),
    );
  }

  // ── Owner Avatar ─────────────────────────────────────────────────────
  Widget _buildOwnerAvatar(BadgeInfo badge) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: badge.color.withValues(alpha: 0.3),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
        ),
        Text(
          _owner?.avatarEmoji ?? '😊',
          style: const TextStyle(fontSize: 72),
        ),
      ],
    );
  }

  // ── Percentage Ring ──────────────────────────────────────────────────
  Widget _buildPercentageRing(BadgeInfo badge) {
    return SizedBox(
      width: 180,
      height: 180,
      child: AnimatedBuilder(
        animation: _ringAnimation,
        builder: (context, child) {
          final currentPercentage = (_ringAnimation.value * 100).round();
          return Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 180,
                height: 180,
                child: CustomPaint(
                  painter: _PercentageRingPainter(
                    progress: _ringAnimation.value,
                    color: badge.color,
                    backgroundColor: AppColors.surfaceAlt,
                    strokeWidth: 12,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '%$currentPercentage',
                    style: GoogleFonts.outfit(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Badge Pill ───────────────────────────────────────────────────────
  Widget _buildBadgePill(BadgeInfo badge) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: badge.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: badge.color.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Text(
        '${badge.nameTr} ${badge.emoji}',
        style: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: badge.color,
        ),
      ),
    );
  }

  // ── Share Story Button ───────────────────────────────────────────────
  Widget _buildShareStoryButton(QuizSession session, BadgeInfo badge) {
    return GestureDetector(
      onTap: () {
        final ownerName = _owner?.displayName ?? '';
        final username = _owner?.username ?? '';
        Share.share(
          '${badge.emoji} ${badge.nameTr}! '
          '$ownerName\'i %${session.percentage} tanıyorum! '
          'Sen de dene: enlerapp.com/$username',
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          '📸 Story\'de Paylaş',
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

  // ── Create Button ────────────────────────────────────────────────────
  Widget _buildCreateButton() {
    return GestureDetector(
      onTap: () => context.go(AppRoutes.auth),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary, width: 1.5),
        ),
        child: Text(
          '🚀 Sen de Oluştur!',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  // ── Share Card Preview ───────────────────────────────────────────────
  Widget _buildShareCardPreview(QuizSession session, BadgeInfo badge) {
    final ownerName = _owner?.displayName ?? '';
    final ownerEmoji = _owner?.avatarEmoji ?? '😊';
    final username = _owner?.username ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Paylaşım Kartı Önizleme',
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF6366F1),
                Color(0xFF8B5CF6),
                Color(0xFF7C3AED),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(ownerEmoji, style: const TextStyle(fontSize: 40)),
              const SizedBox(height: 8),
              Text(
                '$ownerName\'i ne kadar tanıyorum?',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textOnPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '%${session.percentage}',
                style: GoogleFonts.outfit(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textOnPrimary,
                ),
              ),
              Text(
                '${badge.nameTr} ${badge.emoji}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textOnPrimary.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'enlerapp.com/$username',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textOnPrimary.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Confetti Particles ───────────────────────────────────────────────
  List<Widget> _buildConfettiParticles() {
    final random = math.Random(42);
    const emojis = ['🎉', '✨', '🌟', '💫', '⭐', '🎊'];

    return List.generate(12, (index) {
      final left = random.nextDouble() * MediaQuery.sizeOf(context).width;
      final delay = random.nextInt(1000);
      final emoji = emojis[random.nextInt(emojis.length)];

      return Positioned(
        left: left,
        top: -30,
        child: IgnorePointer(
          child: Text(emoji, style: const TextStyle(fontSize: 24))
              .animate(
                onPlay: (controller) => controller.repeat(),
              )
              .moveY(
                begin: -30,
                end: MediaQuery.sizeOf(context).height + 30,
                duration:
                    Duration(milliseconds: 2500 + random.nextInt(1500)),
                delay: Duration(milliseconds: delay),
                curve: Curves.linear,
              )
              .fadeIn(duration: 300.ms, delay: Duration(milliseconds: delay))
              .then()
              .fadeOut(duration: 300.ms),
        ),
      );
    });
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Custom Painter
// ═══════════════════════════════════════════════════════════════════════════

/// Custom painter for the circular percentage ring.
class _PercentageRingPainter extends CustomPainter {
  const _PercentageRingPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background ring
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress ring
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _PercentageRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
