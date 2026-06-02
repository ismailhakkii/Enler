import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin wrapper around the Supabase SDK for initialization and
/// convenient access to the [SupabaseClient] singleton.
class SupabaseService {
  const SupabaseService._();

  /// Returns the global [SupabaseClient] instance.
  ///
  /// Must be called **after** [initialize].
  static SupabaseClient get client => Supabase.instance.client;

  /// Initialises the Supabase SDK with the given project [url]
  /// and [anonKey]. Call once in `main()` before `runApp`.
  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }
}
