# Contributing to Enler

Thank you for your interest in contributing to **Enler**! This document provides guidelines and instructions for contributing to the project.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How to Contribute](#how-to-contribute)
- [Development Setup](#development-setup)
- [Branch Naming](#branch-naming)
- [Commit Messages](#commit-messages)
- [Pull Request Process](#pull-request-process)
- [Code Style Guide](#code-style-guide)
- [Reporting Issues](#reporting-issues)

---

## Code of Conduct

By participating in this project, you agree to uphold the following principles:

- **Be respectful** — Treat everyone with respect. No harassment, discrimination, or personal attacks.
- **Be constructive** — Provide helpful feedback. Critique ideas, not people.
- **Be collaborative** — Work together toward the best solution. Welcome newcomers.
- **Be inclusive** — Use welcoming and inclusive language. Respect differing viewpoints and experiences.
- **Be professional** — Remember that this project represents CodeBros. Act accordingly.

Violations of these principles may result in removal from the project.

---

## How to Contribute

### 1. Check the Project Status

Before starting work, review [`PROJECT_STATUS.md`](PROJECT_STATUS.md) to understand:
- The current phase and active tasks
- What's been completed
- Known issues and blockers

### 2. Pick a Task

- Look at open issues or tasks in `PROJECT_STATUS.md`
- Comment on the issue to claim it (avoid duplicate work)
- If you want to propose a new feature, open an issue first to discuss it

### 3. Fork & Branch

```bash
# Fork the repo on GitHub, then:
git clone https://github.com/your-username/enler.git
cd enler
git remote add upstream https://github.com/codebros/enler.git

# Create a feature branch from main
git checkout -b feature/your-feature-name
```

### 4. Make Changes

- Follow the [Code Style Guide](#code-style-guide)
- Write tests for new functionality
- Update documentation if needed
- Keep changes focused — one feature/fix per PR

### 5. Submit a Pull Request

See [Pull Request Process](#pull-request-process) below.

---

## Development Setup

See the [README.md](README.md#-getting-started) for full setup instructions including:
- Flutter SDK, Node.js, and Supabase CLI installation
- Environment configuration
- Running the app locally

---

## Branch Naming

Use the following branch naming convention:

| Prefix | Usage | Example |
|---|---|---|
| `feature/` | New features | `feature/quiz-timer` |
| `fix/` | Bug fixes | `fix/leaderboard-sort` |
| `docs/` | Documentation changes | `docs/api-spec-update` |
| `test/` | Test additions/fixes | `test/quiz-widget-tests` |
| `refactor/` | Code refactoring (no behavior change) | `refactor/profile-state` |
| `chore/` | Tooling, CI, dependencies | `chore/update-flutter-sdk` |
| `perf/` | Performance improvements | `perf/image-caching` |
| `style/` | Code style/formatting | `style/lint-fixes` |

**Rules:**
- Always branch from `main`
- Use lowercase with hyphens: `feature/quiz-timer` ✅ not `Feature/QuizTimer` ❌
- Keep branch names short but descriptive

---

## Commit Messages

We follow **[Conventional Commits](https://www.conventionalcommits.org/)** for all commit messages.

### Format

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Types

| Type | Description |
|---|---|
| `feat` | A new feature |
| `fix` | A bug fix |
| `docs` | Documentation only changes |
| `test` | Adding or updating tests |
| `perf` | Performance improvement |
| `sec` | Security fix or improvement |
| `style` | Code style (formatting, missing semicolons, etc.) — no logic change |
| `chore` | Build process, tooling, dependencies, CI |
| `refactor` | Code restructuring without changing behavior |
| `ci` | Changes to CI configuration |
| `revert` | Reverts a previous commit |

### Scopes

Use the feature or module name as the scope:

| Scope | Area |
|---|---|
| `auth` | Authentication |
| `profile` | Profile creation/editing |
| `quiz` | Quiz gameplay |
| `leaderboard` | Score rankings |
| `sharing` | Share cards |
| `web` | Next.js web quiz |
| `db` | Database/Supabase |
| `ai` | AI wrong answer generation |
| `l10n` | Localization |
| `ui` | General UI/theme |
| `infra` | Infrastructure/tooling |

### Examples

```bash
# Good ✅
feat(profile): add category selection screen
fix(quiz): correct timer not stopping on answer
docs(db): update schema with new indexes
test(leaderboard): add unit tests for score calculation
perf(sharing): optimize share card image rendering
chore(infra): update Flutter to 3.24
sec(auth): sanitize user input on profile fields

# Bad ❌
update stuff
fixed bug
WIP
asdfgh
```

### Breaking Changes

For breaking changes, add `BREAKING CHANGE:` in the commit footer or `!` after the type:

```
feat(db)!: rename profiles table to user_profiles

BREAKING CHANGE: The profiles table has been renamed to user_profiles.
All queries referencing the old table name must be updated.
```

---

## Pull Request Process

### Before Submitting

- [ ] Code compiles without errors
- [ ] All existing tests pass (`flutter test`, `npm test`)
- [ ] New tests written for new functionality
- [ ] No hardcoded UI strings (all text through localization)
- [ ] No `select('*')` in Supabase queries
- [ ] `const` constructors used where possible
- [ ] Documentation updated if needed
- [ ] `PROJECT_STATUS.md` updated with task completion

### PR Title

Use the same conventional commit format:

```
feat(quiz): add countdown timer with animation
```

### PR Description Template

```markdown
## What

Brief description of what this PR does.

## Why

Why this change is needed. Link to issue if applicable.

## How

How the change was implemented. Key technical decisions.

## Screenshots / Videos

(if applicable — especially for UI changes)

## Checklist

- [ ] Tests pass
- [ ] No hardcoded strings
- [ ] Documentation updated
- [ ] PROJECT_STATUS.md updated
```

### Review Process

1. At least one team member must review and approve
2. All CI checks must pass
3. No merge conflicts with `main`
4. Squash merge to keep history clean

---

## Code Style Guide

### General

| Rule | Standard |
|---|---|
| File naming | `snake_case.dart`, `snake_case.tsx` |
| Class naming | `PascalCase` |
| Variable/function naming | `camelCase` |
| Constants | `camelCase` (Dart), `SCREAMING_SNAKE_CASE` (JS/TS) |
| UI text language | Turkish (through localization) |
| Code language | English |

### Flutter / Dart

- **Architecture:** Feature-first (`lib/features/<feature>/`)
- **State management:** Riverpod
- **Routing:** GoRouter
- **Constructors:** Use `const` wherever possible
- **Linting:** Follow `flutter_lints` (or `very_good_analysis`)
- **Localization:** All UI strings via `AppLocalizations.of(context)` — zero hardcoded Turkish text

### Next.js / TypeScript

- **Architecture:** App Router (`src/app/`)
- **Styling:** Tailwind CSS
- **Components:** React Server Components where possible
- **TypeScript:** Strict mode, no `any` types

### Supabase

- **RLS:** Mandatory on every table — no exceptions
- **Queries:** Always specify columns: `.select('id, name, score')` not `.select('*')`
- **Migrations:** One migration file per schema change
- **Naming:** `snake_case` for tables and columns

### Full Reference

For comprehensive coding rules, see:
- [`.gemini/rules.md`](.gemini/rules.md) — AI assistant rules
- [`.cursor/rules/`](.cursor/rules/) — Cursor-specific rules
- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) — Architecture decisions

---

## Reporting Issues

### Bug Reports

When reporting a bug, include:

1. **Summary** — What went wrong
2. **Steps to Reproduce** — Exact steps to trigger the bug
3. **Expected Behavior** — What should have happened
4. **Actual Behavior** — What actually happened
5. **Environment** — Device, OS version, app version
6. **Screenshots/Videos** — If applicable

### Feature Requests

When proposing a feature:

1. **Problem** — What problem does this solve?
2. **Proposed Solution** — How should it work?
3. **Alternatives Considered** — Other approaches you thought of
4. **Additional Context** — Mockups, examples, references

---

## Questions?

If you have questions about contributing, feel free to reach out to the CodeBros team.

Thank you for helping make Enler better! 🎉
