<p align="center">
  <img src="docs/assets/enler_logo.png" alt="Enler Logo" width="120" />
</p>

<h1 align="center">Enler</h1>

<p align="center">
  <strong>Arkadaşlarını ne kadar tanıyorsun?</strong><br/>
  A social quiz app where users create profiles with their favorites — and friends guess them.
</p>

<p align="center">
  <a href="https://enlerapp.com">enlerapp.com</a> · Built by <strong>CodeBros</strong>
</p>

---

## 🎯 What is Enler?

**Enler** is a social quiz game. You fill out a profile with your favorites — favorite movie, song, food, color, and more. Then you share a quiz link with your friends. They try to guess your answers from multiple-choice options. The closer they guess, the higher they score on your leaderboard.

**How it works:**

1. **Create your profile** — Pick your favorites across fun categories
2. **Share your quiz link** — Send it to friends via any messaging app
3. **Friends play the quiz** — They guess your favorites from 4 choices
4. **See the leaderboard** — Find out who knows you best

## ✨ Features

| Feature | Description |
|---|---|
| 🧑 Profile Creation | Fill out your favorites across multiple categories |
| 🎮 Quiz Gameplay | Friends guess your favorites in a timed multiple-choice quiz |
| 🏆 Leaderboard | See who knows you best, ranked by score |
| 🔗 Share Cards | Beautiful gradient share cards for social media |
| 🤖 AI-Powered | Gemini AI generates believable wrong answer choices |
| 🌐 Web Quiz | Friends play via a web link — no app install needed |
| 📱 Mobile App | Full-featured Flutter app for iOS & Android |

## 🎨 Design: Soft Aurora

Enler uses the **Soft Aurora** design system — a light, warm theme with indigo-violet gradient accents.

| Token | Value | Usage |
|---|---|---|
| Background | `#FAFAF8` | Warm white page background |
| Surface | `#FFFFFF` | Card backgrounds |
| Primary | `#6366F1` | Indigo — buttons, links, key actions |
| Secondary | `#8B5CF6` | Violet — accents, gradients |
| Warm Accent | `#F472B6` | Coral pink — highlights, notifications |
| Reward | `#F59E0B` | Amber — scores, achievements |
| Success | `#10B981` | Green — correct answers, confirmations |
| Error | `#EF4444` | Red — wrong answers, errors |

Share cards use an **indigo → violet gradient** (`#6366F1 → #8B5CF6`).

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| Mobile App | Flutter 3.x (Dart) |
| Web Quiz | Next.js 15 (React, TypeScript) |
| Backend | Supabase (PostgreSQL, Auth, Edge Functions, Storage, Realtime) |
| AI | Google Gemini API (wrong answer generation) |
| State Management | Riverpod |
| Routing | GoRouter |
| i18n | flutter_localizations + intl (Turkish v1) |
| Deployment | Vercel (web), App Store, Google Play |

## 📁 Project Structure

```
enler/
├── enler_app/                 # Flutter mobile app
│   ├── lib/
│   │   ├── core/              # Theme, routing, constants, utils
│   │   ├── features/          # Feature-first modules
│   │   │   ├── auth/          # Authentication
│   │   │   ├── profile/       # Profile creation & editing
│   │   │   ├── quiz/          # Quiz gameplay
│   │   │   ├── leaderboard/   # Score rankings
│   │   │   └── sharing/       # Share card generation
│   │   ├── l10n/              # Localization (Turkish v1)
│   │   └── main.dart
│   ├── test/
│   ├── pubspec.yaml
│   └── pubspec.lock
│
├── enler_web/                 # Next.js web quiz
│   ├── src/
│   │   ├── app/               # App Router pages
│   │   ├── components/        # React components
│   │   ├── lib/               # Utilities, Supabase client
│   │   └── styles/            # Global styles, theme
│   ├── public/
│   ├── package.json
│   └── package-lock.json
│
├── supabase/                  # Supabase project
│   ├── migrations/            # SQL migration files
│   ├── functions/             # Edge Functions (Deno/TypeScript)
│   ├── seed.sql               # Seed data
│   └── config.toml
│
├── docs/                      # Project documentation
│   ├── ARCHITECTURE.md
│   ├── DESIGN_SYSTEM.md
│   ├── DATABASE_SCHEMA.md
│   ├── API_SPEC.md
│   ├── ROADMAP.md
│   ├── APP_STORE_CHECKLIST.md
│   ├── TESTING_STRATEGY.md
│   └── CHANGELOG.md
│
├── .gemini/                   # Gemini AI rules
│   └── rules.md
├── .cursor/                   # Cursor AI rules
│   └── rules/
│       ├── project.mdc
│       ├── flutter.mdc
│       ├── nextjs.mdc
│       └── supabase.mdc
│
├── PROJECT_STATUS.md          # Single source of truth for progress
├── README.md                  # This file
├── CONTRIBUTING.md            # Contribution guidelines
├── LICENSE                    # MIT License
└── .gitignore
```

## 🚀 Getting Started

### Prerequisites

| Tool | Version | Install |
|---|---|---|
| Flutter SDK | 3.x | [flutter.dev/get-started](https://flutter.dev/docs/get-started/install) |
| Dart SDK | (bundled with Flutter) | — |
| Node.js | 20+ | [nodejs.org](https://nodejs.org/) |
| Supabase CLI | latest | `npm install -g supabase` |
| Git | 2.x+ | [git-scm.com](https://git-scm.com/) |

### Clone & Setup

```bash
# Clone the repository
git clone https://github.com/codebros/enler.git
cd enler
```

### Flutter App

```bash
cd enler_app

# Install dependencies
flutter pub get

# Generate localization files
flutter gen-l10n

# Generate code (Freezed, JSON serialization, etc.)
dart run build_runner build --delete-conflicting-outputs

# Run on device/emulator
flutter run
```

### Next.js Web

```bash
cd enler_web

# Install dependencies
npm install

# Run dev server
npm run dev
```

### Supabase Local Development

```bash
# Start local Supabase
supabase start

# Apply migrations
supabase db push

# Seed database
supabase db seed
```

### Environment Variables

Create `.env.local` files in both `enler_app/` and `enler_web/`:

```env
# Supabase
SUPABASE_URL=http://localhost:54321
SUPABASE_ANON_KEY=your-anon-key

# Gemini AI (for wrong answer generation)
GEMINI_API_KEY=your-gemini-api-key
```

> ⚠️ Never commit `.env` files. They are listed in `.gitignore`.

## 🔄 Development Workflow

1. Check `PROJECT_STATUS.md` for the current task
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make changes following the code standards in `.gemini/rules.md`
4. Write tests for new functionality
5. Commit with conventional commits: `feat: add quiz timer component`
6. Open a Pull Request
7. Update `PROJECT_STATUS.md` after merging

## 📐 Code Standards

- **Architecture:** Feature-first
- **File naming:** `snake_case` for files, `PascalCase` for classes
- **Localization:** All UI strings through localization — no hardcoded text
- **Language:** Turkish UI, English code
- **Supabase:** RLS mandatory on all tables, no `select('*')`
- **Commits:** Conventional commits (`feat`, `fix`, `docs`, `test`, `perf`, `sec`, `style`, `chore`)

See [CONTRIBUTING.md](CONTRIBUTING.md) for full guidelines.

## 🌍 Localization

Enler ships with **Turkish** as the only language for v1. The localization infrastructure is set up from day 1 to support additional languages in the future.

Localization files are in `enler_app/lib/l10n/`.

## 📄 Documentation

| Document | Description |
|---|---|
| [ARCHITECTURE.md](docs/ARCHITECTURE.md) | System architecture & tech decisions |
| [DESIGN_SYSTEM.md](docs/DESIGN_SYSTEM.md) | Soft Aurora design tokens & components |
| [DATABASE_SCHEMA.md](docs/DATABASE_SCHEMA.md) | Supabase database schema & RLS policies |
| [API_SPEC.md](docs/API_SPEC.md) | API endpoints & Edge Functions |
| [ROADMAP.md](docs/ROADMAP.md) | Development roadmap & milestones |
| [TESTING_STRATEGY.md](docs/TESTING_STRATEGY.md) | Testing approach & coverage goals |
| [CHANGELOG.md](docs/CHANGELOG.md) | Version history |

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to contribute.

## 📜 License

This project is licensed under the **MIT License** — see [LICENSE](LICENSE) for details.

---

<p align="center">
  Made with ❤️ by <strong>CodeBros</strong>
</p>
