import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/profile_model.dart';
import '../domain/question_model.dart';

part 'profile_repository.g.dart';

/// Repository for managing user profiles and their questions.
///
/// All queries specify explicit column selects — never `select('*')`.
/// Supabase returns snake_case keys which are converted to camelCase
/// before model deserialization.
class ProfileRepository {
  ProfileRepository({required SupabaseClient client}) : _client = client;

  final SupabaseClient _client;

  // ── Profile columns ──────────────────────────────────────────────────
  static const _profileColumns =
      'id, user_id, username, display_name, avatar_emoji, avatar_url, '
      'question_count, total_plays, share_count, created_at, updated_at';

  // ── Question columns ─────────────────────────────────────────────────
  static const _questionColumns =
      'id, profile_id, category, question_text, correct_answer, '
      'wrong_answers, order_index, is_ai_generated, created_at, updated_at';

  // ══════════════════════════════════════════════════════════════════════
  // Profile CRUD
  // ══════════════════════════════════════════════════════════════════════

  /// Fetches a profile by the authenticated user's Supabase UID.
  Future<Profile?> getProfileByUserId(String userId) async {
    final response = await _client
        .from('profiles')
        .select(_profileColumns)
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;
    return Profile.fromJson(_snakeToCamel(response));
  }

  /// Fetches a profile by its unique username.
  Future<Profile?> getProfileByUsername(String username) async {
    final response = await _client
        .from('profiles')
        .select(_profileColumns)
        .eq('username', username.toLowerCase())
        .maybeSingle();

    if (response == null) return null;
    return Profile.fromJson(_snakeToCamel(response));
  }

  /// Creates a new profile for the authenticated user.
  ///
  /// The [data] map should contain `user_id`, `username`,
  /// `display_name`, and optionally `avatar_emoji`.
  Future<Profile> createProfile(Map<String, dynamic> data) async {
    final response = await _client
        .from('profiles')
        .insert(data)
        .select(_profileColumns)
        .single();

    return Profile.fromJson(_snakeToCamel(response));
  }

  /// Updates an existing profile by [profileId].
  ///
  /// Only include the fields to be updated in [data].
  Future<Profile> updateProfile(
    String profileId,
    Map<String, dynamic> data,
  ) async {
    final response = await _client
        .from('profiles')
        .update(data)
        .eq('id', profileId)
        .select(_profileColumns)
        .single();

    return Profile.fromJson(_snakeToCamel(response));
  }

  /// Checks whether a [username] is available (case-insensitive).
  ///
  /// Returns `true` if no profile with the given username exists.
  Future<bool> isUsernameAvailable(String username) async {
    final response = await _client
        .from('profiles')
        .select('id')
        .eq('username', username.toLowerCase())
        .maybeSingle();

    return response == null;
  }

  /// Atomically increments the `share_count` column by 1.
  Future<void> incrementShareCount(String profileId) async {
    await _client.rpc('increment_share_count', params: {
      'profile_id': profileId,
    });
  }

  // ══════════════════════════════════════════════════════════════════════
  // Question CRUD
  // ══════════════════════════════════════════════════════════════════════

  /// Returns all questions for a given profile, ordered by [orderIndex].
  Future<List<Question>> getQuestionsByProfileId(String profileId) async {
    final response = await _client
        .from('questions')
        .select(_questionColumns)
        .eq('profile_id', profileId)
        .order('order_index', ascending: true);

    return (response as List)
        .map((row) => Question.fromJson(_snakeToCamel(row as Map<String, dynamic>)))
        .toList();
  }

  /// Inserts a new question linked to the given profile.
  ///
  /// The [data] map should contain `profile_id`, `category`,
  /// `question_text`, `correct_answer`, `wrong_answers`, etc.
  Future<Question> createQuestion(Map<String, dynamic> data) async {
    final response = await _client
        .from('questions')
        .insert(data)
        .select(_questionColumns)
        .single();

    return Question.fromJson(_snakeToCamel(response));
  }

  /// Deletes a question by its [questionId].
  Future<void> deleteQuestion(String questionId) async {
    await _client.from('questions').delete().eq('id', questionId);
  }

  // ══════════════════════════════════════════════════════════════════════
  // Helpers
  // ══════════════════════════════════════════════════════════════════════

  /// Converts a Supabase snake_case JSON map to camelCase keys
  /// for compatibility with Dart model `fromJson` factories.
  static Map<String, dynamic> _snakeToCamel(Map<String, dynamic> map) {
    return map.map((key, value) {
      final camelKey = key.replaceAllMapped(
        RegExp(r'_([a-z])'),
        (match) => match.group(1)!.toUpperCase(),
      );
      return MapEntry(camelKey, value);
    });
  }
}

// ── Riverpod Providers ──────────────────────────────────────────────────

/// Provides the singleton [ProfileRepository] instance.
@riverpod
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepository(client: SupabaseService.client);
}

/// Provides the current user's [Profile] reactively.
///
/// Returns `null` if the user is not authenticated or has no profile yet.
@riverpod
Future<Profile?> currentProfile(Ref ref) async {
  final userId = ref.watch(authRepositoryProvider).userId;
  if (userId == null) return null;

  final repo = ref.watch(profileRepositoryProvider);
  return repo.getProfileByUserId(userId);
}
