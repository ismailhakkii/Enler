import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../features/splash/presentation/splash_screen.dart';
import '../../../features/auth/presentation/auth_screen.dart';
import '../../../features/home/presentation/home_screen.dart';
import '../../../features/home/presentation/main_shell.dart';
import '../../../features/profile/presentation/profile_screen.dart';
import '../../../features/profile/presentation/profile_create_screen.dart';
import '../../../features/profile/presentation/profile_edit_screen.dart';
import '../../../features/quiz/presentation/question_add_screen.dart';
import '../../../features/quiz/presentation/quiz_solve_screen.dart';
import '../../../features/quiz/presentation/result_screen.dart';
import '../../../features/leaderboard/presentation/leaderboard_screen.dart';
import '../../../features/settings/presentation/settings_screen.dart';

part 'app_router.g.dart';

/// Centralised route path constants.
///
/// Using a sealed class to prevent instantiation while grouping
/// all path strings in one discoverable location.
sealed class AppRoutes {
  static const splash = '/';
  static const auth = '/auth';
  static const home = '/home';
  static const profileCreate = '/profile/create';
  static const profileEdit = '/profile/edit';
  static const questionAdd = '/questions/add';
  static const quiz = '/quiz/:username';
  static const result = '/result/:sessionId';
  static const leaderboard = '/leaderboard';
  static const settings = '/settings';
}

/// Provides the application-wide [GoRouter] instance.
///
/// Registered as a Riverpod provider so that the router can react to
/// auth-state changes via `ref.watch` in the future.
@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const AuthScreen(),
      ),

      // ── Bottom-nav shell ──────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.leaderboard,
                builder: (context, state) => const LeaderboardScreen(),
              ),
            ],
          ),
        ],
      ),

      // ── Full-screen routes (outside the shell) ────────────────────
      GoRoute(
        path: AppRoutes.profileCreate,
        builder: (context, state) => const ProfileCreateScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileEdit,
        builder: (context, state) => const ProfileEditScreen(),
      ),
      GoRoute(
        path: AppRoutes.questionAdd,
        builder: (context, state) => const QuestionAddScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.result,
        builder: (context, state) {
          final sessionId = state.pathParameters['sessionId'] ?? '';
          return ResultScreen(sessionId: sessionId);
        },
      ),
      GoRoute(
        path: AppRoutes.quiz,
        builder: (context, state) {
          final extra = state.extra as Map<String, String>? ?? {};
          return QuizSolveScreen(
            profileId: extra['profileId'] ?? '',
            playerName: extra['playerName'] ?? 'Anonim',
          );
        },
      ),
    ],
  );
}
