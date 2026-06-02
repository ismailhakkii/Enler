import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_session_model.freezed.dart';
part 'quiz_session_model.g.dart';

/// Represents a single quiz session (one player's attempt).
///
/// Maps to the `quiz_sessions` table in Supabase. Tracks the player,
/// their score, earned badge, and timing information.
@freezed
class QuizSession with _$QuizSession {
  const factory QuizSession({
    required String id,
    required String profileId,
    required String playerName,
    String? playerId,
    @Default(true) bool isAnonymous,
    required int totalQuestions,
    @Default(0) int correctAnswers,
    @Default(0) int percentage,
    String? badge,
    required DateTime startedAt,
    DateTime? completedAt,
    required DateTime createdAt,
  }) = _QuizSession;

  factory QuizSession.fromJson(Map<String, dynamic> json) =>
      _$QuizSessionFromJson(json);
}
