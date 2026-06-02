# API Specification

> Enler — Supabase SDK Interactions & Edge Functions

All data access goes through the **Supabase Flutter SDK** (`supabase_flutter`) and **Supabase JS SDK** (`@supabase/supabase-js`). We do **not** expose custom REST endpoints — every query is a direct SDK call with RLS enforcing authorization.

---

## Table of Contents

- [Authentication](#authentication)
- [Profiles](#profiles)
- [Questions](#questions)
- [Quiz Sessions](#quiz-sessions)
- [Scores & Leaderboard](#scores--leaderboard)
- [Edge Functions](#edge-functions)
- [Realtime Subscriptions](#realtime-subscriptions)
- [Storage](#storage)
- [Error Codes & Handling](#error-codes--handling)
- [Rate Limiting](#rate-limiting)

---

## Authentication

All auth flows use Supabase Auth with Magic Link (OTP) and Apple/Google social providers.

### Sign Up / Sign In with OTP

```dart
final response = await supabase.auth.signInWithOtp(
  email: email,
);
```

| Property     | Value                  |
|-------------|------------------------|
| Method      | `signInWithOtp`        |
| Provider    | Email Magic Link       |
| RLS Context | Anonymous → Authenticated |
| Side Effect | Creates `auth.users` row, triggers `handle_new_user` function |

### Sign In with Social Provider

```dart
final response = await supabase.auth.signInWithOAuth(
  OAuthProvider.google, // or OAuthProvider.apple
  redirectTo: 'com.codebros.enler://callback',
);
```

| Property     | Value                        |
|-------------|------------------------------|
| Method      | `signInWithOAuth`            |
| Providers   | Google, Apple                |
| RLS Context | Anonymous → Authenticated   |
| Redirect    | `com.codebros.enler://callback` |

### Sign Out

```dart
await supabase.auth.signOut();
```

### Get Current User

```dart
final user = supabase.auth.currentUser;
final session = supabase.auth.currentSession;
```

### Listen to Auth State Changes

```dart
supabase.auth.onAuthStateChange.listen((data) {
  final event = data.event;   // AuthChangeEvent
  final session = data.session;
});
```

---

## Profiles

### Get Own Profile

```dart
final data = await supabase
    .from('profiles')
    .select('id, username, display_name, avatar_url, bio, created_at, updated_at')
    .eq('id', userId)
    .single();
```

| Property     | Value                          |
|-------------|--------------------------------|
| Table       | `profiles`                     |
| Method      | `select().eq().single()`       |
| Columns     | `id, username, display_name, avatar_url, bio, created_at, updated_at` |
| RLS         | Authenticated users can read any profile |
| Returns     | Single `Profile` object        |

### Get Profile by Username

```dart
final data = await supabase
    .from('profiles')
    .select('id, username, display_name, avatar_url, bio')
    .eq('username', username)
    .single();
```

| Property     | Value                          |
|-------------|--------------------------------|
| Table       | `profiles`                     |
| RLS         | Public read via `anon` key allowed |
| Use Case    | Share link resolution          |

### Update Profile

```dart
final data = await supabase
    .from('profiles')
    .update({
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'bio': bio,
      'updated_at': DateTime.now().toIso8601String(),
    })
    .eq('id', userId)
    .select('id, username, display_name, avatar_url, bio, updated_at')
    .single();
```

| Property     | Value                          |
|-------------|--------------------------------|
| Table       | `profiles`                     |
| Method      | `update().eq().select().single()` |
| RLS         | Users can only update `WHERE id = auth.uid()` |
| Validation  | `display_name` max 50 chars, `bio` max 200 chars |

### Check Username Availability

```dart
final data = await supabase
    .from('profiles')
    .select('id')
    .eq('username', username)
    .maybeSingle();

final isAvailable = data == null;
```

| Property     | Value                          |
|-------------|--------------------------------|
| Table       | `profiles`                     |
| RLS         | Authenticated read             |
| Constraint  | `username` has UNIQUE index    |

---

## Questions

### Get Questions for a Profile

```dart
final data = await supabase
    .from('questions')
    .select('id, profile_id, category, question_text, correct_answer, created_at')
    .eq('profile_id', profileId)
    .order('category');
```

| Property     | Value                          |
|-------------|--------------------------------|
| Table       | `questions`                    |
| Method      | `select().eq().order()`        |
| Columns     | `id, profile_id, category, question_text, correct_answer, created_at` |
| RLS         | Authenticated users can read questions for any profile (needed for quiz) |

### Get Questions by Category

```dart
final data = await supabase
    .from('questions')
    .select('id, profile_id, category, question_text, correct_answer')
    .eq('profile_id', profileId)
    .eq('category', category);
```

| Property     | Value                          |
|-------------|--------------------------------|
| Table       | `questions`                    |
| Filter      | `profile_id` AND `category`   |
| Categories  | `favorites, personality, memories, preferences, dreams` |

### Upsert Question

```dart
final data = await supabase
    .from('questions')
    .upsert({
      'id': questionId, // null for new
      'profile_id': userId,
      'category': category,
      'question_text': questionText,
      'correct_answer': correctAnswer,
    })
    .select('id, profile_id, category, question_text, correct_answer, created_at')
    .single();
```

| Property     | Value                          |
|-------------|--------------------------------|
| Table       | `questions`                    |
| Method      | `upsert().select().single()`   |
| RLS         | Users can only insert/update `WHERE profile_id = auth.uid()` |
| Constraint  | Max 5 questions per category per user (enforced via DB trigger) |

### Delete Question

```dart
await supabase
    .from('questions')
    .delete()
    .eq('id', questionId)
    .eq('profile_id', userId);
```

| Property     | Value                          |
|-------------|--------------------------------|
| Table       | `questions`                    |
| RLS         | Users can only delete own questions |

### Count Questions per Profile

```dart
final count = await supabase
    .from('questions')
    .select('id')
    .eq('profile_id', profileId)
    .count(CountOption.exact);
```

| Property     | Value                          |
|-------------|--------------------------------|
| Use Case    | Determine if profile has enough questions for a quiz (min 5) |

---

## Quiz Sessions

### Create Quiz Session

```dart
final data = await supabase
    .from('quiz_sessions')
    .insert({
      'player_id': currentUserId,
      'target_profile_id': targetProfileId,
      'status': 'in_progress',
    })
    .select('id, player_id, target_profile_id, status, created_at')
    .single();
```

| Property     | Value                          |
|-------------|--------------------------------|
| Table       | `quiz_sessions`                |
| Method      | `insert().select().single()`   |
| RLS         | Authenticated user becomes `player_id` |
| Status      | `in_progress` → `completed` → `shared` |

### Get Session with Answers

```dart
final data = await supabase
    .from('quiz_sessions')
    .select('''
      id, player_id, target_profile_id, status, score_percentage, badge, created_at,
      quiz_answers(id, question_id, selected_answer, is_correct)
    ''')
    .eq('id', sessionId)
    .single();
```

| Property     | Value                          |
|-------------|--------------------------------|
| Table       | `quiz_sessions` + `quiz_answers` (join) |
| RLS         | Player can read own sessions; target profile owner can read sessions about them |

### Submit Answer

```dart
final data = await supabase
    .from('quiz_answers')
    .insert({
      'session_id': sessionId,
      'question_id': questionId,
      'selected_answer': selectedAnswer,
      'is_correct': isCorrect,
    })
    .select('id, session_id, question_id, selected_answer, is_correct')
    .single();
```

| Property     | Value                          |
|-------------|--------------------------------|
| Table       | `quiz_answers`                 |
| RLS         | Only the session player can insert answers |
| Constraint  | One answer per question per session (UNIQUE) |

### Complete Session

```dart
final data = await supabase
    .from('quiz_sessions')
    .update({
      'status': 'completed',
      'completed_at': DateTime.now().toIso8601String(),
    })
    .eq('id', sessionId)
    .eq('player_id', userId)
    .select('id, status, completed_at')
    .single();
```

| Property     | Value                          |
|-------------|--------------------------------|
| Table       | `quiz_sessions`                |
| RLS         | Only the player can update their own sessions |
| Side Effect | Triggers `calculate-score` Edge Function |

### Get Sessions for Profile (Leaderboard Data)

```dart
final data = await supabase
    .from('quiz_sessions')
    .select('''
      id, player_id, score_percentage, badge, completed_at,
      profiles!player_id(username, display_name, avatar_url)
    ''')
    .eq('target_profile_id', profileId)
    .eq('status', 'completed')
    .order('score_percentage', ascending: false)
    .limit(50);
```

| Property     | Value                          |
|-------------|--------------------------------|
| Table       | `quiz_sessions` + `profiles` (join) |
| RLS         | Authenticated read for completed sessions |
| Order       | By `score_percentage` descending |
| Limit       | Top 50 results                 |

---

## Scores & Leaderboard

### Get Leaderboard for a Profile

```dart
final data = await supabase
    .from('scores')
    .select('''
      id, player_id, target_profile_id, score_percentage, badge, played_at,
      profiles!player_id(username, display_name, avatar_url)
    ''')
    .eq('target_profile_id', profileId)
    .order('score_percentage', ascending: false)
    .limit(20);
```

| Property     | Value                          |
|-------------|--------------------------------|
| Table       | `scores` + `profiles` (join)   |
| RLS         | Public read for leaderboard    |
| Order       | Descending by score            |

### Get Personal Best

```dart
final data = await supabase
    .from('scores')
    .select('id, score_percentage, badge, played_at')
    .eq('player_id', currentUserId)
    .eq('target_profile_id', targetProfileId)
    .order('score_percentage', ascending: false)
    .limit(1)
    .maybeSingle();
```

---

## Edge Functions

### `generate-wrong-answers`

Generates three plausible wrong answer choices using Google Gemini API.

**Invocation:**

```dart
final response = await supabase.functions.invoke(
  'generate-wrong-answers',
  body: {
    'category': 'favorites',
    'correct_answer': 'Kırmızı',
    'question_text': 'En sevdiği renk nedir?',
    'language': 'tr',
  },
);
```

**Request Body:**

| Field           | Type     | Required | Description                      |
|----------------|----------|----------|----------------------------------|
| `category`     | `string` | ✅       | Question category                |
| `correct_answer` | `string` | ✅     | The correct answer to avoid      |
| `question_text` | `string` | ✅      | Full question for context        |
| `language`     | `string` | ✅       | Language code (`tr` for Turkish) |

**Response Body:**

```json
{
  "wrong_answers": ["Mavi", "Yeşil", "Sarı"]
}
```

| Field           | Type       | Description                           |
|----------------|------------|---------------------------------------|
| `wrong_answers` | `string[]` | Exactly 3 plausible wrong answers     |

**Implementation Notes:**

- Uses Gemini `gemini-2.0-flash` model
- System prompt instructs the AI to generate culturally relevant Turkish distractors
- Answers are shuffled before being returned
- Falls back to generic answers if Gemini API fails
- Timeout: 10 seconds
- Auth: Requires valid JWT (authenticated users only)

**Error Responses:**

| Status | Code                  | Description                    |
|--------|-----------------------|--------------------------------|
| 400    | `INVALID_INPUT`       | Missing or invalid fields      |
| 401    | `UNAUTHORIZED`        | No valid auth token            |
| 500    | `AI_GENERATION_FAILED`| Gemini API failure             |
| 429    | `RATE_LIMITED`         | Too many requests              |

---

### `calculate-score`

Calculates the final score and assigns a badge for a completed quiz session.

**Invocation:**

```dart
final response = await supabase.functions.invoke(
  'calculate-score',
  body: {
    'session_id': sessionId,
  },
);
```

**Request Body:**

| Field        | Type     | Required | Description            |
|-------------|----------|----------|------------------------|
| `session_id` | `string` | ✅       | UUID of the quiz session |

**Response Body:**

```json
{
  "score_percentage": 80,
  "correct_count": 8,
  "total_count": 10,
  "badge": "tanidik"
}
```

| Field              | Type     | Description                        |
|-------------------|----------|------------------------------------|
| `score_percentage` | `int`    | 0–100 percentage score             |
| `correct_count`   | `int`    | Number of correct answers          |
| `total_count`     | `int`    | Total questions in the session     |
| `badge`           | `string` | Badge slug based on score          |

**Badge Tiers:**

| Score Range | Badge Slug    | Turkish Label        | Emoji |
|------------|---------------|----------------------|-------|
| 0–20%      | `yabanci`     | Yabancı              | 🫥    |
| 21–40%     | `tanidik`     | Tanıdık              | 🤔    |
| 41–60%     | `arkadas`     | Arkadaş              | 😊    |
| 61–80%     | `yakin_arkadas`| Yakın Arkadaş       | 🤗    |
| 81–99%     | `can_dostu`   | Can Dostu            | 💜    |
| 100%       | `ruh_ikizi`   | Ruh İkizi            | 👁️‍🗨️  |

**Side Effects:**

- Updates `quiz_sessions.score_percentage` and `quiz_sessions.badge`
- Inserts/updates row in `scores` table
- Auth: Requires valid JWT; only the session player can trigger

**Error Responses:**

| Status | Code                    | Description                     |
|--------|-------------------------|---------------------------------|
| 400    | `INVALID_SESSION`       | Session not found or incomplete |
| 401    | `UNAUTHORIZED`          | Not the session player          |
| 409    | `ALREADY_CALCULATED`    | Score was already calculated    |

---

### `generate-og-image`

Generates an Open Graph image (share card) for social media sharing.

**Invocation:**

```dart
final response = await supabase.functions.invoke(
  'generate-og-image',
  body: {
    'username': 'elif_k',
    'score_percentage': 80,
    'badge': 'yakin_arkadas',
    'player_display_name': 'Ahmet',
  },
);
```

**Request Body:**

| Field                 | Type     | Required | Description                 |
|----------------------|----------|----------|-----------------------------|
| `username`           | `string` | ✅       | Target profile's username   |
| `score_percentage`   | `int`    | ✅       | Score to display            |
| `badge`              | `string` | ✅       | Badge slug                  |
| `player_display_name`| `string` | ✅       | Display name of the player  |

**Response:**

- Content-Type: `image/png`
- Dimensions: 1200×630 pixels
- Design: Soft Aurora gradient background (#6366F1 → #8B5CF6) with score, badge, and branding

**Implementation Notes:**

- Uses `@vercel/og` or Satori for server-side image generation
- Cached in Supabase Storage (`og-images` bucket) with key `{session_id}.png`
- Cache TTL: 30 days
- Auth: Public access (needed for Open Graph crawlers)

**Error Responses:**

| Status | Code                | Description                |
|--------|---------------------|----------------------------|
| 400    | `INVALID_INPUT`     | Missing required fields    |
| 500    | `GENERATION_FAILED` | Image generation error     |

---

## Realtime Subscriptions

### Leaderboard Live Updates

Subscribe to new scores for a specific profile's leaderboard:

```dart
final channel = supabase.channel('leaderboard:$profileId');

channel
    .onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'scores',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'target_profile_id',
        value: profileId,
      ),
      callback: (payload) {
        final newScore = payload.newRecord;
        // Update leaderboard UI
      },
    )
    .subscribe();
```

| Property     | Value                             |
|-------------|-----------------------------------|
| Channel     | `leaderboard:{profileId}`         |
| Table       | `scores`                          |
| Event       | `INSERT`                          |
| Filter      | `target_profile_id = {profileId}` |
| RLS         | Respects existing RLS policies    |

### Quiz Session Status Updates

Subscribe to session completion (for the profile owner to see who took their quiz):

```dart
final channel = supabase.channel('sessions:$profileId');

channel
    .onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'quiz_sessions',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'target_profile_id',
        value: profileId,
      ),
      callback: (payload) {
        if (payload.newRecord['status'] == 'completed') {
          // Show notification
        }
      },
    )
    .subscribe();
```

### Cleanup

Always unsubscribe when leaving the screen:

```dart
@override
void dispose() {
  supabase.removeChannel(channel);
  super.dispose();
}
```

---

## Storage

### Avatar Upload

```dart
final path = 'avatars/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';

await supabase.storage
    .from('avatars')
    .upload(path, file, fileOptions: const FileOptions(
      contentType: 'image/jpeg',
      upsert: true,
    ));

final url = supabase.storage
    .from('avatars')
    .getPublicUrl(path);
```

| Property     | Value                          |
|-------------|--------------------------------|
| Bucket      | `avatars`                      |
| Path Format | `avatars/{userId}/{timestamp}.jpg` |
| Max Size    | 2 MB                           |
| Allowed Types | `image/jpeg`, `image/png`, `image/webp` |
| Access      | Public read, authenticated upload |
| RLS         | Users can only upload to their own folder |

### OG Image Storage

```dart
// Written by the generate-og-image Edge Function
final url = supabase.storage
    .from('og-images')
    .getPublicUrl('$sessionId.png');
```

| Property     | Value                          |
|-------------|--------------------------------|
| Bucket      | `og-images`                    |
| Access      | Public read                    |
| Written By  | `generate-og-image` Edge Function |

---

## Error Codes & Handling

### Supabase Error Codes

| Code         | HTTP Status | Description                     | Client Action                  |
|-------------|-------------|----------------------------------|--------------------------------|
| `PGRST116`  | 406         | Single row expected, none found  | Show "not found" state         |
| `PGRST301`  | 401         | JWT expired                      | Refresh session                |
| `23505`     | 409         | Unique constraint violation      | Show "already exists" message  |
| `23503`     | 409         | Foreign key violation            | Invalid reference              |
| `42501`     | 403         | RLS policy violation             | Show "unauthorized" message    |
| `23514`     | 400         | Check constraint violation       | Validate input client-side     |

### Error Handling Pattern (Flutter)

```dart
try {
  final data = await supabase
      .from('profiles')
      .select('id, username, display_name')
      .eq('id', userId)
      .single();
  return Profile.fromJson(data);
} on PostgrestException catch (e) {
  switch (e.code) {
    case 'PGRST116':
      throw ProfileNotFoundException();
    case '42501':
      throw UnauthorizedException();
    default:
      throw ApiException(message: e.message, code: e.code);
  }
} on AuthException catch (e) {
  throw AuthFailedException(message: e.message);
} catch (e) {
  throw UnexpectedException(original: e);
}
```

### Custom Error Classes

```dart
sealed class AppException implements Exception {
  final String message;
  final String? code;
  const AppException({required this.message, this.code});
}

class ProfileNotFoundException extends AppException { ... }
class UnauthorizedException extends AppException { ... }
class QuizSessionExpiredException extends AppException { ... }
class RateLimitedException extends AppException { ... }
class AiGenerationFailedException extends AppException { ... }
```

---

## Rate Limiting

### Client-Side Throttling

| Operation                   | Limit              | Window   |
|----------------------------|---------------------|----------|
| Profile update             | 5 requests          | 1 minute |
| Question upsert            | 10 requests         | 1 minute |
| Start quiz session         | 3 sessions          | 1 minute |
| Submit answer              | 20 requests         | 1 minute |
| Generate wrong answers     | 30 requests         | 1 minute |

### Edge Function Rate Limits

| Function                | Limit              | Window   | Scope       |
|------------------------|---------------------|----------|-------------|
| `generate-wrong-answers` | 30 requests       | 1 minute | Per user    |
| `calculate-score`       | 10 requests        | 1 minute | Per user    |
| `generate-og-image`     | 5 requests         | 1 minute | Per user    |

### Supabase Platform Limits (Free Tier)

| Resource              | Limit                |
|----------------------|----------------------|
| API requests         | Unlimited (fair use) |
| Realtime connections | 200 concurrent       |
| Storage              | 1 GB                 |
| Edge Function invocations | 500K/month      |
| Database size        | 500 MB               |

### Rate Limit Response

When rate limited, the API returns:

```json
{
  "error": "RATE_LIMITED",
  "message": "Too many requests. Please try again later.",
  "retry_after_seconds": 60
}
```

HTTP Status: `429 Too Many Requests`

The client should implement exponential backoff with jitter on retries.
