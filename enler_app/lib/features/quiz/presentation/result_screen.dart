import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';

/// Result screen shown after completing a quiz.
///
/// Features animated percentage ring, badge display, FOMO text,
/// share buttons, and confetti for high scores.
class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen>
    with SingleTickerProviderStateMixin {
  // ── Mock Data ──────────────────────────────────────────────────────────
  // TODO(riverpod): Replace with ref.watch(quizResultProvider(sessionId))
  static const _mockOwnerEmoji = '😎';
  static const _mockOwnerName = 'Ahmet';
  static const _mockPercentage = 87;
  static const _mockBadgeEmoji = '💪';
  static const _mockBadgeName = 'Kanka';
  static const _mockBadgeSlogan = 'Neredeyse kankasın 👀';
  static const _mockBetterThanCount = 3;
  static final _mockBadgeColor = AppColors.badgeBestFriend;
  static const _mockUsername = 'ahmet_yilmaz';

  late AnimationController _ringController;
  late Animation<double> _ringAnimation;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _ringAnimation = Tween<double>(begin: 0, end: _mockPercentage / 100)
        .animate(CurvedAnimation(
      parent: _ringController,
      curve: Curves.easeOutCubic,
    ));

    // Delay start to let the screen build
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _ringController.forward();
    });
  }

  @override
  void dispose() {
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isHighScore = _mockPercentage > 80;

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
                      onTap: () => Navigator.of(context).maybePop(),
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
                  _buildOwnerAvatar()
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1, 1),
                        duration: 500.ms,
                      ),
                  const SizedBox(height: 24),

                  // ── Percentage ring ──────────────────────────────────
                  _buildPercentageRing()
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 200.ms),
                  const SizedBox(height: 20),

                  // ── Badge pill ───────────────────────────────────────
                  _buildBadgePill()
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 500.ms)
                      .slideY(begin: 0.2, end: 0, duration: 500.ms, delay: 500.ms),
                  const SizedBox(height: 8),

                  // ── Slogan ───────────────────────────────────────────
                  Text(
                    _mockBadgeSlogan,
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
                  Text(
                    'Senden daha iyi bilen: $_mockBetterThanCount kişi var 😏',
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
                  _buildShareStoryButton()
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 1100.ms)
                      .slideY(begin: 0.1, end: 0, duration: 500.ms, delay: 1100.ms),
                  const SizedBox(height: 12),

                  // ── Create yours button ──────────────────────────────
                  _buildCreateButton()
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 1200.ms)
                      .slideY(begin: 0.1, end: 0, duration: 500.ms, delay: 1200.ms),
                  const SizedBox(height: 32),

                  // ── Share card preview ───────────────────────────────
                  _buildShareCardPreview()
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 1400.ms)
                      .slideY(begin: 0.1, end: 0, duration: 600.ms, delay: 1400.ms),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // ── Confetti / particle animation for high scores ──────────
          if (isHighScore) ..._buildConfettiParticles(),
        ],
      ),
    );
  }

  // ── Owner Avatar ─────────────────────────────────────────────────────
  Widget _buildOwnerAvatar() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Blurred background glow
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _mockBadgeColor.withValues(alpha: 0.3),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
        ),
        // Emoji
        const Text(
          _mockOwnerEmoji,
          style: TextStyle(fontSize: 72),
        ),
      ],
    );
  }

  // ── Percentage Ring ──────────────────────────────────────────────────
  Widget _buildPercentageRing() {
    return SizedBox(
      width: 180,
      height: 180,
      child: AnimatedBuilder(
        animation: _ringAnimation,
        builder: (context, child) {
          final currentPercentage =
              (_ringAnimation.value * 100).round();
          return Stack(
            alignment: Alignment.center,
            children: [
              // Ring
              SizedBox(
                width: 180,
                height: 180,
                child: CustomPaint(
                  painter: _PercentageRingPainter(
                    progress: _ringAnimation.value,
                    color: _mockBadgeColor,
                    backgroundColor: AppColors.surfaceAlt,
                    strokeWidth: 12,
                  ),
                ),
              ),
              // Percentage text
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
  Widget _buildBadgePill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: _mockBadgeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _mockBadgeColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Text(
        '$_mockBadgeName $_mockBadgeEmoji',
        style: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: _mockBadgeColor,
        ),
      ),
    );
  }

  // ── Share Story Button ───────────────────────────────────────────────
  Widget _buildShareStoryButton() {
    return GestureDetector(
      onTap: () {
        // TODO(share): Implement story sharing
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
      onTap: () {
        // TODO(navigation): Navigate to profile creation flow
      },
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
  Widget _buildShareCardPreview() {
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
              const Text(_mockOwnerEmoji, style: TextStyle(fontSize: 40)),
              const SizedBox(height: 8),
              Text(
                '$_mockOwnerName\'i ne kadar tanıyorum?',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textOnPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '%$_mockPercentage',
                style: GoogleFonts.outfit(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textOnPrimary,
                ),
              ),
              Text(
                '$_mockBadgeName $_mockBadgeEmoji',
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
                  'enlerapp.com/$_mockUsername',
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
                duration: Duration(milliseconds: 2500 + random.nextInt(1500)),
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
