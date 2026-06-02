import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Placeholder profile creation screen (onboarding).
class ProfileCreateScreen extends ConsumerWidget {
  const ProfileCreateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Center(
        child: Text('Profile Create Screen'),
      ),
    );
  }
}
