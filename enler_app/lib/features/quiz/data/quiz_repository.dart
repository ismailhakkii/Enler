import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../domain/answer_model.dart';
import '../domain/quiz_session_model.dart';

part 'quiz_repository.g.dart';

/// Repository for managing quiz sessions and answers.
///
/// All queries specify explicit column selects — never `select('*')`.
/// Score calculation is delegated to the `calculate-score` Edge Function.
class QuizRepository {
  QuizRepository({required SupabaseClient client}) : _client = client;

  final SupabaseClient _client;

  // ── Session columns ──────────────────────────────────────────────────
  static const _sessionColumns =
      'id, profile_id, player_name, player_id, is_anonymous, '
      'total_questions, correct_answers, percentage, badge, '
      'started_at, completed_at, created_at';

  // ── Answer columns ───────────────────────────────────────────────────
  static const _answerColumns =
      'id, session_id, question_id, selected_answer, is_correct, answered_at';

  // ══════════════════════════════════════════════════════════════════════
  // Session management
  // ══════════════════════════════════════════════════════════════════════

  /// Creates a new quiz session for a player taking someone's quiz.
  ///
  /// [profileId] is the profile owner's ID (whose quiz is being taken).
  /// [playerName] is the display name entered by the quiz taker.
  /// [totalQuestions] is the number of questions in this session.
  /// [playerId] is optionally the authenticated user's ID if not anonymous.
  Future<QuizSession> createSession({
    required String profileId,
    required String playerName,
    required int totalQuestions,
    String? playerId,
  }) async {
    final data = {
      'profile_id': profileId,
      'player_name': playerName,
      'total_questions': totalQuestions,
      'is_anonymous': playerId == null,
      'started_at': DateTime.now().toUtc().toIso8601String(),
      if (playerId != null) 'player_id': playerId,
    };

    final response = await _client
        .from('quiz_sessions')
        .insert(data)
        .select(_sessionColumns)
        .single();

    return QuizSession.fromJson(_snakeToCamel(response));
  }

  /// Submits a single answer for a question within a session.
  Future<Answer> submitAnswer({
    required String sessionId,
    required String questionId,
    required String selectedAnswer,
    required bool isCorrect,
  }) async {
    final data = {
      'session_id': sessionId,
      'question_id': questionId,
      'selected_answer': selectedAnswer,
      'is_correct': isCorrect,
      'answered_at': DateTime.now().toUtc().toIso8601String(),
    };

    final response = await _client
        .from('answers')
        .insert(data)
        .select(_answerColumns)
        .single();

    return Answer.fromJson(_snakeToCamel(response));
  }

  /// Completes a quiz session by invoking the `calculate-score`
  /// Supabase Edge Function.
  ///
  /// The Edge Function calculates the final percentage, assigns
  /// the appropriate badge, and updates the session row.
  /// Returns the updated [QuizSession] with score and badge.
  Future<QuizSession> completeSession(String sessionId) async {
    final response = await _client.functions.invoke(
      'calculate-score',
      body: {'session_id': sessionId},
    );

    final data = response.data as Map<String, dynamic>;
    return QuizSession.fromJson(_snakeToCamel(data));
  }

  /// Fetches a single session by its [sessionId].
  Future<QuizSession?> getSessionById(String sessionId) async {
    final response = await _client
        .from('quiz_sessions')
        .select(_sessionColumns)
        .eq('id', sessionId)
        .maybeSingle();

    if (response == null) return null;
    return QuizSession.fromJson(_snakeToCamel(response));
  }

  // ══════════════════════════════════════════════════════════════════════
  // Leaderboard & history
  // ══════════════════════════════════════════════════════════════════════

  /// Returns all completed sessions for a profile, ordered by
  /// score percentage descending (leaderboard).
  Future<List<QuizSession>> getLeaderboard(String profileId) async {
    final response = await _client
        .from('quiz_sessions')
        .select(_sessionColumns)
        .eq('profile_id', profileId)
        .not('completed_at', 'is', null)
        .order('percentage', ascending: false);

    return (response as List)
        .map((row) =>
            QuizSession.fromJson(_snakeToCamel(row as Map<String, dynamic>)))
        .toList();
  }

  /// Returns the last [limit] completed sessions for a profile,
  /// ordered by completion time descending.
  Future<List<QuizSession>> getRecentSessions(
    String profileId, {
    int limit = 10,
  }) async {
    final response = await _client
        .from('quiz_sessions')
        .select(_sessionColumns)
        .eq('profile_id', profileId)
        .not('completed_at', 'is', null)
        .order('completed_at', ascending: false)
        .limit(limit);

    return (response as List)
        .map((row) =>
            QuizSession.fromJson(_snakeToCamel(row as Map<String, dynamic>)))
        .toList();
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

/// Provides the singleton [QuizRepository] instance.
@riverpod
QuizRepository quizRepository(Ref ref) {
  return QuizRepository(client: SupabaseService.client);
}

/// Provides the leaderboard for a given [profileId].
///
/// Returns a list of [QuizSession] sorted by percentage descending.
@riverpod
Future<List<QuizSession>> leaderboard(Ref ref, String profileId) async {
  final repo = ref.watch(quizRepositoryProvider);
  return repo.getLeaderboard(profileId);
}
