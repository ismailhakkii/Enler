# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Project initialized with repository structure
- Documentation and rules files created
  - `PROJECT_STATUS.md` — living project status tracker
  - `ARCHITECTURE.md` — system architecture and tech stack decisions
  - `DESIGN_SYSTEM.md` — Soft Aurora design system with full color palette
  - `DATABASE_SCHEMA.md` — complete database schema with RLS policies
  - `API_SPEC.md` — Supabase SDK interactions and Edge Function specs
  - `ROADMAP.md` — phased development plan (Phase 0–9) with Gantt chart
  - `APP_STORE_CHECKLIST.md` — iOS App Store and Google Play submission guide
  - `TESTING_STRATEGY.md` — test pyramid, coverage targets, and CI pipeline
  - `CONTRIBUTING.md` — contribution guidelines and code standards
  - `README.md` — project overview and getting started guide
- AI assistant rules configured
  - `.gemini/rules.md` — Gemini AI context rules
  - `.cursor/rules/project.mdc` — project-wide Cursor rules
  - `.cursor/rules/flutter.mdc` — Flutter-specific Cursor rules
  - `.cursor/rules/nextjs.mdc` — Next.js-specific Cursor rules
  - `.cursor/rules/supabase.mdc` — Supabase-specific Cursor rules
- Design system (Soft Aurora) defined
  - Warm white background (#FAFAF8)
  - Indigo primary (#6366F1) with violet secondary (#8B5CF6)
  - Complete typography, spacing, and component specs
  - Share card gradient design
- Database schema designed
  - `profiles` table with username uniqueness
  - `questions` table with 5 categories
  - `quiz_sessions` and `quiz_answers` tables
  - `scores` table for leaderboard
  - Row Level Security (RLS) on all tables
  - `handle_new_user` trigger function
- Edge Function specifications defined
  - `generate-wrong-answers` — Gemini AI-powered distractor generation
  - `calculate-score` — score calculation with badge assignment
  - `generate-og-image` — social share card image generation
- i18n setup planned (Turkish-only for v1)
- MIT License added

---

## Version History Format

Each release will follow this structure:

```
## [X.Y.Z] - YYYY-MM-DD

### Added
- New features

### Changed
- Changes in existing functionality

### Deprecated
- Soon-to-be removed features

### Removed
- Removed features

### Fixed
- Bug fixes

### Security
- Vulnerability fixes
```

---

## Planned Versions

| Version | Codename | Target | Focus |
|---------|----------|--------|-------|
| 0.1.0 | — | Phase 1–2 | Supabase + Auth |
| 0.2.0 | — | Phase 3 | Profiles + Questions |
| 0.3.0 | — | Phase 4 | Quiz Engine |
| 0.4.0 | — | Phase 5 | Results + Sharing |
| 0.5.0 | — | Phase 6 | Leaderboard + Polish |
| 1.0.0 | 🚀 Launch | Phase 9 | App Store Release |
| 1.1.0 | — | Post-MVP | Düello Mode + Notifications |
| 1.2.0 | — | Post-MVP | Analytics + AI Suggestions |
| 2.0.0 | — | Future | Friends + Social Feed |
