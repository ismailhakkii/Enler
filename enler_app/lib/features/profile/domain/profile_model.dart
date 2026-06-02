import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

/// Represents a user's public profile in Enler.
///
/// Maps to the `profiles` table in Supabase. Contains display
/// information and aggregate counters for questions, plays, and shares.
@freezed
class Profile with _$Profile {
  const factory Profile({
    required String id,
    required String userId,
    required String username,
    required String displayName,
    @Default('😊') String avatarEmoji,
    String? avatarUrl,
    @Default(0) int questionCount,
    @Default(0) int totalPlays,
    @Default(0) int shareCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
