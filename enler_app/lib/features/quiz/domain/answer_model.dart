import 'package:freezed_annotation/freezed_annotation.dart';

part 'answer_model.freezed.dart';
part 'answer_model.g.dart';

/// A single answer submitted during a quiz session.
///
/// Maps to the `answers` table in Supabase. Links a session to a
/// question with the player's selected response and correctness.
@freezed
class Answer with _$Answer {
  const factory Answer({
    required String id,
    required String sessionId,
    required String questionId,
    required String selectedAnswer,
    required bool isCorrect,
    required DateTime answeredAt,
  }) = _Answer;

  factory Answer.fromJson(Map<String, dynamic> json) =>
      _$AnswerFromJson(json);
}
