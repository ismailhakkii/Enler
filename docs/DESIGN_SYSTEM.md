# Enler — Soft Aurora Design System

> **Version:** 1.0  
> **Last Updated:** 2026-06-03  
> **Status:** Phase 0 — Foundation  
> **Theme:** Light only (no dark mode in MVP)

---

## Table of Contents

1. [Design Philosophy](#design-philosophy)
2. [Color Palette](#color-palette)
3. [Typography](#typography)
4. [Spacing Scale](#spacing-scale)
5. [Border Radius Scale](#border-radius-scale)
6. [Shadow Definitions](#shadow-definitions)
7. [Component Specifications](#component-specifications)
8. [Animation Specifications](#animation-specifications)
9. [Badge (Rozet) System](#badge-rozet-system)
10. [Emoji Avatar System](#emoji-avatar-system)
11. [Share Card Variants](#share-card-variants)
12. [Result Screen Layout](#result-screen-layout)
13. [Bottom Navigation](#bottom-navigation)
14. [Logo Variants](#logo-variants)
15. [Accessibility Requirements](#accessibility-requirements)
16. [Flutter Implementation Notes](#flutter-implementation-notes)

---

## Design Philosophy

Enler's design language — **Soft Aurora** — is warm, approachable, and celebratory. The app should feel like opening a friendly letter, not using a corporate tool.

### Key Principles

| Principle | Description |
|---|---|
| **Warm & Inviting** | Warm whites and soft shadows — never cold or clinical |
| **Celebratory** | Every result feels like an achievement, not a judgment |
| **Playful but Polished** | Emoji avatars and gradients, but consistent and refined |
| **Frictionless** | Minimal steps, large touch targets, clear CTAs |
| **Light Only** | Single cohesive theme — no dark mode complexity in v1 |

---

## Color Palette

### Core Colors

| Token | Hex | RGB | Usage |
|---|---|---|---|
| `background` | `#FAFAF8` | 250, 250, 248 | App background, scaffold |
| `surface` | `#FFFFFF` | 255, 255, 255 | Cards, dialogs, bottom sheets |
| `surfaceAlt` | `#F5F5F4` | 245, 245, 244 | Section backgrounds, dividers, input fields |
| `primary` | `#6366F1` | 99, 102, 241 | Primary buttons, active states, links |
| `primaryLight` | `#818CF8` | 129, 140, 248 | Hover/focus states for primary |
| `primaryDark` | `#4F46E5` | 79, 70, 229 | Pressed states for primary |
| `secondary` | `#8B5CF6` | 139, 92, 246 | Secondary actions, gradient end |
| `secondaryLight` | `#A78BFA` | 167, 139, 250 | Hover/focus states for secondary |
| `warmAccent` | `#F472B6` | 244, 114, 182 | Hearts, likes, warm highlights |
| `reward` | `#F59E0B` | 245, 158, 11 | Badges, streaks, achievements |
| `rewardLight` | `#FCD34D` | 252, 211, 77 | Reward backgrounds |
| `success` | `#10B981` | 16, 185, 129 | Correct answers, success states |
| `successLight` | `#D1FAE5` | 209, 250, 229 | Success backgrounds |
| `error` | `#EF4444` | 239, 68, 68 | Wrong answers, error states |
| `errorLight` | `#FEE2E2` | 254, 226, 226 | Error backgrounds |

### Text Colors

| Token | Hex | Usage |
|---|---|---|
| `textPrimary` | `#1C1917` | Headings, body text, primary content |
| `textSecondary` | `#78716C` | Subtitles, descriptions, meta text |
| `textTertiary` | `#A8A29E` | Placeholder text, disabled text |
| `textOnPrimary` | `#FFFFFF` | Text on primary/secondary buttons |
| `textOnDark` | `#FFFFFF` | Text on gradient/dark backgrounds |

### Shadow Colors

| Token | Value | Usage |
|---|---|---|
| `cardShadow` | `rgba(0, 0, 0, 0.06)` | Default card shadow |
| `elevatedShadow` | `rgba(0, 0, 0, 0.10)` | Elevated elements, dialogs |
| `coloredShadow` | `rgba(99, 102, 241, 0.20)` | Primary button shadow |

### Gradients

| Token | Value | Usage |
|---|---|---|
| `primaryGradient` | `#6366F1 → #8B5CF6` | Share cards, hero sections |
| `warmGradient` | `#F472B6 → #F59E0B` | Special badge backgrounds |
| `successGradient` | `#10B981 → #6366F1` | Perfect score celebrations |

### Color Usage Rules

1. **Never use pure black** (`#000000`) — always use `textPrimary` (`#1C1917`)
2. **Never use pure white** for backgrounds — use `background` (`#FAFAF8`)
3. **Cards are always `surface`** (`#FFFFFF`) with `cardShadow`
4. **Use `surfaceAlt`** for visual grouping inside cards
5. **Gradients are only used** on share cards, hero banners, and special states
6. **Error/success backgrounds** use the `Light` variant, never the full-intensity color

---

## Typography

### Font Stack

| Font | Weight Range | Usage |
|---|---|---|
| **Outfit** | 500–700 | Headings, display text, badges |
| **Inter** | 400–600 | Body text, buttons, inputs |
| **Space Grotesk** | 500–700 | Numbers, percentages, scores |

### Type Scale

| Token | Font | Size (sp) | Weight | Line Height | Letter Spacing | Usage |
|---|---|---|---|---|---|---|
| `displayLarge` | Outfit | 32 | 700 (Bold) | 1.2 | -0.5 | Hero text, result percentage |
| `displayMedium` | Outfit | 28 | 700 (Bold) | 1.2 | -0.3 | Screen titles |
| `displaySmall` | Outfit | 24 | 600 (SemiBold) | 1.3 | -0.2 | Section headers |
| `headlineLarge` | Outfit | 22 | 600 (SemiBold) | 1.3 | 0 | Card titles |
| `headlineMedium` | Outfit | 20 | 600 (SemiBold) | 1.3 | 0 | Subsection headers |
| `headlineSmall` | Outfit | 18 | 500 (Medium) | 1.4 | 0 | Widget titles |
| `titleLarge` | Inter | 18 | 600 (SemiBold) | 1.4 | 0 | Navigation titles |
| `titleMedium` | Inter | 16 | 600 (SemiBold) | 1.4 | 0.1 | Button text |
| `titleSmall` | Inter | 14 | 600 (SemiBold) | 1.4 | 0.1 | Chip labels |
| `bodyLarge` | Inter | 16 | 400 (Regular) | 1.5 | 0.15 | Main body text |
| `bodyMedium` | Inter | 14 | 400 (Regular) | 1.5 | 0.15 | Default body text |
| `bodySmall` | Inter | 12 | 400 (Regular) | 1.5 | 0.2 | Captions, meta text |
| `labelLarge` | Inter | 14 | 500 (Medium) | 1.4 | 0.1 | Form labels |
| `labelMedium` | Inter | 12 | 500 (Medium) | 1.4 | 0.5 | Overline text |
| `labelSmall` | Inter | 11 | 500 (Medium) | 1.4 | 0.5 | Badges, tags |
| `scoreDisplay` | Space Grotesk | 48 | 700 (Bold) | 1.0 | -1.0 | Result score number |
| `scoreMedium` | Space Grotesk | 24 | 700 (Bold) | 1.0 | -0.5 | Leaderboard scores |
| `scoreSmall` | Space Grotesk | 18 | 600 (SemiBold) | 1.2 | 0 | Inline score numbers |

### Typography Rules

1. **All UI text goes through l10n** — no hardcoded Turkish strings
2. **Headings use Outfit** — softer, friendlier for display
3. **Body text uses Inter** — maximum readability
4. **Numbers and scores use Space Grotesk** — tabular, modern feel
5. **Maximum 2 font weights per text block** for visual consistency
6. **Minimum text size: 11sp** for accessibility

---

## Spacing Scale

All spacing values are multiples of 4 to maintain a consistent rhythm.

| Token | Value (dp) | Usage |
|---|---|---|
| `xxs` | 4 | Icon-text gap, tight internal padding |
| `xs` | 8 | Chip padding, compact lists |
| `sm` | 12 | Input internal padding, card sections |
| `md` | 16 | Default padding, card padding, screen horizontal margin |
| `lg` | 24 | Section spacing, between card groups |
| `xl` | 32 | Major section breaks |
| `xxl` | 48 | Screen top/bottom padding, hero spacing |
| `xxxl` | 64 | Major page sections, onboarding gaps |

### Spacing Rules

1. **Screen horizontal padding**: Always `md` (16dp)
2. **Card internal padding**: `md` (16dp) on all sides
3. **Between cards in a list**: `sm` (12dp)
4. **Between sections on a screen**: `lg` (24dp) or `xl` (32dp)
5. **Button internal padding**: Horizontal `lg` (24dp), Vertical `sm` (12dp)

---

## Border Radius Scale

| Token | Value (dp) | Usage |
|---|---|---|
| `sm` | 8 | Chips, small tags, inner elements |
| `md` | 12 | Input fields, small cards |
| `lg` | 16 | Cards, buttons, bottom sheets |
| `xl` | 20 | Large cards, image containers |
| `full` | 9999 | Circular avatars, pills |

### Border Radius Rules

1. **Primary buttons**: `lg` (16dp) — rounded but not pill-shaped
2. **Cards**: `lg` (16dp) — consistent across all card types
3. **Input fields**: `md` (12dp)
4. **Avatars**: `full` (circular)
5. **Bottom sheets**: `xl` (20dp) top corners only
6. **Share cards**: `xl` (20dp)

---

## Shadow Definitions

| Token | Value | Usage |
|---|---|---|
| `sm` | `0 1px 3px rgba(0,0,0,0.06), 0 1px 2px rgba(0,0,0,0.04)` | Subtle depth — input fields, chips |
| `md` | `0 4px 12px rgba(0,0,0,0.06)` | Default card shadow |
| `lg` | `0 8px 24px rgba(0,0,0,0.08), 0 2px 8px rgba(0,0,0,0.04)` | Elevated cards, dialogs, bottom sheets |
| `colored` | `0 4px 16px rgba(99, 102, 241, 0.20)` | Primary CTA buttons |
| `glow` | `0 0 24px rgba(99, 102, 241, 0.15)` | Highlighted/selected elements |

### Flutter Implementation

```dart
class AppShadows {
  static const sm = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const md = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static const lg = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const colored = [
    BoxShadow(
      color: Color(0x336366F1),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];
}
```

---

## Component Specifications

### Buttons

#### Primary Button

| Property | Value |
|---|---|
| Height | 52dp |
| Border radius | 16dp (`lg`) |
| Background | `primary` (#6366F1) |
| Text | `titleMedium`, `textOnPrimary` |
| Shadow | `colored` |
| Pressed | `primaryDark` (#4F46E5), scale 0.98 |
| Disabled | `surfaceAlt` (#F5F5F4), `textTertiary` |
| Loading | CircularProgressIndicator (white, 20dp) |
| Padding | Horizontal 24dp, Vertical 14dp |

#### Secondary Button (Outlined)

| Property | Value |
|---|---|
| Height | 52dp |
| Border radius | 16dp (`lg`) |
| Background | `transparent` |
| Border | 1.5dp solid `primary` (#6366F1) |
| Text | `titleMedium`, `primary` |
| Pressed | `primary` at 5% opacity background |
| Disabled | Border `textTertiary`, text `textTertiary` |

#### Ghost Button (Text)

| Property | Value |
|---|---|
| Height | 40dp |
| Background | `transparent` |
| Text | `titleSmall`, `primary` |
| Pressed | `primary` at 5% opacity background |

#### Icon Button

| Property | Value |
|---|---|
| Size | 44dp × 44dp |
| Icon size | 24dp |
| Background | `surfaceAlt` (#F5F5F4) |
| Border radius | `full` (circular) |
| Pressed | `primary` at 10% opacity |

### Cards

#### Standard Card

| Property | Value |
|---|---|
| Background | `surface` (#FFFFFF) |
| Border radius | 16dp (`lg`) |
| Shadow | `md` |
| Padding | 16dp (`md`) all sides |
| Border | None |

#### Answer Option Card

| Property | Value |
|---|---|
| Background | `surface` (#FFFFFF) |
| Border radius | 16dp (`lg`) |
| Shadow | `sm` |
| Border | 1.5dp solid `surfaceAlt` (#F5F5F4) |
| Padding | Horizontal 16dp, Vertical 14dp |
| **Selected** | Border 2dp solid `primary`, background `primary` at 5% |
| **Correct** | Border 2dp solid `success`, background `successLight` |
| **Wrong** | Border 2dp solid `error`, background `errorLight` |

#### Profile Card

| Property | Value |
|---|---|
| Background | `surface` (#FFFFFF) |
| Border radius | 20dp (`xl`) |
| Shadow | `lg` |
| Padding | 24dp (`lg`) all sides |
| Avatar | 80dp circle, emoji or image |
| Username | `headlineLarge`, `textPrimary` |
| Stats row | `bodySmall`, `textSecondary` |

### Inputs

#### Text Input

| Property | Value |
|---|---|
| Height | 52dp |
| Background | `surfaceAlt` (#F5F5F4) |
| Border radius | 12dp (`md`) |
| Border (default) | None |
| Border (focused) | 2dp solid `primary` |
| Border (error) | 2dp solid `error` |
| Text | `bodyLarge`, `textPrimary` |
| Placeholder | `bodyLarge`, `textTertiary` |
| Label | `labelLarge`, `textSecondary` (above) |
| Padding | Horizontal 16dp |

### Badges (Tags)

| Property | Value |
|---|---|
| Height | 28dp |
| Border radius | 8dp (`sm`) |
| Background | Varies by badge type |
| Text | `labelSmall`, matching text color |
| Padding | Horizontal 10dp, Vertical 4dp |

### Progress Bar

| Property | Value |
|---|---|
| Height | 6dp |
| Background | `surfaceAlt` (#F5F5F4) |
| Fill | `primaryGradient` (#6366F1 → #8B5CF6) |
| Border radius | `full` |
| Animation | 400ms easeOutCubic |

### Quiz Progress Dots

| Property | Value |
|---|---|
| Size (inactive) | 8dp circle |
| Size (active) | 24dp × 8dp pill |
| Color (inactive) | `surfaceAlt` (#F5F5F4) |
| Color (active) | `primary` (#6366F1) |
| Color (completed, correct) | `success` (#10B981) |
| Color (completed, wrong) | `error` (#EF4444) |
| Gap | 6dp |

---

## Animation Specifications

### Duration Scale

| Token | Duration | Usage |
|---|---|---|
| `instant` | 100ms | Micro-interactions (tap feedback) |
| `fast` | 200ms | Hover states, toggles |
| `normal` | 300ms | Page transitions, card reveals |
| `slow` | 400ms | Complex transitions, progress bars |
| `emphasis` | 600ms | Hero animations, score reveal |
| `celebration` | 1000ms | Badge reveal, confetti |
| `stagger` | 80ms | Delay between staggered list items |

### Easing Curves

| Token | Curve | Usage |
|---|---|---|
| `standard` | `Curves.easeInOut` | Default transitions |
| `decelerate` | `Curves.easeOut` | Elements entering the screen |
| `accelerate` | `Curves.easeIn` | Elements leaving the screen |
| `spring` | `Curves.elasticOut` | Bouncy reveals (badges, scores) |
| `sharp` | `Curves.easeOutCubic` | Progress bars, sliders |

### Animation Catalog

| Animation | Duration | Easing | Properties |
|---|---|---|---|
| **Card appear** | 300ms + 80ms stagger | easeOut | fadeIn + slideUp (16dp) |
| **Answer select** | 200ms | easeInOut | scale(0.98) + border color |
| **Correct answer** | 400ms | easeOut | background → successLight, icon appear |
| **Wrong answer** | 400ms | easeOut | background → errorLight, shake (8dp, 3 cycles) |
| **Score count-up** | 600ms | easeOutCubic | Number tween 0 → final percentage |
| **Badge reveal** | 1000ms | elasticOut | scale(0 → 1.1 → 1.0) + fadeIn |
| **Confetti** | 2000ms | linear | Lottie particle animation |
| **Page transition** | 300ms | easeInOut | Shared axis (horizontal) |
| **Progress bar fill** | 400ms | easeOutCubic | Width tween |
| **Leaderboard entry** | 300ms | easeOut | slideIn from right + fadeIn |
| **Share card flip** | 500ms | easeInOut | 3D flip Y-axis |
| **Button press** | 100ms | easeIn | scale(0.98) |
| **Emoji bounce** | 600ms | elasticOut | scale(0 → 1.15 → 1.0) |

### Animation Rules

1. **No animation longer than 2000ms** (except Lottie celebrations)
2. **Stagger delay between list items: 80ms** — never more than 5 items staggered
3. **Always respect `AccessibilityFeatures.reduceMotion`** — replace with instant transitions
4. **Loading states use shimmer** (not spinners) for content placeholders
5. **Don't animate during quiz answering** — keep focus on content
6. **Celebrate every result** — even low scores get a warm animation

---

## Badge (Rozet) System

The badge system is the emotional core of Enler. Every quiz result maps to a badge tier.

### Badge Tiers

| Range | Emoji | Turkish Name | English Key | Color | Slogan (TR) |
|---|---|---|---|---|---|
| 0–20% | 🫠 | Yabancı | `stranger` | `#EF4444` (Error) | "Daha çok tanışmalıyız!" |
| 21–40% | 🤔 | Tanıdık | `acquaintance` | `#F59E0B` (Reward) | "Bir şeyler biliyorsun ama..." |
| 41–60% | 😊 | Arkadaş | `friend` | `#6366F1` (Primary) | "Fena değil, arkadaşız!" |
| 61–80% | 🤩 | Yakın Arkadaş | `closeFriend` | `#8B5CF6` (Secondary) | "Beni gerçekten tanıyorsun!" |
| 81–99% | 💜 | Can Dostum | `bestFriend` | `#F472B6` (Warm Accent) | "Neredeyse mükemmel!" |
| 100% | 👑 | Ruh İkizim | `soulmate` | `#10B981` (Success) | "Ruh ikizim sensin!" |

### Badge Display Specifications

```
┌───────────────────────────────┐
│                               │
│         [Emoji 48dp]          │
│                               │
│      "Yakın Arkadaş" 🤩       │  ← headlineLarge, badge color
│                               │
│          %75                  │  ← scoreDisplay, badge color
│                               │
│   "Beni gerçekten tanıyorsun" │  ← bodyMedium, textSecondary
│                               │
│     ════════════════          │  ← progress bar, badge color
│                               │
└───────────────────────────────┘
```

### Badge Card (for Share)

| Property | Value |
|---|---|
| Size | 340dp × 200dp |
| Background | Gradient (badge color → lighter variant) |
| Border radius | 20dp (`xl`) |
| Emoji | 40dp, top-left |
| Badge name | `headlineMedium`, white |
| Percentage | `scoreMedium`, white |
| Slogan | `bodySmall`, white at 80% opacity |
| Profile owner name | `titleSmall`, white |
| "enlerapp.com" | `labelSmall`, white at 60% opacity |

---

## Emoji Avatar System

Users pick an emoji as their avatar. No photo upload in v1.

### Available Emoji Set

Organized by category for the picker:

| Category | Emojis |
|---|---|
| **Smileys** | 😊 😎 🤓 🥰 😇 🤪 😜 🥳 🤠 🧐 |
| **People** | 👩‍🎤 👨‍🚀 🧑‍💻 👩‍🎨 🧑‍🍳 🦸 🧙 🧚 🧛 👻 |
| **Animals** | 🐱 🐶 🦊 🐼 🐨 🦁 🐸 🦋 🐝 🦄 |
| **Nature** | 🌸 🌻 🌈 ⭐ 🌙 ☀️ 🍀 🌺 🔥 💫 |
| **Food** | 🍕 🌮 🍣 🧁 🍩 🫐 🍉 🥑 🍦 ☕ |
| **Objects** | 🎸 🎮 📚 🎨 ⚽ 🎯 🎪 🎭 💎 🚀 |

### Emoji Avatar Display

| Context | Size | Background |
|---|---|---|
| Profile header | 80dp | `surfaceAlt` circle |
| Leaderboard row | 40dp | `surfaceAlt` circle |
| Quiz header | 56dp | `surfaceAlt` circle |
| Share card | 48dp | White circle at 20% opacity |
| Emoji picker grid | 44dp | Transparent; selected: `primary` at 10% |

### Emoji Picker

| Property | Value |
|---|---|
| Layout | Grid, 6 columns |
| Cell size | 52dp × 52dp |
| Category tabs | Horizontal scroll, icons |
| Selected state | `primary` at 10% bg, 2dp `primary` border, scale 1.1 |
| Search | Filter by category tab |

---

## Share Card Variants

Three share card designs users can choose from when sharing their quiz results.

### Variant 1: Gradient Card

```
┌─────────────────────────────────────┐
│  ┌─────────────────────────────────┐│
│  │ ▓▓▓▓▓▓▓▓ GRADIENT BG ▓▓▓▓▓▓▓▓ ││
│  │                                 ││
│  │   [Avatar Emoji]  @username     ││
│  │                                 ││
│  │        %75 🤩                   ││
│  │    "Yakın Arkadaş"              ││
│  │                                 ││
│  │  "Beni gerçekten tanıyorsun!"   ││
│  │                                 ││
│  │  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─   ││
│  │  Sen de dene → enlerapp.com     ││
│  └─────────────────────────────────┘│
└─────────────────────────────────────┘
```

| Property | Value |
|---|---|
| Dimensions | 1080 × 1920 (Story) or 1080 × 1080 (Square) |
| Background | `primaryGradient` (#6366F1 → #8B5CF6) |
| Text color | White |
| Border radius | 20dp inner card |
| CTA | "Sen de dene → enlerapp.com" |

### Variant 2: Minimal Card

```
┌─────────────────────────────────────┐
│                                     │
│  ┌──────────────────────────────┐   │
│  │ White Card                   │   │
│  │                              │   │
│  │  EN.  enler                  │   │
│  │                              │   │
│  │  [Emoji]                     │   │
│  │  @username seni %75 tanıyor  │   │
│  │                              │   │
│  │  🤩 Yakın Arkadaş            │   │
│  │                              │   │
│  │  enlerapp.com                │   │
│  └──────────────────────────────┘   │
│                                     │
│  Background: #FAFAF8                │
└─────────────────────────────────────┘
```

| Property | Value |
|---|---|
| Background | `background` (#FAFAF8) |
| Card | `surface` (#FFFFFF), `lg` shadow |
| Text color | `textPrimary` and `textSecondary` |
| Accent | Badge color for emoji and percentage |

### Variant 3: Stats Card

```
┌─────────────────────────────────────┐
│  Dark card (#1C1917)                │
│                                     │
│  [Emoji]  @username'in Enler'ı     │
│                                     │
│  ┌─────┐ ┌─────┐ ┌─────┐          │
│  │ %75 │ │ 8/10│ │ 🤩  │          │
│  │Score│ │Right│ │Badge│          │
│  └─────┘ └─────┘ └─────┘          │
│                                     │
│  "Beni gerçekten tanıyorsun!"      │
│                                     │
│  ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔      │
│  enlerapp.com                       │
└─────────────────────────────────────┘
```

| Property | Value |
|---|---|
| Background | `textPrimary` (#1C1917) |
| Text color | White |
| Stat boxes | `surface` at 10% opacity, `md` border radius |
| Stat numbers | `scoreMedium`, White |
| Stat labels | `labelSmall`, White at 60% |

### Share Card Rules

1. **All cards include the CTA** "enlerapp.com" or "Sen de dene → enlerapp.com"
2. **All cards show**: avatar emoji, username, percentage, badge name, slogan
3. **Story format** (1080 × 1920) is default; square (1080 × 1080) is secondary
4. **Cards are rendered as images** (PNG) using Flutter's `RepaintBoundary`
5. **Shared via `share_plus`** with both image and text

---

## Result Screen Layout

The result screen is the emotional climax of the quiz experience.

### Layout Structure

```
┌──────────────────────────────┐
│  ← Geri                     │  ← AppBar (transparent)
│                              │
│                              │
│         [Confetti]           │  ← Lottie animation (1s)
│                              │
│        [Emoji 64dp]          │  ← Badge emoji, elasticOut
│                              │
│      "Yakın Arkadaş"        │  ← Badge name, fadeIn
│                              │
│    ┌─────────────────┐       │
│    │      %75        │       │  ← Score, count-up animation
│    └─────────────────┘       │
│                              │
│  "Beni gerçekten tanıyorsun" │  ← Slogan, fadeIn 400ms delay
│                              │
│  ═══════════════════════     │  ← Progress bar, animated fill
│                              │
│  10 sorudan 7 doğru 🎯       │  ← Stats row
│                              │
│  ┌──────────────────────┐    │
│  │  📤 Sonucu Paylaş    │    │  ← Primary button
│  └──────────────────────┘    │
│                              │
│  ┌──────────────────────┐    │
│  │  🔄 Tekrar Dene      │    │  ← Secondary button
│  └──────────────────────┘    │
│                              │
│  ┌──────────────────────┐    │
│  │  📊 Sıralama         │    │  ← Ghost button
│  └──────────────────────┘    │
│                              │
└──────────────────────────────┘
```

### Animation Sequence

| Step | Delay | Duration | Element |
|---|---|---|---|
| 1 | 0ms | 1000ms | Confetti Lottie plays |
| 2 | 200ms | 600ms | Badge emoji bounces in |
| 3 | 400ms | 300ms | Badge name fades in |
| 4 | 500ms | 600ms | Score counts up 0 → final |
| 5 | 800ms | 300ms | Slogan fades in |
| 6 | 900ms | 400ms | Progress bar fills |
| 7 | 1100ms | 300ms | Stats row fades in |
| 8 | 1300ms | 300ms | Buttons slide up + fade in |

---

## Bottom Navigation

### Tab Configuration

| Index | Icon (Outlined) | Icon (Filled) | Label (TR) | Route |
|---|---|---|---|---|
| 0 | `person_outline` | `person` | Profil | `/profile` |
| 1 | `quiz_outlined` | `quiz` | Quiz | `/quiz` |
| 2 | `leaderboard_outlined` | `leaderboard` | Sıralama | `/leaderboard` |

### Bottom Nav Specifications

| Property | Value |
|---|---|
| Height | 64dp + safe area |
| Background | `surface` (#FFFFFF) |
| Shadow | `md` (inverted — shadow above) |
| Active icon color | `primary` (#6366F1) |
| Inactive icon color | `textTertiary` (#A8A29E) |
| Active label | `labelSmall`, `primary` |
| Inactive label | `labelSmall`, `textTertiary` |
| Icon size | 24dp |
| Animation | 200ms color transition |
| Type | Fixed (3 tabs) |
| Selected indicator | `primary` at 10%, pill shape behind icon |

### When to Show Bottom Nav

| Screen | Show Nav |
|---|---|
| Home / Profile | ✅ |
| Leaderboard | ✅ |
| Quiz list | ✅ |
| Quiz taking | ❌ (full-screen) |
| Result screen | ❌ (full-screen) |
| Profile creation | ❌ (full-screen) |
| Share card picker | ❌ (bottom sheet) |

---

## Logo Variants

### Short Logo: EN.

| Property | Value |
|---|---|
| Font | Outfit, 700 (Bold) |
| "EN" | `textPrimary` (#1C1917) |
| "." | `primary` (#6366F1) |
| Usage | App bar, small spaces, favicon |

### Full Logo: ENLER

| Property | Value |
|---|---|
| Font | Outfit, 700 (Bold) |
| Text | `textPrimary` (#1C1917) |
| Usage | Splash screen, share cards, marketing |

### Logo Clear Space

Minimum clear space around the logo = height of the "E" character on all sides.

### Logo Don'ts

- Don't change the colors
- Don't add effects (shadows, outlines)
- Don't stretch or distort
- Don't place on busy backgrounds without a container

---

## Accessibility Requirements

### Contrast Ratios (WCAG 2.1 AA)

| Combination | Ratio | Status |
|---|---|---|
| `textPrimary` on `background` | 15.4:1 | ✅ AAA |
| `textPrimary` on `surface` | 16.0:1 | ✅ AAA |
| `textSecondary` on `background` | 4.9:1 | ✅ AA |
| `textSecondary` on `surface` | 5.0:1 | ✅ AA |
| `textOnPrimary` on `primary` | 4.6:1 | ✅ AA |
| `textOnPrimary` on `secondary` | 4.6:1 | ✅ AA |
| `textTertiary` on `background` | 3.0:1 | ⚠️ AA (large text only) |
| `success` on `surface` | 4.5:1 | ✅ AA |
| `error` on `surface` | 4.6:1 | ✅ AA |

### Font Scaling

| Requirement | Implementation |
|---|---|
| Support system font scaling | Use `sp` units for all text sizes |
| Maximum scale factor | 2.0× (prevent layout breakage) |
| Minimum touch target | 44dp × 44dp |
| Text truncation | Use `maxLines` + `ellipsis`, never clip |

### Screen Reader Support

| Requirement | Implementation |
|---|---|
| All images have alt text | `Semantics` widget wrapping images |
| Buttons have labels | `tooltip` or `semanticsLabel` on `IconButton` |
| Quiz answers are announced | Custom `Semantics` with answer text |
| Score is announced | `Semantics(label: 'Yüzde 75')` |
| Navigation is labeled | `BottomNavigationBar` items have `label` |

### Motion Sensitivity

| Requirement | Implementation |
|---|---|
| Respect reduce motion | Check `MediaQuery.of(context).disableAnimations` |
| Provide alternative | Replace animations with instant transitions |
| No auto-playing video | Confetti only plays once on result screen |

### General Accessibility

1. **Minimum touch target**: 44dp × 44dp for all interactive elements
2. **Focus indicators**: 2dp `primary` ring on focused elements
3. **Error states**: Never rely on color alone — always include icon + text
4. **Answer feedback**: Correct (✓ icon + green) and wrong (✗ icon + red)
5. **Loading states**: Announce via `Semantics(liveRegion: true)`

---

## Flutter Implementation Notes

### Theme Configuration

```dart
class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      error: AppColors.error,
      onPrimary: AppColors.textOnPrimary,
      onSecondary: AppColors.textOnPrimary,
      onSurface: AppColors.textPrimary,
      onError: AppColors.textOnPrimary,
    ),
    textTheme: _buildTextTheme(),
    elevatedButtonTheme: _buildElevatedButtonTheme(),
    outlinedButtonTheme: _buildOutlinedButtonTheme(),
    inputDecorationTheme: _buildInputDecorationTheme(),
    cardTheme: _buildCardTheme(),
    bottomNavigationBarTheme: _buildBottomNavTheme(),
  );
}
```

### Color Constants

```dart
class AppColors {
  // Backgrounds
  static const background = Color(0xFFFAFAF8);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFF5F5F4);

  // Brand
  static const primary = Color(0xFF6366F1);
  static const primaryLight = Color(0xFF818CF8);
  static const primaryDark = Color(0xFF4F46E5);
  static const secondary = Color(0xFF8B5CF6);
  static const secondaryLight = Color(0xFFA78BFA);

  // Accents
  static const warmAccent = Color(0xFFF472B6);
  static const reward = Color(0xFFF59E0B);
  static const rewardLight = Color(0xFFFCD34D);
  static const success = Color(0xFF10B981);
  static const successLight = Color(0xFFD1FAE5);
  static const error = Color(0xFFEF4444);
  static const errorLight = Color(0xFFFEE2E2);

  // Text
  static const textPrimary = Color(0xFF1C1917);
  static const textSecondary = Color(0xFF78716C);
  static const textTertiary = Color(0xFFA8A29E);
  static const textOnPrimary = Color(0xFFFFFFFF);

  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
```
