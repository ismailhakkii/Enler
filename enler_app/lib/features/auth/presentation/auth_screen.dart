import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';

/// Welcome / login screen.
///
/// Displays the brand logo, tagline, animated emoji, and auth options
/// (Google, Apple, Guest) following the Soft Aurora design language.
class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Decorative gradient blobs ─────────────────────────────
          const _AuroraDecoration(),

          // ── Main content ──────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Logo
                  const _GradientLogo()
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: -0.2, end: 0, duration: 600.ms),

                  const SizedBox(height: 12),

                  // Tagline
                  Text(
                    'Arkadaşını Ne Kadar Tanıyorsun?', // TODO: localize
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 600.ms)
                      .slideY(begin: 0.15, end: 0, duration: 600.ms),

                  const Spacer(),

                  // Animated emoji
                  const _FloatingEmoji()
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 600.ms),

                  const Spacer(),

                  // ── Auth buttons ──────────────────────────────────
                  _AuthButton(
                    label: 'Google ile Giriş Yap', // TODO: localize
                    icon: Icons.g_mobiledata_rounded,
                    backgroundColor: AppColors.surface,
                    foregroundColor: AppColors.textPrimary,
                    shadow: true,
                    onTap: () {
                      // TODO: Call Google sign-in provider
                      // ref.read(authControllerProvider.notifier).signInWithGoogle();
                      context.go(AppRoutes.profileCreate);
                    },
                  )
                      .animate()
                      .fadeIn(delay: 500.ms, duration: 500.ms)
                      .slideY(begin: 0.2, end: 0, duration: 500.ms),

                  const SizedBox(height: 12),

                  _AuthButton(
                    label: 'Apple ile Giriş Yap', // TODO: localize
                    icon: Icons.apple_rounded,
                    backgroundColor: AppColors.textPrimary,
                    foregroundColor: AppColors.textOnPrimary,
                    onTap: () {
                      // TODO: Call Apple sign-in provider
                      // ref.read(authControllerProvider.notifier).signInWithApple();
                      context.go(AppRoutes.profileCreate);
                    },
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 500.ms)
                      .slideY(begin: 0.2, end: 0, duration: 500.ms),

                  const SizedBox(height: 20),

                  // Divider with "veya"
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(color: AppColors.border),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'veya', // TODO: localize
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: AppColors.border),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(delay: 700.ms, duration: 500.ms),

                  const SizedBox(height: 20),

                  // Guest button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Call anonymous sign-in provider
                        // ref.read(authControllerProvider.notifier).signInAnonymously();
                        context.go(AppRoutes.profileCreate);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Misafir Olarak Devam Et', // TODO: localize
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 800.ms, duration: 500.ms)
                      .slideY(begin: 0.2, end: 0, duration: 500.ms),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private Widgets
// ─────────────────────────────────────────────────────────────────────────────

/// Gradient "EN." logo matching the splash screen branding.
class _GradientLogo extends StatelessWidget {
  const _GradientLogo();

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [AppColors.gradientStart, AppColors.gradientEnd],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      blendMode: BlendMode.srcIn,
      child: Text(
        'EN.', // Brand mark — not localized
        style: GoogleFonts.outfit(
          fontSize: 56,
          fontWeight: FontWeight.w800,
          color: AppColors.textOnPrimary,
          letterSpacing: -1,
        ),
      ),
    );
  }
}

/// Three emoji floating/bouncing subtly to add life to the welcome screen.
class _FloatingEmoji extends StatelessWidget {
  const _FloatingEmoji();

  static const _emojis = ['🎬', '🍕', '🎵'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < _emojis.length; i++) ...[
          if (i > 0) const SizedBox(width: 24),
          Text(
            _emojis[i],
            style: const TextStyle(fontSize: 48),
          )
              .animate(
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              .moveY(
                begin: 0,
                end: -12,
                delay: (i * 300).ms,
                duration: 1200.ms,
                curve: Curves.easeInOut,
              ),
        ],
      ],
    );
  }
}

/// Decorative blurred gradient circles in the background corners.
class _AuroraDecoration extends StatelessWidget {
  const _AuroraDecoration();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top-right blob
        Positioned(
          top: -60,
          right: -40,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.gradientStart.withValues(alpha: 0.12),
                  AppColors.gradientStart.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),

        // Bottom-left blob
        Positioned(
          bottom: -40,
          left: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.gradientEnd.withValues(alpha: 0.10),
                  AppColors.gradientEnd.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),

        // Middle-left small accent
        Positioned(
          top: MediaQuery.sizeOf(context).height * 0.35,
          left: -20,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.warmAccent.withValues(alpha: 0.08),
                  AppColors.warmAccent.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Reusable auth button with icon, label, and optional shadow.
class _AuthButton extends StatelessWidget {
  const _AuthButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
    this.shadow = false,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool shadow;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        elevation: shadow ? 1 : 0,
        shadowColor: AppColors.shadow,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: foregroundColor, size: 24),
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: foregroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
