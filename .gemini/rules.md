# Enler — Project Rules

> **Read PROJECT_STATUS.md before every task.** It tracks what's built, what's in progress, and what's next.

## Project Overview

Enler is a social quiz app where users create profiles listing their favorites (movies, food, music, hobbies, etc.) and friends try to guess their answers. Built with **Flutter** (mobile) + **Next.js** (web quiz player) + **Supabase** (backend).

- **Publisher:** CodeBros
- **Domain:** enlerapp.com
- **Bundle ID:** com.codebros.enler
- **App Name:** Enler

## Tech Stack

| Layer | Technology | Notes |
|-------|-----------|-------|
| Mobile | Flutter (Dart 3.x) | Single codebase, Android-first launch |
| Web | Next.js 15 (App Router, TypeScript) | Quiz-play & share-card landing pages |
| Backend | Supabase (PostgreSQL 15+, Auth, Edge Functions, Realtime, Storage) | Self-hosted option later |
| AI | Google Gemini API | Generates plausible wrong answer choices |
| State Mgmt | Riverpod (flutter_riverpod + riverpod_annotation) | Code-gen preferred |
| Routing | GoRouter | Declarative, deep-link ready |
| Serialization | Freezed + json_serializable | Immutable models with union types |
| Localization | Flutter intl (ARB) / next-intl (JSON) | Turkish-only for v1 |
| Analytics | Firebase Analytics + Crashlytics | Privacy-compliant events |
| CI/CD | GitHub Actions | Lint → Test → Build → Deploy |

## CRITICAL Rules — Read Every Time

1. **Read PROJECT_STATUS.md** before starting any work.
2. **Feature-first architecture** — never create files outside the defined structure.
3. **All UI strings through localization** — zero hardcoded Turkish/English text in widgets or components.
4. **Never `select('*')`** in Supabase queries — always specify columns explicitly.
5. **RLS is mandatory** on every Supabase table, default policy is DENY.
6. **`const` constructors** wherever possible in Flutter.
7. **No color literals in widgets** — always reference theme tokens.
8. **Conventional commits** — `feat(scope):`, `fix(scope):`, `docs(scope):`, etc.
9. **Test business logic** — skip only if it's purely declarative UI.
10. **Document new packages** — add rationale to docs/ARCHITECTURE.md before adding any dependency.

## Architecture

### Flutter App (`enler_app/`)

Feature-first with clean-architecture layers inside each feature:

```
lib/
├── core/                    # App-wide infrastructure
│   ├── constants/           # App constants, API endpoints
│   ├── di/                  # Dependency injection setup
│   ├── extensions/          # Dart extension methods
│   ├── router/              # GoRouter configuration
│   ├── theme/               # Soft Aurora theme, color tokens, text styles
│   └── utils/               # Formatters, validators, helpers
├── features/                # Each feature is self-contained
│   ├── auth/
│   │   ├── data/            # Repositories impl, data sources, DTOs
│   │   ├── domain/          # Entities, repository interfaces, use cases
│   │   └── presentation/   # Screens, widgets, Riverpod providers
│   ├── profile/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── quiz/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── leaderboard/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── notifications/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── settings/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── shared/                  # Cross-feature shared code
│   ├── models/              # Shared data models
│   ├── widgets/             # Reusable UI components
│   └── providers/           # Shared Riverpod providers
├── l10n/                    # ARB localization files
│   ├── app_tr.arb           # Turkish (primary)
│   └── app_en.arb           # English (future)
└── main.dart                # Entry point
```

**Rules:**
- Every feature folder must have `data/`, `domain/`, `presentation/` sub-folders.
- Domain layer has zero dependency on Flutter or external packages.
- Data layer implements domain interfaces.
- Presentation layer uses only Riverpod providers to access data.
- Cross-feature communication goes through shared providers, never direct imports between features.

### Next.js Web (`enler_web/`)

```
src/
├── app/                     # App Router pages & layouts
│   ├── [locale]/            # i18n dynamic segment
│   │   ├── quiz/[id]/       # Public quiz play page
│   │   ├── result/[id]/     # Quiz result + share card
│   │   └── page.tsx         # Landing page
│   ├── layout.tsx           # Root layout
│   └── globals.css          # Global styles
├── components/              # React components
│   ├── ui/                  # Primitives (Button, Card, Input)
│   └── quiz/                # Quiz-specific components
├── lib/                     # Utilities
│   ├── supabase/            # Supabase client (server + browser)
│   ├── utils.ts             # Helper functions
│   └── types.ts             # TypeScript type definitions
├── messages/                # next-intl JSON files
│   └── tr.json
└── styles/                  # Design tokens, CSS modules
    └── tokens.css
```

**Rules:**
- Default to **Server Components**. Add `'use client'` only when needed (interactivity, hooks, browser APIs).
- Use `next/image` for all images — never raw `<img>`.
- Dynamic imports (`next/dynamic`) for heavy client components.
- Metadata via `generateMetadata()` for every page.
- CSS Modules for component styles, global tokens in `tokens.css`.

### Supabase (`supabase/`)

```
supabase/
├── config.toml              # Project config
├── migrations/              # Numbered SQL migrations
│   └── YYYYMMDDHHMMSS_description.sql
├── functions/               # Edge Functions (Deno/TypeScript)
│   ├── generate-choices/    # Gemini API wrong-answer generation
│   ├── calculate-score/     # Score calculation (server-authoritative)
│   └── _shared/             # Shared utilities across functions
├── seed.sql                 # Development seed data
└── tests/                   # pgTAP or Edge Function tests
```

**Rules:**
- Every migration file is prefixed with a timestamp: `YYYYMMDDHHMMSS_short_description.sql`.
- Every `CREATE TABLE` must be followed by `ALTER TABLE ... ENABLE ROW LEVEL SECURITY;` and at least one policy.
- Foreign keys must have indexes.
- Use `gen_random_uuid()` for primary keys.
- Edge Functions handle all score writes — clients never write scores directly.
- Shared Edge Function code goes in `_shared/`.

## Design System: Soft Aurora

A single light warm theme — **no dark mode toggle** in v1.

### Color Tokens

| Token | Hex | Usage |
|-------|-----|-------|
| `background` | `#FAFAF8` | Page/scaffold background |
| `surface` | `#FFFFFF` | Cards, sheets |
| `surfaceVariant` | `#F5F5F4` | Section backgrounds, dividers |
| `primary` | `#6366F1` | CTA buttons, active states, links |
| `secondary` | `#8B5CF6` | Accent, gradient end |
| `tertiary` | `#F472B6` | Warm accent, highlights, badges |
| `reward` | `#F59E0B` | Scores, achievements, streaks |
| `success` | `#10B981` | Correct answers, confirmations |
| `error` | `#EF4444` | Wrong answers, destructive actions |
| `onPrimary` | `#FFFFFF` | Text on primary-colored surfaces |
| `textPrimary` | `#1C1917` | Headlines, body text |
| `textSecondary` | `#78716C` | Captions, hints, labels |
| `shadow` | `rgba(0,0,0,0.06)` | Card elevation |

### Gradient

- **Share card:** `#6366F1` → `#8B5CF6` (indigo to violet, 135°)
- **Premium accent:** `#6366F1` → `#F472B6` (indigo to coral, 90°)

### Typography

- Font: System default (San Francisco on iOS, Roboto on Android, Inter on web)
- Scale: Material 3 type scale
- Turkish characters (ğ, ü, ş, ı, ö, ç) must render correctly — test with real content

### Spacing & Radius

- Base unit: 4px
- Card radius: 16px
- Button radius: 12px
- Input radius: 12px
- Standard padding: 16px
- Section spacing: 24px

> **Full reference:** `docs/DESIGN_SYSTEM.md`

## Naming Conventions

| Context | Convention | Example |
|---------|-----------|---------|
| Dart files | `snake_case` | `auth_screen.dart` |
| Dart classes | `PascalCase` | `AuthScreen` |
| Dart variables/functions | `camelCase` | `userName`, `calculateScore()` |
| Dart constants | `camelCase` with `k` prefix | `kDefaultPadding` |
| TypeScript files | `kebab-case` or `PascalCase` for components | `quiz-player.tsx` |
| Database tables | `snake_case` | `quiz_sessions` |
| Database columns | `snake_case` | `correct_answers` |
| Edge Functions | `kebab-case` folder names | `generate-choices/` |
| Git branches | `type/short-description` | `feature/quiz-timer` |
| Git commits | Conventional Commits | `feat(quiz): add timer countdown` |
| ARB keys | `camelCase` | `"profileTitle": "Profilim"` |
| Environment vars | `SCREAMING_SNAKE` | `SUPABASE_URL` |

## Localization (i18n)

### Strategy
- **v1 ships Turkish only** — but the i18n infrastructure is set up from day 1.
- All user-facing strings go through the localization layer.
- Code comments, variable names, commit messages, and docs are in **English**.

### Flutter
- Package: `flutter_localizations` + `intl`
- ARB files in `lib/l10n/`
- Access via `AppLocalizations.of(context).keyName` or shorter alias `context.l10n.keyName`
- Plural forms and parameterized strings use ICU message format

### Next.js
- Package: `next-intl`
- JSON message files in `src/messages/`
- Access via `useTranslations('namespace')` hook
- Server Component translations via `getTranslations()`

## State Management (Riverpod)

### Provider Types
- `Provider` — computed/derived values
- `StateProvider` — simple mutable state
- `FutureProvider` — async data (auto-disposed by default)
- `StreamProvider` — reactive streams (Supabase Realtime)
- `NotifierProvider` / `AsyncNotifierProvider` — complex state with logic

### Rules
- Use `@riverpod` annotation (code-gen) for new providers.
- Always handle loading, error, and data states in UI.
- Keep providers small and composable — one provider per concern.
- Dispose providers when the feature is no longer visible (auto-dispose is default).
- Never access `ref` in build methods outside of Consumer/ConsumerWidget.

## Performance Guidelines

### Flutter
- Use `const` constructors on every widget/object possible.
- Use `ListView.builder` / `GridView.builder` for dynamic lists — never `ListView(children: [...])` for 10+ items.
- Wrap expensive subtrees with `RepaintBoundary`.
- Cache network images with `cached_network_image`.
- Avoid `BackdropFilter` on mid-range Android — use pre-rendered blurs or solid colors instead.
- Profile with DevTools — target 60fps on mid-range devices.
- **APK size target: < 25 MB.**

### Next.js
- Server Components by default — minimize client JS bundle.
- Use `next/image` with width/height for LCP optimization.
- Dynamic imports for below-the-fold interactive components.
- Prefetch critical routes.
- **Lighthouse target: 95+ on all metrics.**

### Supabase
- Create indexes on all foreign key columns.
- Always specify column lists in `select()`.
- Use connection pooling (PgBouncer) in production.
- Paginate large result sets — default limit of 20 rows.
- Use `maybeSingle()` instead of `single()` when result might be empty.

## Security Rules

1. **RLS on every table** — default policy is DENY. Explicitly grant SELECT/INSERT/UPDATE/DELETE.
2. **Scores are server-authoritative** — only Edge Functions write to score-related tables.
3. **API keys in `.env`** — never committed to version control.
4. **Input validation** — client-side for UX, server-side for security (both required).
5. **Auth tokens** — stored with `flutter_secure_storage`, never in SharedPreferences.
6. **Rate limiting** — Edge Functions enforce per-user rate limits.
7. **CORS** — restrict to `enlerapp.com` and localhost in development.
8. **File uploads** — validate MIME type and size server-side, store in Supabase Storage with path-based RLS.

## Testing Strategy

| Layer | Tool | Minimum Coverage |
|-------|------|-----------------|
| Dart unit tests | `flutter_test` | All domain logic, repositories |
| Widget tests | `flutter_test` | Critical user flows |
| Integration tests | `integration_test` | Auth flow, quiz flow |
| Next.js unit | Vitest | Utility functions, hooks |
| Next.js E2E | Playwright | Quiz play flow |
| Edge Functions | Deno.test | All functions |
| Database | pgTAP | RLS policies, functions |

### Rules
- Tests live next to the code they test (`_test.dart` suffix for Dart).
- Mock Supabase with interface-based dependency injection — never hit real DB in unit tests.
- CI runs all tests before merge — no skipping.

## DO NOT — Hard Rules

- ❌ Do NOT create files outside the feature-first structure.
- ❌ Do NOT hardcode colors — use `Theme.of(context)` or design tokens.
- ❌ Do NOT hardcode UI strings — use localization.
- ❌ Do NOT use `select('*')` in Supabase queries.
- ❌ Do NOT create tables without RLS policies.
- ❌ Do NOT add packages without documenting the rationale in `docs/ARCHITECTURE.md`.
- ❌ Do NOT skip tests for business logic and data layer.
- ❌ Do NOT use `ListView(children: [...])` for dynamic/long lists.
- ❌ Do NOT use `BackdropFilter` excessively — severe perf on mid-range Android.
- ❌ Do NOT write scores from the client — server (Edge Functions) only.
- ❌ Do NOT store secrets in source code or SharedPreferences.
- ❌ Do NOT create God-widgets — split into smaller composable widgets.
- ❌ Do NOT ignore analyzer warnings — fix or suppress with documented reason.

## Key Documentation

| Document | Purpose |
|----------|---------|
| `PROJECT_STATUS.md` | Current status, active phase, what's done/pending |
| `docs/ARCHITECTURE.md` | System architecture, tech decisions, dependency rationale |
| `docs/DESIGN_SYSTEM.md` | Complete design tokens, components, spacing, typography |
| `docs/DATABASE_SCHEMA.md` | All tables, columns, relationships, RLS policies |
| `docs/API_SPEC.md` | Edge Function APIs, request/response contracts |
| `docs/ROADMAP.md` | Phased delivery plan with milestones |
| `docs/TESTING_STRATEGY.md` | Test pyramid, coverage targets, CI integration |
| `docs/CHANGELOG.md` | Version history following Keep a Changelog |
| `CONTRIBUTING.md` | How to set up dev environment and contribute |
