import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../../core/theme/app_colors.dart';
import '../../profile/data/profile_repository.dart';
import '../../profile/domain/profile_model.dart';
import '../../profile/domain/question_model.dart';
import '../data/quiz_repository.dart';

/// Quiz solving screen.
///
/// Receives a [profileId] and [playerName] via [GoRouterState.extra].
/// Loads questions for the profile owner, creates a quiz session,
/// and lets the player answer questions one at a time.
class QuizSolveScreen extends ConsumerStatefulWidget {
  const QuizSolveScreen({
    super.key,
    required this.profileId,
    required this.playerName,
  });

  final String profileId;
  final String playerName;

  @override
  ConsumerState<QuizSolveScreen> createState() => _QuizSolveScreenState();
}

class _QuizSolveScreenState extends ConsumerState<QuizSolveScreen> {
  Profile? _owner;
  List<Question> _questions = [];
  String? _sessionId;

  int _currentIndex = 0;
  int _correctCount = 0;
  String? _selectedAnswer;
  bool _isAnswered = false;
  bool _isLoading = true;
  List<String> _shuffledOptions = [];

  @override
  void initState() {
    super.initState();
    _initQuiz();
  }

  Future<void> _initQuiz() async {
    try {
      final profileRepo = ref.read(profileRepositoryProvider);
      final quizRepo = ref.read(quizRepositoryProvider);

      // Load owner profile
      final owner = await profileRepo.getProfileById(widget.profileId);
      if (owner == null || !mounted) return;

      // Load questions
      final questions = await profileRepo.getQuestionsByProfileId(owner.id);
      if (questions.isEmpty || !mounted) return;

      // Create quiz session
      final session = await quizRepo.createSession(
        profileId: owner.id,
        playerName: widget.playerName,
        totalQuestions: questions.length,
      );

      if (!mounted) return;
      setState(() {
        _owner = owner;
        _questions = questions;
        _sessionId = session.id;
        _isLoading = false;
        _shuffledOptions = _buildShuffledOptions(questions[0]);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Quiz yüklenemedi: $e')),
        );
        context.pop();
      }
    }
  }

  List<String> _buildShuffledOptions(Question q) {
    final options = [q.correctAnswer, ...q.wrongAnswers];
    options.shuffle(Random());
    return options;
  }

  Future<void> _onAnswerSelected(String answer) async {
    if (_isAnswered) return;

    final question = _questions[_currentIndex];
    final isCorrect = answer == question.correctAnswer;

    setState(() {
      _selectedAnswer = answer;
      _isAnswered = true;
      if (isCorrect) _correctCount++;
    });

    // Submit answer to DB
    try {
      final quizRepo = ref.read(quizRepositoryProvider);
      await quizRepo.submitAnswer(
        sessionId: _sessionId!,
        questionId: question.id,
        selectedAnswer: answer,
        isCorrect: isCorrect,
      );
    } catch (_) {
      // Continue even if submit fails — we'll calculate score at the end
    }

    // Wait then advance
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _isAnswered = false;
        _shuffledOptions = _buildShuffledOptions(_questions[_currentIndex]);
      });
    } else {
      // Quiz complete — calculate score
      _completeQuiz();
    }
  }

  Future<void> _completeQuiz() async {
    try {
      final quizRepo = ref.read(quizRepositoryProvider);
      final result = await quizRepo.completeSession(_sessionId!);
      if (!mounted) return;
      context.go('/result/${result.id}');
    } catch (_) {
      // Fallback: navigate with the session ID anyway
      if (mounted) context.go('/result/$_sessionId');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 16),
              Text(
                'Quiz hazırlanıyor...',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // ── Header: progress + owner info ─────────────────────
              _buildHeader(progress),
              const SizedBox(height: 24),

              // ── Question card ─────────────────────────────────────
              _buildQuestionCard(question)
                  .animate(key: ValueKey(_currentIndex))
                  .fadeIn(duration: 400.ms)
                  .slideX(begin: 0.05, end: 0, duration: 400.ms),
              const SizedBox(height: 24),

              // ── Answer options ────────────────────────────────────
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _shuffledOptions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final option = _shuffledOptions[index];
                    return _buildOptionTile(option, question.correctAnswer, index)
                        .animate(key: ValueKey('${_currentIndex}_$index'))
                        .fadeIn(
                          duration: 300.ms,
                          delay: (100 + index * 80).ms,
                        )
                        .slideY(
                          begin: 0.08,
                          end: 0,
                          duration: 300.ms,
                          delay: (100 + index * 80).ms,
                        );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────
  Widget _buildHeader(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_owner?.displayName ?? ''} ${_owner?.avatarEmoji ?? ''}',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Soru ${_currentIndex + 1}/${_questions.length}',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Score so far
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '$_correctCount ✓',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.surfaceAlt,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  // ── Question Card ───────────────────────────────────────────────────
  Widget _buildQuestionCard(Question question) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            question.category,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            question.questionText,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  // ── Option Tile ─────────────────────────────────────────────────────
  Widget _buildOptionTile(String option, String correctAnswer, int index) {
    Color bgColor = AppColors.surface;
    Color borderColor = AppColors.borderLight;
    Color textColor = AppColors.textPrimary;
    IconData? trailingIcon;

    if (_isAnswered) {
      if (option == correctAnswer) {
        bgColor = AppColors.success.withValues(alpha: 0.1);
        borderColor = AppColors.success;
        textColor = AppColors.success;
        trailingIcon = Icons.check_circle_rounded;
      } else if (option == _selectedAnswer) {
        bgColor = AppColors.error.withValues(alpha: 0.1);
        borderColor = AppColors.error;
        textColor = AppColors.error;
        trailingIcon = Icons.cancel_rounded;
      }
    }

    return GestureDetector(
      onTap: () => _onAnswerSelected(option),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Option letter
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _isAnswered && option == _selectedAnswer
                    ? borderColor.withValues(alpha: 0.2)
                    : AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index), // A, B, C, D
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                option,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            if (trailingIcon != null)
              Icon(trailingIcon, color: borderColor, size: 22),
          ],
        ),
      ),
    );
  }
}
