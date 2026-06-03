import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/data/auth_repository.dart';
import '../../profile/data/profile_repository.dart';

/// Animated splash screen shown during app initialization.
///
/// Displays the "EN." logo with a fade-in + scale animation,
/// then checks auth state after 2 seconds to navigate accordingly.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future<void>.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final user = ref.read(currentUserProvider);

    if (user == null) {
      if (mounted) context.go(AppRoutes.auth);
      return;
    }

    // User is logged in — check if profile exists
    final profileRepo = ref.read(profileRepositoryProvider);
    final profile = await profileRepo.getProfileByUserId(user.id);

    if (!mounted) return;

    if (profile != null) {
      context.go(AppRoutes.home);
    } else {
      context.go(AppRoutes.profileCreate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: _GradientLogo()
            .animate()
            .fadeIn(duration: 800.ms, curve: Curves.easeOut)
            .scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1.0, 1.0),
              duration: 800.ms,
              curve: Curves.easeOutBack,
            ),
      ),
    );
  }
}

/// The "EN." logo text rendered with an indigo-to-violet gradient.
class _GradientLogo extends StatelessWidget {
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
          fontSize: 72,
          fontWeight: FontWeight.w800,
          color: AppColors.textOnPrimary, // Masked by shader
          letterSpacing: -1,
        ),
      ),
    );
  }
}
