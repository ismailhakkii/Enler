# App Store Checklist

> Enler — iOS App Store & Google Play Store Submission Guide

---

## Table of Contents

- [Common Assets](#common-assets)
- [iOS App Store](#ios-app-store)
- [Google Play Store](#google-play-store)
- [Pre-Submission Checklist](#pre-submission-checklist)
- [Post-Submission](#post-submission)

---

## Common Assets

These assets are shared between both stores.

### App Icon

| Property | Specification |
|----------|--------------|
| Size | 1024×1024 px |
| Format | PNG (no alpha/transparency) |
| Shape | Square (stores apply rounding) |
| Design | Enler logo on Soft Aurora gradient (#6366F1 → #8B5CF6) |
| File | `assets/store/app_icon_1024.png` |

### App Information

| Property | Value |
|----------|-------|
| App Name | **Enler** |
| Publisher | **CodeBros** |
| Category (Primary) | Social Networking |
| Category (Secondary) | Entertainment |
| Age Rating | 4+ (Everyone) |
| Website | https://enlerapp.com |
| Support URL | https://enlerapp.com/support |
| Privacy Policy | https://enlerapp.com/privacy |
| Terms of Service | https://enlerapp.com/terms |
| Contact Email | support@enlerapp.com |

### Brand Colors for Store Assets

| Usage | Color |
|-------|-------|
| Primary gradient start | #6366F1 (Indigo) |
| Primary gradient end | #8B5CF6 (Violet) |
| Background | #FAFAF8 (Warm White) |
| Accent | #F472B6 (Coral Pink) |
| Text on dark | #FFFFFF |
| Text on light | #1C1917 |

---

## iOS App Store

### App Store Connect Metadata

| Field | Value |
|-------|-------|
| Bundle ID | `com.codebros.enler` |
| SKU | `enler-ios` |
| App Name | `Enler` |
| Subtitle | `Arkadaşını Ne Kadar Tanıyorsun?` |
| Primary Language | Turkish (tr) |
| Primary Category | Social Networking |
| Secondary Category | Entertainment |
| Content Rights | Does not contain third-party content |
| Age Rating | 4+ |

### Keywords (Turkish ASO)

> Maximum 100 characters, comma-separated.

```
arkadaş,quiz,tanımak,bilmece,test,eğlence,profil,soru,oyun,sosyal,tahmin,kanka
```

**Keyword Strategy:**
- `arkadaş` — Core concept (friend)
- `quiz` — Game type (universal)
- `tanımak` — Core action (to know someone)
- `bilmece` — Related concept (riddle/puzzle)
- `test` — Related concept (test)
- `eğlence` — Category (entertainment/fun)
- `profil` — Feature (profile)
- `soru` — Feature (question)
- `oyun` — Category (game)
- `sosyal` — Category (social)
- `tahmin` — Action (guess)
- `kanka` — Slang for close friend

### Description (Turkish)

```
Arkadaşlarınızı gerçekten ne kadar iyi tanıyorsunuz? Enler ile öğrenin!

🎯 PROFİLİNİZİ OLUŞTURUN
En sevdiğiniz şeyler, kişilik özellikleriniz ve hayalleriniz hakkında sorular ekleyin. Favori renginizden hayat mottonuza kadar — sizi tanımlayan her şeyi paylaşın.

🧠 ARKADAŞLARINIZI TEST EDİN
Profilinizi arkadaşlarınızla paylaşın ve onların sizi ne kadar iyi tanıdığını görün. Her doğru cevap, arkadaşlığınızın gücünü gösterir!

🏆 ROZETLER KAZANIN
Yabancı'dan Ruh İkizi'ne kadar — ne kadar doğru cevaplarsanız, o kadar yüksek rozet kazanırsınız. %100 yapabilir misiniz?

📊 LIDERLIK TABLOSU
Kim sizi en iyi tanıyor? Canlı liderlik tablosunda arkadaşlarınızın sıralamasını görün.

📤 SONUÇLARI PAYLAŞIN
Güzel paylaşım kartlarıyla sonuçlarınızı sosyal medyada paylaşın ve arkadaşlarınızı da quiz'e davet edin.

Enler — Arkadaşlığın gerçek testi! 💜
```

### Description (English — Secondary)

```
How well do your friends really know you? Find out with Enler!

🎯 CREATE YOUR PROFILE
Add questions about your favorites, personality traits, and dreams. From your favorite color to your life motto — share everything that defines you.

🧠 QUIZ YOUR FRIENDS
Share your profile with friends and see how well they know you. Every correct answer shows the strength of your friendship!

🏆 EARN BADGES
From Stranger to Soulmate — the more correct answers, the higher the badge. Can you score 100%?

📊 LEADERBOARD
Who knows you best? See your friends' rankings on the live leaderboard.

📤 SHARE RESULTS
Share your results on social media with beautiful share cards and invite friends to take the quiz.

Enler — The real test of friendship! 💜
```

### Screenshots

#### Required Sizes

| Device | Size (px) | Required |
|--------|-----------|----------|
| iPhone 6.7" (15 Pro Max) | 1290×2796 | ✅ Yes |
| iPhone 6.5" (11 Pro Max) | 1284×2778 | ✅ Yes |
| iPhone 5.5" (8 Plus) | 1242×2208 | ✅ Yes |
| iPad Pro 12.9" (6th gen) | 2048×2732 | ⬜ Optional (v1.1) |

#### Screenshot Content Plan (5 screenshots)

| # | Screen | Caption (TR) | Key Elements |
|---|--------|-------------|--------------|
| 1 | Profile | "Profilini Oluştur" | Profile screen with filled questions, avatar |
| 2 | Quiz | "Arkadaşını Test Et" | Quiz question with 4 answer options |
| 3 | Results | "Sonucunu Gör" | Score screen with badge and confetti |
| 4 | Share Card | "Paylaş ve Meydan Oku" | Gradient share card with score |
| 5 | Leaderboard | "Seni Kim Tanıyor?" | Leaderboard with ranked friends |

#### Screenshot Design Guidelines

- Background: Soft Aurora gradient or #FAFAF8
- Device frame: iPhone 15 Pro (for 6.7" set)
- Title text: Bold, 48pt, #1C1917
- Subtitle text: Regular, 24pt, #78716C
- Show actual app UI in device frame
- All text in Turkish

### App Review Information

#### Review Notes

```
Enler is a social quiz app where users create profiles with personal questions
and friends take quizzes to test how well they know each other.

To test the app:
1. Sign in with the test account below
2. The test account has a pre-filled profile with questions
3. You can take a quiz about the test profile to see the full flow
4. After completing the quiz, you'll see the score and badge

The app uses AI (Google Gemini) to generate wrong answer choices for quiz
questions. This enhances gameplay by providing plausible distractors.
No user-generated content is shown to other users without the creator's intent.
```

#### Test Account

| Field | Value |
|-------|-------|
| Email | `review@codebros.dev` |
| OTP Code | *(will be configured for auto-approve in test)* |
| Username | `test_user` |

#### Demo Credentials Note

> Since the app uses Magic Link auth, set up a test account with a known OTP
> in Supabase dashboard under Authentication > Users before submission.

### App Privacy

#### Privacy Nutrition Label

| Data Type | Collected | Linked to Identity | Tracking |
|-----------|-----------|-------------------|----------|
| Email Address | ✅ | ✅ | ❌ |
| User ID | ✅ | ✅ | ❌ |
| Display Name | ✅ | ✅ | ❌ |
| Photos (avatar) | ✅ | ✅ | ❌ |
| Gameplay Content | ✅ | ✅ | ❌ |
| Crash Data | ✅ | ❌ | ❌ |
| Performance Data | ✅ | ❌ | ❌ |

#### Purposes

| Purpose | Data Types |
|---------|-----------|
| App Functionality | Email, User ID, Display Name, Photos, Gameplay Content |
| Analytics | Crash Data, Performance Data |

---

## Google Play Store

### Play Console Metadata

| Field | Value |
|-------|-------|
| Package Name | `com.codebros.enler` |
| App Name | `Enler` |
| Default Language | Turkish (tr-TR) |
| App Type | App |
| Category | Social |
| Content Rating | Everyone |
| Target Audience | 13+ (not designed for children) |

### Short Description (TR, max 80 chars)

```
Arkadaşını ne kadar tanıyorsun? Quiz oluştur, meydan oku, rozetler kazan! 💜
```

### Full Description (TR, max 4000 chars)

```
Arkadaşlarınızı gerçekten ne kadar iyi tanıyorsunuz? Enler ile öğrenin!

🎯 PROFİLİNİZİ OLUŞTURUN
En sevdiğiniz şeyler, kişilik özellikleriniz ve hayalleriniz hakkında sorular ekleyin. Favori renginizden hayat mottonuza kadar — sizi tanımlayan her şeyi paylaşın.

🧠 ARKADAŞLARINIZI TEST EDİN
Profilinizi arkadaşlarınızla paylaşın ve onların sizi ne kadar iyi tanıdığını görün. Her doğru cevap, arkadaşlığınızın gücünü gösterir!

🏆 ROZETLER KAZANIN
• Yabancı — Daha çok tanışmanız lazım!
• Tanıdık — İyi bir başlangıç
• Arkadaş — Gerçek bir arkadaşsın
• Yakın Arkadaş — Seni iyi tanıyor!
• Can Dostu — Neredeyse mükemmel
• Ruh İkizi — %100 doğru! Gerçek bir ruh ikizi

📊 CANLI LİDERLİK TABLOSU
Kim sizi en iyi tanıyor? Canlı liderlik tablosunda arkadaşlarınızın sıralamasını görün. Anlık güncellenen sonuçlarla yarışı takip edin.

📤 PAYLAŞIN VE MEYDAN OKUYIN
Güzel paylaşım kartlarıyla sonuçlarınızı Instagram, WhatsApp, Twitter ve diğer platformlarda paylaşın. Arkadaşlarınızı da quiz'e davet edin ve kimin sizi daha iyi tanıdığını keşfedin.

✨ ÖZELLİKLER
• Kolay profil oluşturma
• 5 kategori: Favoriler, Kişilik, Anılar, Tercihler, Hayaller
• Yapay zeka destekli quiz soruları
• Anlık sonuçlar ve rozetler
• Güzel paylaşım kartları
• Canlı liderlik tablosu
• Tamamen ücretsiz

Enler — Arkadaşlığın gerçek testi! 💜

İletişim: support@enlerapp.com
Web: https://enlerapp.com
```

### Feature Graphic

| Property | Specification |
|----------|--------------|
| Size | 1024×500 px |
| Format | PNG or JPEG |
| Design | Soft Aurora gradient with app name, tagline, and app mockup |
| Tagline | "Arkadaşını Ne Kadar Tanıyorsun?" |
| File | `assets/store/feature_graphic.png` |

### Screenshots

#### Required Sizes

| Device Type | Minimum Size | Count | Required |
|-------------|-------------|-------|----------|
| Phone | 320–3840 px (min side), 16:9 or 9:16 | 2–8 | ✅ Yes |
| 7" Tablet | 1024×500 min | 0–8 | ⬜ Optional |
| 10" Tablet | 1024×500 min | 0–8 | ⬜ Optional |

#### Recommended Phone Screenshot Size

**1080×1920 px** (or 1284×2778 px for high-res)

#### Screenshot Content

Same 5 screenshots as iOS (see [Screenshot Content Plan](#screenshot-content-plan-5-screenshots)).

### Content Rating (IARC Questionnaire)

| Question | Answer |
|----------|--------|
| Violence | No |
| Sexual Content | No |
| Language | No crude language |
| Controlled Substances | No |
| User Interaction | Yes (share content) |
| Shares User Location | No |
| In-App Purchases | No (v1.0) |
| Ads | No |

**Expected Rating:** Everyone / PEGI 3 / USK 0

### Data Safety Form

#### Data Collected

| Data Type | Collected | Shared | Purpose |
|-----------|-----------|--------|---------|
| Email address | ✅ | ❌ | Account management |
| User IDs | ✅ | ❌ | Account management |
| Name (display) | ✅ | ❌ | App functionality |
| Photos (avatar) | ✅ | ❌ | App functionality |
| Other user-generated content | ✅ | ❌ | App functionality |
| Crash logs | ✅ | ❌ | Analytics |
| Performance diagnostics | ✅ | ❌ | Analytics |
| Other app activity | ✅ | ❌ | Analytics |

#### Security Practices

| Practice | Status |
|----------|--------|
| Data encrypted in transit | ✅ Yes (HTTPS/TLS) |
| Data can be deleted | ✅ Yes (account deletion) |
| Data deletion request | Via app settings or email |
| Independent security review | ❌ No |

#### Declarations

- [ ] App complies with Google Play Families Policy: **N/A** (not targeting children)
- [x] App complies with Google Play Developer Program Policies
- [x] App provides a way for users to request data deletion

### Store Listing Experiments

Plan A/B tests for:
- App icon variants (gradient direction, logo style)
- Short description (emoji vs. no emoji)
- Screenshot order

---

## Pre-Submission Checklist

### Code & Build

- [ ] All tests passing (unit, widget, integration)
- [ ] No compiler warnings
- [ ] Release build succeeds (iOS + Android)
- [ ] App size under 100 MB
- [ ] ProGuard/R8 rules configured (Android)
- [ ] Bitcode enabled (iOS) — if required
- [ ] Minimum OS versions set (iOS 15.0, Android API 24)
- [ ] All debug flags removed
- [ ] Analytics/crash reporting configured for production
- [ ] Environment variables set to production values

### Assets & Metadata

- [ ] App icon generated (all required sizes)
- [ ] Splash screen configured
- [ ] Screenshots captured for all required sizes
- [ ] Feature graphic created (Google Play)
- [ ] Store descriptions written (TR + EN)
- [ ] Keywords optimized
- [ ] Privacy policy page live at enlerapp.com/privacy
- [ ] Terms of service page live at enlerapp.com/terms
- [ ] Support URL live at enlerapp.com/support

### iOS Specific

- [ ] Apple Developer account active ($99/year)
- [ ] Bundle ID registered: `com.codebros.enler`
- [ ] Provisioning profiles created (distribution)
- [ ] Push notification certificates configured
- [ ] Associated Domains configured (for deep links)
- [ ] App Transport Security (ATS) compliant
- [ ] Export compliance (uses encryption: HTTPS only = exempt)
- [ ] Privacy nutrition labels filled in App Store Connect
- [ ] Test account created for App Review

### Android Specific

- [ ] Google Play Console account active ($25 one-time)
- [ ] App signing key generated and backed up securely
- [ ] Google Play App Signing enrolled
- [ ] AAB (Android App Bundle) format used
- [ ] Deep link intent filters configured
- [ ] Data safety form completed
- [ ] Content rating questionnaire completed
- [ ] Target API level meets Play Store requirements (API 34+)

### Legal & Compliance

- [ ] Privacy policy covers all collected data
- [ ] Terms of service cover user-generated content
- [ ] KVKK (Turkish data protection) compliance reviewed
- [ ] GDPR compliance (if targeting EU users)
- [ ] Copyright for all assets verified
- [ ] Third-party licenses included (open source)

---

## Post-Submission

### Apple App Review

| Item | Timeline |
|------|----------|
| Initial review | 1–3 business days |
| Common rejection reasons | Missing privacy policy, insufficient metadata, crashes |
| Appeal process | Via Resolution Center in App Store Connect |

### Google Play Review

| Item | Timeline |
|------|----------|
| Initial review | Hours to 7 days |
| Common rejection reasons | Data safety form issues, metadata policy |
| Appeal process | Via Play Console > Policy Status |

### Launch Day Checklist

- [ ] Monitor crash reports (Crashlytics / Sentry)
- [ ] Monitor Supabase dashboard for errors
- [ ] Respond to first user reviews within 24 hours
- [ ] Share launch announcement on social media
- [ ] Monitor app store ranking for target keywords
- [ ] Verify deep links work from social media shares
- [ ] Verify OG images render correctly on all platforms
