# 🌱 Green Farm Assistant — Greendot

## 🚀 Greendot – AI-Powered Farming Assistant

**Helping small-scale farmers optimize crop management with AI-driven insights, multilingual support, and practical farm tools.**

---

### 🏆 AIGNITE 2K25 Hackathon Submission | Built by: Keerthan Reddy

---

## 📖 Project Overview

**Green Farm Assistant (Greendot)** is a cross-platform **Flutter** mobile application focused on empowering smallholder farmers through easy-to-use AI tools, actionable guidance, and localised market intelligence.

**Core value:** give farmers concise, trustworthy, and timely recommendations so they can make better decisions and reduce crop loss.

**Primary capabilities:** plant disease detection via camera, smart task scheduling, real-time market prices, and multi-language support (13 languages).

### ✅ Goals

* Deliver **actionable, localized insights** based on weather, seasonality, and crop stage.
* Enable **on-device AI** for fast plant health checks and offline-first usability.
* Provide **market intelligence** so farmers can choose when and where to sell crops for better returns.
* Offer an approachable UI/UX tailored for users with limited literacy and intermittent connectivity.

---

## 🎯 Key Features & Innovations

### 📱 Farmer Dashboard

A compact Home Screen showing:

* Expandable task cards (priority, due date, progress)
* Weather guidance and short-term advisories
* Seasonal crop recommendations and quick actions (scan plant, log expense, list harvest)

### 🌿 AI Plant Health Monitoring

* Camera-based AI scores (e.g., *Tomato — 85% healthy*) and clear status labels: **Excellent / Good / Fair / Needs Attention**.
* Detects common issues: pest damage, nutrient deficiency, irrigation problems.
* On-device inference for privacy and offline capability; multi-language explanations.

### 💰 Real-Time Market Intelligence

* Prices and trend summaries for primary crops: **Rice, Cotton, Turmeric, Chilli, Maize**.
* Aggregates data for **5 Telangana markets** (e.g., Hyderabad APMC, Warangal) and shows distance to market.
* Visual trend sparkline and price alert (price above/below threshold).

### 🔔 Smart Task & Notification System

* Task priority levels: **Urgent / High / Medium / Low** with progress tracking.
* Floating alerts for urgent events (disease outbreak, severe weather, harvest window).
* Color-coded categories for quick scanning.

### 🌐 Localization & Accessibility

* **13-language** support: English + 12 major Indian languages (Hindi, Telugu, Tamil, Kannada, Marathi, Malayalam, Gujarati, Bengali, Punjabi, Odia, Assamese, Urdu).
* Farmer-first UI: large touch targets, high-contrast fonts, icons, audio prompts and haptic feedback.

---

## 🛠 Technical Implementation

**Stack:** Flutter (Dart) — single codebase for Android/iOS.

**Status summary:**

* **Completed:** Full UI/UX, multi-language support (13 languages), task & notification management, demo-ready flows.
* **Planned / In progress:** AI camera integration (on-device model), live market price APIs, user auth & cloud sync, push notifications, analytics.

**Key dependencies**

* Data & state: `shared_preferences`, `http`.
* Device I/O: `camera`, `image_picker`, `geolocator`, `permission_handler` (planned).
* Notifications & animations: `flutter_local_notifications`, `lottie`.

**Project size:** ~2,672 lines of Flutter code — modular, provider-based state management, and reusable widgets.

**Project structure (simplified)**

```
lib/
├── main.dart
├── screens/         # home, splash, scanner, pro_tips
├── providers/       # language_provider.dart, task_provider.dart
├── services/        # notification_service.dart, schedule_store.dart
├── widgets/         # weather_card.dart, bottom_navigation.dart
└── l10n/            # localization files (13 languages)
```

---

## 📸 Assets & Demo

Include app logo and screenshots in `/assets`:

* `assets/logo.png` — App logo
* `assets/screenshot1.png` — Home Screen

*(Screenshots included in the repo for the demo build.)*

---

## 📄 How to Run (Demo)

1. Clone the repo.
2. Install Flutter SDK and required plugins.
3. `flutter pub get` to fetch dependencies.
4. Run on device/emulator: `flutter run`.

*(Include `assets/` and `l10n/` in project root for proper demo.)*

---

## 🧾 Contribution & License

© 2025 Keerthan Reddy. All rights reserved.
Open to collaboration for dataset collection, model improvement, and local partnerships.

---

