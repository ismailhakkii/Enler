import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/supabase_service.dart';
import '../../auth/data/auth_repository.dart';
import '../../profile/data/profile_repository.dart';

/// Screen where users fill in their favorite answers for quiz categories.
///
/// Each category card can be tapped to open a bottom sheet for data entry.
/// AI-generated wrong answers are available via the Gemini integration.
class QuestionAddScreen extends ConsumerStatefulWidget {
  const QuestionAddScreen({super.key});

  @override
  ConsumerState<QuestionAddScreen> createState() => _QuestionAddScreenState();
}

class _QuestionAddScreenState extends ConsumerState<QuestionAddScreen> {
  /// Map of category index → user's answer.
  final Map<int, _QuestionAnswer> _answers = {};

  static const _minQuestions = 5;
  static const _totalCategories = 10;

  // ── Category definitions ─────────────────────────────────────────────
  static const _categories = [
    _QuizCategory(emoji: '🎬', question: 'En sevdiğin film?'),
    _QuizCategory(emoji: '🎵', question: 'En sevdiğin şarkı?'),
    _QuizCategory(emoji: '🍕', question: 'En sevdiğin yemek?'),
    _QuizCategory(emoji: '🌍', question: 'En çok gitmek istediğin ülke?'),
    _QuizCategory(emoji: '📚', question: 'En sevdiğin kitap?'),
    _QuizCategory(emoji: '⚽', question: 'En sevdiğin spor?'),
    _QuizCategory(emoji: '🎮', question: 'En sevdiğin oyun?'),
    _QuizCategory(emoji: '📺', question: 'En sevdiğin dizi?'),
    _QuizCategory(emoji: '🎨', question: 'En sevdiğin renk?'),
    _QuizCategory(emoji: '🐾', question: 'En sevdiğin hayvan?'),
  ];

  int get _answeredCount => _answers.length;
  bool get _canFinish => _answeredCount >= _minQuestions;

  void _openAnswerSheet(int categoryIndex) {
    final category = _categories[categoryIndex];
    final existing = _answers[categoryIndex];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AnswerBottomSheet(
        category: category,
        existingAnswer: existing,
        onSave: (answer) {
          setState(() => _answers[categoryIndex] = answer);
          Navigator.of(ctx).pop();
        },
      ),
    );
  }

  bool _isSaving = false;

  Future<void> _onFinish() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) {
        if (mounted) context.go(AppRoutes.home);
        return;
      }

      final profileRepo = ref.read(profileRepositoryProvider);
      final profile = await profileRepo.getProfileByUserId(user.id);
      if (profile == null || !mounted) return;

      // Save each answer as a question in Supabase
      for (final entry in _answers.entries) {
        final category = _categories[entry.key];
        final answer = entry.value;

        await profileRepo.createQuestion({
          'profile_id': profile.id,
          'category': category.question,
          'question_text': category.question,
          'correct_answer': answer.correctAnswer,
          'wrong_answers': answer.wrongAnswers,
          'order_index': entry.key,
          'is_ai_generated': true,
        });
      }

      ref.invalidate(currentProfileProvider);

      if (mounted) context.go(AppRoutes.home);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sorular kaydedilemedi: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sorularını Ekle', // TODO: localize
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$_answeredCount/$_totalCategories',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── Progress bar ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _answeredCount / _totalCategories,
                minHeight: 6,
                backgroundColor: AppColors.surfaceAlt,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),

          // ── Minimum indicator ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            child: Row(
              children: [
                Icon(
                  _canFinish
                      ? Icons.check_circle_rounded
                      : Icons.info_outline_rounded,
                  size: 16,
                  color:
                      _canFinish ? AppColors.success : AppColors.textTertiary,
                ),
                const SizedBox(width: 6),
                Text(
                  _canFinish
                      ? 'Harika! Profili tamamlayabilirsin.' // TODO: localize
                      : 'En az $_minQuestions soru yanıtla', // TODO: localize
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: _canFinish
                        ? AppColors.success
                        : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ── Category cards ────────────────────────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final answer = _answers[index];
                final isAnswered = answer != null;

                return _CategoryCard(
                  category: category,
                  answer: answer,
                  isAnswered: isAnswered,
                  onTap: () => _openAnswerSheet(index),
                )
                    .animate()
                    .fadeIn(
                      delay: (index * 60).ms,
                      duration: 400.ms,
                    )
                    .slideX(
                      begin: 0.05,
                      end: 0,
                      delay: (index * 60).ms,
                      duration: 400.ms,
                    );
              },
            ),
          ),

          // ── Finish button ─────────────────────────────────────────
          if (_canFinish)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              child: _PrimaryGradientButton(
                label: 'Profili Tamamla', // TODO: localize
                onTap: _onFinish,
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.2, end: 0, duration: 400.ms),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Category Card
// ─────────────────────────────────────────────────────────────────────────────

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.answer,
    required this.isAnswered,
    required this.onTap,
  });

  final _QuizCategory category;
  final _QuestionAnswer? answer;
  final bool isAnswered;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isAnswered ? AppColors.success.withValues(alpha: 0.3) : AppColors.borderLight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Emoji
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isAnswered
                      ? AppColors.success.withValues(alpha: 0.08)
                      : AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    category.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.question,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (isAnswered) ...[
                      const SizedBox(height: 2),
                      Text(
                        answer!.correctAnswer,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Status icon
              Icon(
                isAnswered
                    ? Icons.check_circle_rounded
                    : Icons.chevron_right_rounded,
                color: isAnswered ? AppColors.success : AppColors.textTertiary,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Answer Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _AnswerBottomSheet extends StatefulWidget {
  const _AnswerBottomSheet({
    required this.category,
    required this.onSave,
    this.existingAnswer,
  });

  final _QuizCategory category;
  final _QuestionAnswer? existingAnswer;
  final ValueChanged<_QuestionAnswer> onSave;

  @override
  State<_AnswerBottomSheet> createState() => _AnswerBottomSheetState();
}

class _AnswerBottomSheetState extends State<_AnswerBottomSheet> {
  late final TextEditingController _correctController;
  late final List<TextEditingController> _wrongControllers;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _correctController = TextEditingController(
      text: widget.existingAnswer?.correctAnswer ?? '',
    );
    _wrongControllers = List.generate(3, (i) {
      return TextEditingController(
        text: widget.existingAnswer != null &&
                i < widget.existingAnswer!.wrongAnswers.length
            ? widget.existingAnswer!.wrongAnswers[i]
            : '',
      );
    });
  }

  @override
  void dispose() {
    _correctController.dispose();
    for (final c in _wrongControllers) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _canSave =>
      _correctController.text.trim().isNotEmpty &&
      _wrongControllers.every((c) => c.text.trim().isNotEmpty);

  Future<void> _generateWithAI() async {
    if (_correctController.text.trim().isEmpty) return;

    setState(() => _isGenerating = true);

    try {
      // Call the generate-wrong-answers Edge Function
      final response = await SupabaseService.client.functions.invoke(
        'generate-wrong-answers',
        body: {
          'category': widget.category.question,
          'correct_answer': _correctController.text.trim(),
          'language': 'tr',
        },
      );

      if (!mounted) return;

      final data = response.data as Map<String, dynamic>?;
      final wrongAnswers = (data?['wrong_answers'] as List?)?.cast<String>() ?? ['Seçenek A', 'Seçenek B', 'Seçenek C'];

      setState(() {
        _isGenerating = false;
        for (int i = 0; i < 3 && i < wrongAnswers.length; i++) {
          _wrongControllers[i].text = wrongAnswers[i];
        }
      });
    } catch (e) {
      if (!mounted) return;
      // Fallback: simple placeholders
      setState(() {
        _isGenerating = false;
        _wrongControllers[0].text = 'Seçenek A';
        _wrongControllers[1].text = 'Seçenek B';
        _wrongControllers[2].text = 'Seçenek C';
      });
    }
  }

  void _onSave() {
    widget.onSave(
      _QuestionAnswer(
        correctAnswer: _correctController.text.trim(),
        wrongAnswers: _wrongControllers
            .map((c) => c.text.trim())
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      margin: const EdgeInsets.only(top: 60),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Category header
              Row(
                children: [
                  Text(
                    widget.category.emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.category.question,
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Correct answer
              Text(
                'Senin Cevabın', // TODO: localize
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _correctController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Cevabını yaz...', // TODO: localize
                ),
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 24),

              // Wrong answers header + AI button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Yanlış Şıklar', // TODO: localize
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  _AIGenerateButton(
                    isLoading: _isGenerating,
                    enabled: _correctController.text.trim().isNotEmpty,
                    onTap: _generateWithAI,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Wrong answer fields or shimmer loading
              if (_isGenerating)
                _buildShimmerFields()
              else
                Column(
                  children: [
                    for (int i = 0; i < 3; i++) ...[
                      if (i > 0) const SizedBox(height: 10),
                      TextField(
                        controller: _wrongControllers[i],
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: '${i + 1}. yanlış şık', // TODO: localize
                        ),
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ],
                ),

              const SizedBox(height: 24),

              // Save button
              _PrimaryGradientButton(
                label: 'Kaydet', // TODO: localize
                onTap: _canSave ? _onSave : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerFields() {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceAlt,
      highlightColor: AppColors.surface,
      child: Column(
        children: [
          for (int i = 0; i < 3; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AI Generate Button
// ─────────────────────────────────────────────────────────────────────────────

class _AIGenerateButton extends StatelessWidget {
  const _AIGenerateButton({
    required this.isLoading,
    required this.enabled,
    required this.onTap,
  });

  final bool isLoading;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled && !isLoading ? onTap : null,
      child: AnimatedOpacity(
        duration: 200.ms,
        opacity: enabled ? 1.0 : 0.4,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '✨',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 4),
              Text(
                isLoading
                    ? 'Üretiliyor...' // TODO: localize
                    : 'AI ile Üret', // TODO: localize
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textOnPrimary,
                ),
              ),
              if (isLoading) ...[
                const SizedBox(width: 6),
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Primary Gradient Button (shared)
// ─────────────────────────────────────────────────────────────────────────────

class _PrimaryGradientButton extends StatelessWidget {
  const _PrimaryGradientButton({
    required this.label,
    this.onTap,
  });

  final String label;
  final VoidCallback? onTap;

  bool get _enabled => onTap != null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: AnimatedOpacity(
        duration: 200.ms,
        opacity: _enabled ? 1.0 : 0.45,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              if (_enabled)
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Center(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data Models
// ─────────────────────────────────────────────────────────────────────────────

/// Represents a quiz category with its emoji and question text.
class _QuizCategory {
  const _QuizCategory({required this.emoji, required this.question});

  final String emoji;
  final String question; // TODO: localize all questions
}

/// Holds the user's answer and three wrong alternatives for a category.
class _QuestionAnswer {
  const _QuestionAnswer({
    required this.correctAnswer,
    required this.wrongAnswers,
  });

  final String correctAnswer;
  final List<String> wrongAnswers;
}
