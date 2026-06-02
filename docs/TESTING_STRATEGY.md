# Testing Strategy

> Enler — Test Pyramid, Coverage Targets & CI Pipeline

---

## Table of Contents

- [Philosophy](#philosophy)
- [Test Pyramid](#test-pyramid)
- [Coverage Targets](#coverage-targets)
- [Flutter Testing](#flutter-testing)
- [Next.js Testing](#nextjs-testing)
- [Supabase Testing](#supabase-testing)
- [CI Pipeline](#ci-pipeline)
- [Testing Tools](#testing-tools)
- [Test Data Management](#test-data-management)
- [Quality Gates](#quality-gates)

---

## Philosophy

1. **Test behavior, not implementation** — Tests should validate what the app does, not how it does it.
2. **Fast feedback loops** — Unit tests run in seconds, integration tests in minutes.
3. **Confidence over coverage** — Prioritize tests that catch real bugs over hitting arbitrary metrics.
4. **Test at the right level** — Use the test pyramid; most tests should be fast unit tests.
5. **Treat tests as first-class code** — Same code standards, reviews, and refactoring apply.

---

## Test Pyramid

```
                    ┌─────────┐
                    │   E2E   │  ← Few, slow, high confidence
                    │  Tests  │     (Full user flows)
                   ─┴─────────┴─
                  ┌─────────────┐
                  │ Integration │  ← Moderate count
                  │    Tests    │     (Multi-widget flows)
                 ─┴─────────────┴─
                ┌─────────────────┐
                │  Widget Tests   │  ← Many per feature
                │  (Component)    │     (Individual screens)
               ─┴─────────────────┴─
              ┌─────────────────────┐
              │    Unit Tests       │  ← Most tests live here
              │ (Models, Services,  │     (Pure logic, fast)
              │  Providers, Utils)  │
              └─────────────────────┘
```

| Level | Count Target | Execution Time | Frequency |
|-------|-------------|----------------|-----------|
| Unit | 200+ tests | < 30 seconds | Every commit |
| Widget | 80+ tests | < 2 minutes | Every commit |
| Integration | 20+ tests | < 5 minutes | Every PR |
| E2E | 5–10 flows | < 10 minutes | Pre-release |
| Golden | 30+ snapshots | < 3 minutes | Every PR |

---

## Coverage Targets

| Scope | Target | Rationale |
|-------|--------|-----------|
| **Overall** | ≥ 70% | Baseline for a quality app |
| **Business Logic** (models, services, providers) | ≥ 90% | Critical path — bugs here break everything |
| **UI Widgets** | ≥ 60% | Visual correctness + golden tests |
| **Edge Functions** | ≥ 85% | Server-side logic must be reliable |
| **Database Migrations** | 100% | Every migration tested via reset + seed |
| **RLS Policies** | 100% | Security-critical — every policy must be verified |

### Measuring Coverage

```bash
# Flutter coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# View report
open coverage/html/index.html
```

---

## Flutter Testing

### Directory Structure

```
test/
├── unit/
│   ├── models/
│   │   ├── profile_model_test.dart
│   │   ├── question_model_test.dart
│   │   ├── quiz_session_model_test.dart
│   │   ├── score_model_test.dart
│   │   └── badge_model_test.dart
│   ├── services/
│   │   ├── auth_service_test.dart
│   │   ├── profile_service_test.dart
│   │   ├── question_service_test.dart
│   │   ├── quiz_service_test.dart
│   │   └── score_service_test.dart
│   ├── providers/
│   │   ├── auth_provider_test.dart
│   │   ├── profile_provider_test.dart
│   │   ├── quiz_provider_test.dart
│   │   └── leaderboard_provider_test.dart
│   └── utils/
│       ├── validators_test.dart
│       ├── formatters_test.dart
│       └── badge_calculator_test.dart
├── widget/
│   ├── auth/
│   │   ├── sign_in_screen_test.dart
│   │   ├── onboarding_screen_test.dart
│   │   └── username_screen_test.dart
│   ├── profile/
│   │   ├── profile_screen_test.dart
│   │   ├── profile_edit_screen_test.dart
│   │   └── question_editor_test.dart
│   ├── quiz/
│   │   ├── quiz_start_screen_test.dart
│   │   ├── quiz_question_screen_test.dart
│   │   └── quiz_results_screen_test.dart
│   ├── leaderboard/
│   │   └── leaderboard_screen_test.dart
│   └── shared/
│       ├── avatar_widget_test.dart
│       ├── badge_widget_test.dart
│       └── share_card_test.dart
├── integration/
│   ├── onboarding_flow_test.dart
│   ├── profile_creation_flow_test.dart
│   ├── quiz_complete_flow_test.dart
│   ├── share_flow_test.dart
│   └── deep_link_flow_test.dart
├── golden/
│   ├── profile_screen_golden_test.dart
│   ├── quiz_screen_golden_test.dart
│   ├── results_screen_golden_test.dart
│   └── share_card_golden_test.dart
├── fixtures/
│   ├── profile_fixture.dart
│   ├── question_fixture.dart
│   ├── quiz_session_fixture.dart
│   └── score_fixture.dart
├── mocks/
│   ├── mock_supabase.dart
│   ├── mock_auth_service.dart
│   ├── mock_profile_service.dart
│   └── mock_quiz_service.dart
└── helpers/
    ├── test_app.dart
    ├── pump_app.dart
    └── finders.dart
```

### Unit Tests

Test pure business logic: models, services, providers, and utility functions.

#### Model Tests

```dart
// test/unit/models/profile_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:enler/features/profile/models/profile_model.dart';

void main() {
  group('Profile', () {
    test('fromJson creates valid Profile', () {
      final json = {
        'id': '123',
        'username': 'test_user',
        'display_name': 'Test User',
        'avatar_url': null,
        'bio': 'Hello!',
        'created_at': '2026-01-01T00:00:00Z',
        'updated_at': '2026-01-01T00:00:00Z',
      };

      final profile = Profile.fromJson(json);

      expect(profile.id, '123');
      expect(profile.username, 'test_user');
      expect(profile.displayName, 'Test User');
      expect(profile.avatarUrl, isNull);
    });

    test('toJson produces correct map', () {
      final profile = Profile(
        id: '123',
        username: 'test_user',
        displayName: 'Test User',
      );

      final json = profile.toJson();

      expect(json['username'], 'test_user');
      expect(json['display_name'], 'Test User');
    });

    test('isComplete returns true when all fields filled', () {
      final profile = Profile(
        id: '123',
        username: 'test_user',
        displayName: 'Test User',
        avatarUrl: 'https://example.com/avatar.jpg',
        bio: 'My bio',
      );

      expect(profile.isComplete, isTrue);
    });
  });
}
```

#### Service Tests (with Mocks)

```dart
// test/unit/services/quiz_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late QuizService quizService;
  late MockSupabaseClient mockSupabase;

  setUp(() {
    mockSupabase = MockSupabaseClient();
    quizService = QuizService(supabase: mockSupabase);
  });

  group('QuizService', () {
    test('createSession returns session with in_progress status', () async {
      // Arrange
      when(() => mockSupabase.from('quiz_sessions').insert(any()).select(any()).single())
          .thenAnswer((_) async => {
                'id': 'session-123',
                'status': 'in_progress',
              });

      // Act
      final session = await quizService.createSession(
        playerId: 'player-1',
        targetProfileId: 'target-1',
      );

      // Assert
      expect(session.status, 'in_progress');
    });
  });
}
```

#### Provider Tests (Riverpod)

```dart
// test/unit/providers/auth_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('AuthProvider', () {
    test('initial state is unauthenticated', () {
      final container = ProviderContainer(
        overrides: [
          authServiceProvider.overrideWithValue(MockAuthService()),
        ],
      );

      final state = container.read(authStateProvider);

      expect(state, isA<Unauthenticated>());
    });
  });
}
```

### Widget Tests

Test individual screens and components in isolation.

```dart
// test/widget/quiz/quiz_question_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('QuizQuestionScreen', () {
    testWidgets('displays question text and 4 answer options', (tester) async {
      await tester.pumpApp(
        const QuizQuestionScreen(sessionId: 'test-session'),
        overrides: [
          quizProvider.overrideWith(() => MockQuizNotifier()),
        ],
      );

      expect(find.text('En sevdiği renk nedir?'), findsOneWidget);
      expect(find.byType(AnswerOption), findsNWidgets(4));
    });

    testWidgets('tapping answer triggers selection', (tester) async {
      await tester.pumpApp(
        const QuizQuestionScreen(sessionId: 'test-session'),
        overrides: [
          quizProvider.overrideWith(() => MockQuizNotifier()),
        ],
      );

      await tester.tap(find.text('Kırmızı'));
      await tester.pumpAndSettle();

      // Verify answer was selected
      expect(find.byWidgetPredicate(
        (w) => w is AnswerOption && w.isSelected,
      ), findsOneWidget);
    });

    testWidgets('shows correct/wrong feedback after answer', (tester) async {
      await tester.pumpApp(
        const QuizQuestionScreen(sessionId: 'test-session'),
        overrides: [
          quizProvider.overrideWith(() => MockQuizNotifier()),
        ],
      );

      await tester.tap(find.text('Mavi')); // Wrong answer
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsOneWidget);
    });
  });
}
```

### Integration Tests

Test complete user flows end-to-end within the Flutter app.

```dart
// test/integration/quiz_complete_flow_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('complete quiz flow: start → answer → results', (tester) async {
    // Launch app
    await tester.pumpWidget(const EnlerApp());
    await tester.pumpAndSettle();

    // Navigate to a profile's quiz
    await tester.tap(find.text('Quiz Başlat'));
    await tester.pumpAndSettle();

    // Answer all questions
    for (var i = 0; i < 5; i++) {
      await tester.tap(find.byType(AnswerOption).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sonraki'));
      await tester.pumpAndSettle();
    }

    // Verify results screen
    expect(find.byType(ResultsScreen), findsOneWidget);
    expect(find.byType(BadgeDisplay), findsOneWidget);
    expect(find.text('Paylaş'), findsOneWidget);
  });
}
```

### Golden Tests (Visual Regression)

Compare widget renders against saved reference images.

```dart
// test/golden/results_screen_golden_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResultsScreen Golden', () {
    testWidgets('renders correctly with high score', (tester) async {
      await tester.pumpApp(
        const ResultsScreen(
          scorePercentage: 90,
          badge: 'can_dostu',
          correctCount: 9,
          totalCount: 10,
        ),
      );

      await expectLater(
        find.byType(ResultsScreen),
        matchesGoldenFile('goldens/results_screen_high_score.png'),
      );
    });

    testWidgets('renders correctly with low score', (tester) async {
      await tester.pumpApp(
        const ResultsScreen(
          scorePercentage: 20,
          badge: 'yabanci',
          correctCount: 2,
          totalCount: 10,
        ),
      );

      await expectLater(
        find.byType(ResultsScreen),
        matchesGoldenFile('goldens/results_screen_low_score.png'),
      );
    });
  });
}
```

**Updating Goldens:**

```bash
flutter test --update-goldens test/golden/
```

---

## Next.js Testing

### Directory Structure

```
web/
├── __tests__/
│   ├── components/
│   │   ├── HeroSection.test.tsx
│   │   ├── FeatureCard.test.tsx
│   │   ├── ShareResult.test.tsx
│   │   └── Footer.test.tsx
│   ├── pages/
│   │   ├── Home.test.tsx
│   │   ├── Privacy.test.tsx
│   │   └── Terms.test.tsx
│   └── utils/
│       ├── og-helpers.test.ts
│       └── supabase-client.test.ts
├── e2e/
│   ├── landing-page.spec.ts
│   ├── share-result-page.spec.ts
│   └── navigation.spec.ts
└── lighthouse/
    └── lighthouse.config.js
```

### Component Tests (React Testing Library)

```tsx
// __tests__/components/ShareResult.test.tsx
import { render, screen } from '@testing-library/react';
import { ShareResult } from '@/components/ShareResult';

describe('ShareResult', () => {
  const mockProps = {
    username: 'elif_k',
    playerName: 'Ahmet',
    scorePercentage: 80,
    badge: 'yakin_arkadas',
    badgeLabel: 'Yakın Arkadaş',
  };

  it('renders score percentage', () => {
    render(<ShareResult {...mockProps} />);
    expect(screen.getByText('%80')).toBeInTheDocument();
  });

  it('renders badge label', () => {
    render(<ShareResult {...mockProps} />);
    expect(screen.getByText('Yakın Arkadaş')).toBeInTheDocument();
  });

  it('renders download CTA button', () => {
    render(<ShareResult {...mockProps} />);
    expect(screen.getByRole('link', { name: /indir/i })).toBeInTheDocument();
  });

  it('renders OG meta tags', () => {
    render(<ShareResult {...mockProps} />);
    // Verify meta tags are set correctly for social sharing
  });
});
```

### E2E Tests (Playwright)

```typescript
// e2e/landing-page.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Landing Page', () => {
  test('displays hero section with download links', async ({ page }) => {
    await page.goto('/');

    await expect(page.getByRole('heading', { level: 1 })).toBeVisible();
    await expect(page.getByRole('link', { name: /app store/i })).toBeVisible();
    await expect(page.getByRole('link', { name: /google play/i })).toBeVisible();
  });

  test('navigates to privacy policy', async ({ page }) => {
    await page.goto('/');
    await page.click('text=Gizlilik Politikası');

    await expect(page).toHaveURL('/privacy');
    await expect(page.getByRole('heading', { name: /gizlilik/i })).toBeVisible();
  });

  test('share result page renders for valid session', async ({ page }) => {
    await page.goto('/u/test_user/result/abc123');

    await expect(page.getByText(/test_user/)).toBeVisible();
    await expect(page.getByText(/%/)).toBeVisible();
  });

  test('share result page shows 404 for invalid session', async ({ page }) => {
    const response = await page.goto('/u/nonexistent/result/invalid');

    expect(response?.status()).toBe(404);
  });
});
```

### Lighthouse CI

```javascript
// lighthouse/lighthouse.config.js
module.exports = {
  ci: {
    collect: {
      url: [
        'http://localhost:3000/',
        'http://localhost:3000/privacy',
        'http://localhost:3000/terms',
      ],
      numberOfRuns: 3,
    },
    assert: {
      assertions: {
        'categories:performance': ['error', { minScore: 0.9 }],
        'categories:accessibility': ['error', { minScore: 0.95 }],
        'categories:best-practices': ['error', { minScore: 0.9 }],
        'categories:seo': ['error', { minScore: 0.9 }],
      },
    },
    upload: {
      target: 'temporary-public-storage',
    },
  },
};
```

**Lighthouse Targets:**

| Category | Minimum Score |
|----------|--------------|
| Performance | ≥ 90 |
| Accessibility | ≥ 95 |
| Best Practices | ≥ 90 |
| SEO | ≥ 90 |

---

## Supabase Testing

### Migration Validation

Every migration is validated by running a full database reset and verifying the schema.

```bash
# Reset database and apply all migrations
supabase db reset

# Verify schema matches expected state
supabase db diff --use-migra
```

**CI check:** Run `supabase db reset` on every PR that modifies `supabase/migrations/`.

### RLS Policy Tests

RLS policies are tested using the `pgTAP` extension or direct SQL queries with different roles.

```sql
-- test/supabase/rls_profiles_test.sql

-- Test: User can read their own profile
BEGIN;
SET LOCAL ROLE authenticated;
SET LOCAL request.jwt.claims = '{"sub": "user-1"}';

SELECT is(
  (SELECT count(*) FROM profiles WHERE id = 'user-1'),
  1::bigint,
  'User can read own profile'
);

-- Test: User can read other profiles (public read)
SELECT is(
  (SELECT count(*) FROM profiles WHERE id = 'user-2'),
  1::bigint,
  'User can read other profiles'
);

-- Test: User CANNOT update other profiles
SET LOCAL request.jwt.claims = '{"sub": "user-1"}';

PREPARE update_other AS
  UPDATE profiles SET display_name = 'Hacked' WHERE id = 'user-2';

SELECT throws_ok(
  'update_other',
  '42501',
  'new row violates row-level security policy',
  'User cannot update other profiles'
);

ROLLBACK;
```

#### RLS Test Matrix

| Table | Operation | Own Data | Other User | Anonymous |
|-------|-----------|----------|------------|-----------|
| `profiles` | SELECT | ✅ | ✅ | ✅ (public) |
| `profiles` | UPDATE | ✅ | ❌ | ❌ |
| `profiles` | DELETE | ❌ | ❌ | ❌ |
| `questions` | SELECT | ✅ | ✅ | ❌ |
| `questions` | INSERT | ✅ | ❌ | ❌ |
| `questions` | UPDATE | ✅ | ❌ | ❌ |
| `questions` | DELETE | ✅ | ❌ | ❌ |
| `quiz_sessions` | SELECT | ✅ (player) | ✅ (target) | ❌ |
| `quiz_sessions` | INSERT | ✅ | ❌ | ❌ |
| `quiz_sessions` | UPDATE | ✅ (player) | ❌ | ❌ |
| `quiz_answers` | SELECT | ✅ (via session) | ❌ | ❌ |
| `quiz_answers` | INSERT | ✅ (session player) | ❌ | ❌ |
| `scores` | SELECT | ✅ | ✅ | ✅ (public) |
| `scores` | INSERT | ❌ (Edge Function only) | ❌ | ❌ |

### Edge Function Tests

Edge Functions are tested using Deno's built-in test runner.

```typescript
// supabase/functions/generate-wrong-answers/index.test.ts
import { assertEquals, assertArrayIncludes } from 'https://deno.land/std/testing/asserts.ts';

Deno.test('generate-wrong-answers: returns 3 wrong answers', async () => {
  const response = await fetch('http://localhost:54321/functions/v1/generate-wrong-answers', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${testJwt}`,
    },
    body: JSON.stringify({
      category: 'favorites',
      correct_answer: 'Kırmızı',
      question_text: 'En sevdiği renk nedir?',
      language: 'tr',
    }),
  });

  assertEquals(response.status, 200);

  const data = await response.json();
  assertEquals(data.wrong_answers.length, 3);
  assertEquals(data.wrong_answers.includes('Kırmızı'), false);
});

Deno.test('generate-wrong-answers: rejects missing fields', async () => {
  const response = await fetch('http://localhost:54321/functions/v1/generate-wrong-answers', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${testJwt}`,
    },
    body: JSON.stringify({
      category: 'favorites',
      // missing correct_answer
    }),
  });

  assertEquals(response.status, 400);
});

Deno.test('generate-wrong-answers: rejects unauthenticated requests', async () => {
  const response = await fetch('http://localhost:54321/functions/v1/generate-wrong-answers', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      category: 'favorites',
      correct_answer: 'Kırmızı',
      question_text: 'En sevdiği renk nedir?',
      language: 'tr',
    }),
  });

  assertEquals(response.status, 401);
});
```

```typescript
// supabase/functions/calculate-score/index.test.ts
Deno.test('calculate-score: calculates correct percentage', async () => {
  // Setup: Create session with 8/10 correct answers
  const sessionId = await createTestSession(8, 10);

  const response = await fetch('http://localhost:54321/functions/v1/calculate-score', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${playerJwt}`,
    },
    body: JSON.stringify({ session_id: sessionId }),
  });

  assertEquals(response.status, 200);

  const data = await response.json();
  assertEquals(data.score_percentage, 80);
  assertEquals(data.badge, 'yakin_arkadas');
  assertEquals(data.correct_count, 8);
  assertEquals(data.total_count, 10);
});
```

---

## CI Pipeline

### GitHub Actions Workflow

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  # ──────────────────────────────────────
  # Flutter Tests
  # ──────────────────────────────────────
  flutter-test:
    name: Flutter Tests
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.32.x'
          channel: 'stable'
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Analyze code
        run: flutter analyze --fatal-infos

      - name: Run unit & widget tests
        run: flutter test --coverage --reporter=github

      - name: Check coverage threshold
        run: |
          COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep 'lines' | awk '{print $2}' | sed 's/%//')
          echo "Coverage: $COVERAGE%"
          if (( $(echo "$COVERAGE < 70" | bc -l) )); then
            echo "Coverage $COVERAGE% is below 70% threshold"
            exit 1
          fi

      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v4
        with:
          file: coverage/lcov.info

  # ──────────────────────────────────────
  # Golden Tests
  # ──────────────────────────────────────
  flutter-golden:
    name: Golden Tests
    runs-on: macos-latest  # Consistent rendering
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.32.x'
          channel: 'stable'

      - name: Install dependencies
        run: flutter pub get

      - name: Run golden tests
        run: flutter test test/golden/

  # ──────────────────────────────────────
  # Next.js Tests
  # ──────────────────────────────────────
  nextjs-test:
    name: Next.js Tests
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: web
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
          cache-dependency-path: web/package-lock.json

      - name: Install dependencies
        run: npm ci

      - name: Lint
        run: npm run lint

      - name: Type check
        run: npx tsc --noEmit

      - name: Run tests
        run: npm test -- --coverage

      - name: Build
        run: npm run build

  # ──────────────────────────────────────
  # Playwright E2E
  # ──────────────────────────────────────
  e2e-test:
    name: E2E Tests
    runs-on: ubuntu-latest
    needs: [nextjs-test]
    defaults:
      run:
        working-directory: web
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install dependencies
        run: npm ci

      - name: Install Playwright browsers
        run: npx playwright install --with-deps chromium

      - name: Run E2E tests
        run: npx playwright test

      - name: Upload test results
        if: failure()
        uses: actions/upload-artifact@v4
        with:
          name: playwright-report
          path: web/playwright-report/

  # ──────────────────────────────────────
  # Supabase Migration Check
  # ──────────────────────────────────────
  supabase-check:
    name: Supabase Checks
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: supabase/setup-cli@v1

      - name: Start Supabase (local)
        run: supabase start

      - name: Validate migrations
        run: supabase db reset

      - name: Run RLS tests
        run: supabase test db

      - name: Stop Supabase
        run: supabase stop

  # ──────────────────────────────────────
  # Lighthouse CI
  # ──────────────────────────────────────
  lighthouse:
    name: Lighthouse CI
    runs-on: ubuntu-latest
    needs: [nextjs-test]
    defaults:
      run:
        working-directory: web
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install & Build
        run: |
          npm ci
          npm run build

      - name: Run Lighthouse CI
        run: |
          npm install -g @lhci/cli
          lhci autorun --config=lighthouse/lighthouse.config.js
```

### Pipeline Triggers

| Event | Jobs Run |
|-------|---------|
| Push to `main` | All jobs |
| Pull Request to `main` | All jobs |
| Manual dispatch | All jobs |

### Branch Protection Rules

| Rule | Setting |
|------|---------|
| Required status checks | `flutter-test`, `nextjs-test`, `supabase-check` |
| Require PR reviews | 1 approval (when team grows) |
| Require up-to-date branch | Yes |
| Restrict force pushes | Yes |

---

## Testing Tools

### Flutter

| Tool | Purpose | Package |
|------|---------|---------|
| `flutter_test` | Unit & widget tests | Built-in |
| `integration_test` | Integration tests | Built-in |
| `mocktail` | Mocking | `mocktail: ^1.0.0` |
| `fake_async` | Time-based tests | Built-in |
| `golden_toolkit` | Golden test helpers | `golden_toolkit: ^0.15.0` |
| `network_image_mock` | Mock network images | `network_image_mock: ^2.1.0` |
| `alchemist` | Advanced golden tests | `alchemist: ^0.10.0` |

### Next.js

| Tool | Purpose | Package |
|------|---------|---------|
| Jest | Test runner | `jest` |
| React Testing Library | Component tests | `@testing-library/react` |
| Playwright | E2E tests | `@playwright/test` |
| Lighthouse CI | Performance | `@lhci/cli` |

### Supabase

| Tool | Purpose |
|------|---------|
| `supabase test db` | pgTAP-based DB tests |
| `supabase db reset` | Migration validation |
| Deno test | Edge Function tests |

---

## Test Data Management

### Fixtures

Use factory functions to create test data with sensible defaults:

```dart
// test/fixtures/profile_fixture.dart
Profile createTestProfile({
  String id = 'test-id',
  String username = 'test_user',
  String displayName = 'Test User',
  String? avatarUrl,
  String? bio,
}) {
  return Profile(
    id: id,
    username: username,
    displayName: displayName,
    avatarUrl: avatarUrl,
    bio: bio,
  );
}
```

### Seed Data

For integration and E2E tests, use Supabase seed files:

```sql
-- supabase/seed.sql
-- Test profiles
INSERT INTO auth.users (id, email) VALUES
  ('user-1', 'test1@example.com'),
  ('user-2', 'test2@example.com');

INSERT INTO profiles (id, username, display_name) VALUES
  ('user-1', 'test_user_1', 'Test User 1'),
  ('user-2', 'test_user_2', 'Test User 2');

-- Test questions
INSERT INTO questions (profile_id, category, question_text, correct_answer) VALUES
  ('user-1', 'favorites', 'En sevdiği renk?', 'Kırmızı'),
  ('user-1', 'favorites', 'En sevdiği yemek?', 'Pizza'),
  ('user-1', 'personality', 'Sabahçı mı gececi mi?', 'Gececi');
```

---

## Quality Gates

A PR cannot be merged unless all of the following pass:

| Gate | Criteria |
|------|----------|
| ✅ Tests | All unit, widget, and golden tests pass |
| ✅ Coverage | Overall ≥ 70%, business logic ≥ 90% |
| ✅ Lint | `flutter analyze` reports zero issues |
| ✅ Build | Release build succeeds for both platforms |
| ✅ Migrations | `supabase db reset` completes without errors |
| ✅ RLS | All RLS policy tests pass |
| ✅ Lighthouse | All scores ≥ 90 (when web changes included) |
| ✅ Review | At least 1 approval (when team > 1) |
