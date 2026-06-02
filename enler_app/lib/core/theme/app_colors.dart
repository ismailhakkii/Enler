import 'package:flutter/material.dart';

/// Soft Aurora color palette for the Enler app.
///
/// All colors follow the design system documented in DESIGN_SYSTEM.md.
/// Use these constants instead of hardcoding hex values.
sealed class AppColors {
  // ── Background ──────────────────────────────────────────────────────
  static const background = Color(0xFFFAFAF8);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFF5F5F4);

  // ── Primary ─────────────────────────────────────────────────────────
  static const primary = Color(0xFF6366F1); // Indigo
  static const primaryLight = Color(0xFF818CF8);
  static const primaryDark = Color(0xFF4F46E5);

  // ── Secondary ───────────────────────────────────────────────────────
  static const secondary = Color(0xFF8B5CF6); // Violet
  static const secondaryLight = Color(0xFFA78BFA);

  // ── Accents ─────────────────────────────────────────────────────────
  static const warmAccent = Color(0xFFF472B6); // Coral pink
  static const reward = Color(0xFFF59E0B); // Amber
  static const success = Color(0xFF10B981); // Green
  static const error = Color(0xFFEF4444); // Red
  static const warning = Color(0xFFF59E0B); // Amber (same as reward)

  // ── Text ────────────────────────────────────────────────────────────
  static const textPrimary = Color(0xFF1C1917);
  static const textSecondary = Color(0xFF78716C);
  static const textTertiary = Color(0xFFA8A29E);
  static const textOnPrimary = Color(0xFFFFFFFF);

  // ── Borders & Shadows ───────────────────────────────────────────────
  static const border = Color(0xFFE7E5E4);
  static const borderLight = Color(0xFFF5F5F4);
  static const shadow = Color(0x0F000000); // rgba(0,0,0,0.06)

  // ── Gradient for share cards ────────────────────────────────────────
  static const gradientStart = Color(0xFF6366F1); // Indigo
  static const gradientEnd = Color(0xFF8B5CF6); // Violet

  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );

  // ── Badge colors (friendship levels) ────────────────────────────────
  static const badgeStranger = Color(0xFF78716C);
  static const badgeAcquaintance = Color(0xFF6366F1);
  static const badgeFriend = Color(0xFF8B5CF6);
  static const badgeCloseFriend = Color(0xFFF472B6);
  static const badgeBestFriend = Color(0xFFF59E0B);
  static const badgeSoulmate = Color(0xFFEF4444);
}
