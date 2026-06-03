import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';

part 'auth_repository.g.dart';

/// Repository that wraps Supabase Auth for authentication operations.
///
/// Provides reactive streams for auth state changes, convenience
/// getters for the current user, and sign-in / sign-out methods.
class AuthRepository {
  AuthRepository({required SupabaseClient client}) : _client = client;

  final SupabaseClient _client;

  /// The currently authenticated [User], or `null` if signed out.
  User? get currentUser => _client.auth.currentUser;

  /// Whether a user is currently authenticated.
  bool get isLoggedIn => currentUser != null;

  /// The current user's ID, or `null` if not authenticated.
  String? get userId => currentUser?.id;

  /// A broadcast stream that emits [AuthState] whenever the
  /// authentication status changes (sign-in, sign-out, token refresh).
  Stream<AuthState> get authStateChanges =>
      _client.auth.onAuthStateChange;

  /// Signs in with Google OAuth.
  ///
  /// Uses the native redirect URI for deep-link callback.
  Future<bool> signInWithGoogle() async {
    final response = await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'com.codebros.enler://login-callback',
    );
    return response;
  }

  /// Signs in with Apple OAuth.
  ///
  /// Uses the native redirect URI for deep-link callback.
  Future<bool> signInWithApple() async {
    final response = await _client.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: 'com.codebros.enler://login-callback',
    );
    return response;
  }

  /// Signs in anonymously (guest mode).
  ///
  /// Creates a temporary anonymous session so the user can still
  /// interact with Supabase (create profile, add questions) without
  /// providing credentials. They can link a real provider later.
  Future<AuthResponse> signInAnonymously() async {
    return await _client.auth.signInAnonymously();
  }

  /// Signs the current user out and clears the local session.
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}

// ── Riverpod providers ────────────────────────────────────────────────────

/// Provides the singleton [AuthRepository] instance.
@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(client: SupabaseService.client);
}

/// Streams [AuthState] changes for reactive auth listening.
@riverpod
Stream<AuthState> authStateChanges(Ref ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
}

/// Provides the current [User] reactively; updates on auth changes.
@riverpod
User? currentUser(Ref ref) {
  // Listen to the auth stream so we rebuild when it changes.
  ref.watch(authStateChangesProvider);
  return ref.read(authRepositoryProvider).currentUser;
}
