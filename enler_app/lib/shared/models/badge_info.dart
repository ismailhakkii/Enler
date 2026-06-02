import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Defines a friendship badge tier earned by quiz score percentage.
///
/// Each badge maps to a percentage range and carries a Turkish display
/// name, emoji, motivational slogan, and a color from the design system.
class BadgeInfo {
  const BadgeInfo({
    required this.key,
    required this.nameTr,
    required this.emoji,
    required this.sloganTr,
    required this.color,
    required this.minPercentage,
    required this.maxPercentage,
  });

  /// Unique identifier key (used in database and analytics).
  final String key;

  /// Turkish display name for the badge.
  final String nameTr;

  /// Emoji icon representing the badge.
  final String emoji;

  /// Turkish motivational slogan for the result screen.
  final String sloganTr;

  /// Theme color associated with this badge tier.
  final Color color;

  /// Minimum score percentage (inclusive) to earn this badge.
  final int minPercentage;

  /// Maximum score percentage (inclusive) for this badge.
  final int maxPercentage;

  /// All available badge tiers, ordered from lowest to highest.
  static const List<BadgeInfo> all = [
    BadgeInfo(
      key: 'stranger',
      nameTr: 'Yabancı',
      emoji: '👤',
      sloganTr: 'Tanışma vakti geldi!',
      color: AppColors.badgeStranger,
      minPercentage: 0,
      maxPercentage: 20,
    ),
    BadgeInfo(
      key: 'acquaintance',
      nameTr: 'Tanıdık',
      emoji: '🤝',
      sloganTr: 'Yolun başındasın!',
      color: AppColors.badgeAcquaintance,
      minPercentage: 21,
      maxPercentage: 40,
    ),
    BadgeInfo(
      key: 'friend',
      nameTr: 'Arkadaş',
      emoji: '😊',
      sloganTr: 'İyi bir arkadaşsın!',
      color: AppColors.badgeFriend,
      minPercentage: 41,
      maxPercentage: 60,
    ),
    BadgeInfo(
      key: 'close_friend',
      nameTr: 'Yakın Dost',
      emoji: '💜',
      sloganTr: 'Çok yakınsınız!',
      color: AppColors.badgeCloseFriend,
      minPercentage: 61,
      maxPercentage: 80,
    ),
    BadgeInfo(
      key: 'best_friend',
      nameTr: 'Kanka',
      emoji: '🔥',
      sloganTr: 'Gerçek bir kankasın!',
      color: AppColors.badgeBestFriend,
      minPercentage: 81,
      maxPercentage: 99,
    ),
    BadgeInfo(
      key: 'soulmate',
      nameTr: 'Ruh İkizi',
      emoji: '✨',
      sloganTr: 'Mükemmel! Ruh ikizlerisiniz!',
      color: AppColors.badgeSoulmate,
      minPercentage: 100,
      maxPercentage: 100,
    ),
  ];

  /// Finds a [BadgeInfo] by its unique [key].
  ///
  /// Returns `null` if no badge matches the given key.
  static BadgeInfo? fromKey(String key) {
    for (final badge in all) {
      if (badge.key == key) return badge;
    }
    return null;
  }

  /// Determines the badge earned for a given score [percentage].
  ///
  /// The percentage should be 0–100. Returns the matching badge tier.
  static BadgeInfo fromPercentage(int percentage) {
    for (final badge in all) {
      if (percentage >= badge.minPercentage &&
          percentage <= badge.maxPercentage) {
        return badge;
      }
    }
    // Fallback to the lowest badge if somehow out of range
    return all.first;
  }

  @override
  String toString() => 'BadgeInfo($key, $minPercentage-$maxPercentage%)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BadgeInfo &&
          runtimeType == other.runtimeType &&
          key == other.key;

  @override
  int get hashCode => key.hashCode;
}
