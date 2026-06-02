import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Placeholder question-add screen (where users add their favorites).
class QuestionAddScreen extends ConsumerWidget {
  const QuestionAddScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Center(
        child: Text('Question Add Screen'),
      ),
    );
  }
}
