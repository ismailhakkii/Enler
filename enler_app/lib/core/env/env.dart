/// Environment configuration sourced from compile-time `--dart-define`.
///
/// Default values point at the development Supabase project so the
/// app can run without extra flags during local development.
///
/// For production builds use:
/// ```sh
/// flutter build apk --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
/// ```
sealed class Env {
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://mdvtjwfipgsfrvnkaxoi.supabase.co',
  );

  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1kdnRqd2ZpcGdzZnJ2bmtheG9pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA0MjYzNzEsImV4cCI6MjA5NjAwMjM3MX0.1VZWyQdgBSlAoqE0kimy4KHszllfXCimnucK9mJthXA',
  );
}
