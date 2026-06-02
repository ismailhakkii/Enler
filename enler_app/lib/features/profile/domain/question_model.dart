import 'package:freezed_annotation/freezed_annotation.dart';

part 'question_model.freezed.dart';
part 'question_model.g.dart';

/// A quiz question belonging to a user's profile.
///
/// Maps to the `questions` table in Supabase. Each question has one
/// correct answer and a list of wrong alternatives (typically generated
/// by the Gemini AI).
@freezed
class Question with _$Question {
  const factory Question({
    required String id,
    required String profileId,
    required String category,
    required String questionText,
    required String correctAnswer,
    required List<String> wrongAnswers,
    @Default(0) int orderIndex,
    @Default(true) bool isAiGenerated,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}
