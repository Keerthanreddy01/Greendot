<<<<<<< HEAD
<!-- Green Farm Assistant Banner (centered) -->
<div align="center">
  <h1>🌱 Green Farm Assistant</h1>
  <p><strong>Powered by Keerthan Reddy</strong></p>
</div>

---

<p align="center">
  <strong>🚀 Greendot – AI-Powered Farming Assistant</strong><br/>
  <em>Helping farmers optimize crop management with AI, multilingual support, and smart insights</em>
</p>

---

## 📖 Project Overview
The **Green Farm Assistant** is a Flutter-based mobile application designed to empower farmers with AI-assisted tools for plant disease detection, farm management, and agricultural guidance. The app integrates **real-time data**, **multi-language support**, and **intuitive dashboards** to improve farming efficiency and productivity.

**Key Purpose:**
- Provide farmers with actionable insights  
- Detect plant diseases via AI  
- Offer smart task management and market intelligence  

---

## 🎯 Core Features
### 1. App Launch & Onboarding
- Animated Splash Screen with app logo and key features  
- Multi-language support (12 Indian languages + English)  
- Demo Mode prompting language selection  
- Smooth animations (elastic, fade transitions)  

### 2. Home Screen – Farmer Dashboard
- Floating Popup Notifications for urgent alerts  
- Compact Header with branding & language selector  
- Weather Widget with farming guidance  
- Expandable Tasks section for daily activities  
- Quick Actions for core farming operations  
- Market Prices from 5 Telangana markets  
- Plant Health Monitoring with visual indicators  
- Seasonal Recommendations per current month  

### 3. Market Prices Feature
- Real-time crop prices (Rice, Cotton, Turmeric, Chilli, Maize)  
- Markets: Hyderabad APMC, Warangal, Nizamabad, Karimnagar, Khammam  
- Price trends with up/down indicators  
- Distance info for nearby markets  
- Scrollable horizontal cards  

### 4. Plant Health Monitoring
- AI-assisted plant health scores (e.g., Tomatoes 85%, Lettuce 95%)  
- Status indicators: Excellent, Good, Fair  
- Issue tracking: pest activity, fertilization, moisture levels  
- Location-based monitoring  

### 5. Smart Task Management
- Expandable task list with details  
- Priority levels (Urgent, High, Medium, Low)  
- Time slots & duration tracking  
- Interactive completion animations  
- Progress bars for task completion  

### 6. Advanced Notification System
- Floating popups for urgent alerts  
- Expandable dialogs with full details  
- Categorization: Disease, Weather, Harvest, Pest, Water alerts  
- Color-coded alerts and dismissible notifications  

---

## 🛠️ Technical Implementation
### Project Structure
```
lib/
├── main.dart
├── screens/
│   ├── splash_screen.dart
│   ├── language_selection_screen.dart
│   ├── home_screen.dart
│   ├── camera_scanner_screen.dart
│   ├── pro_tips_screen.dart
│   └── scan_result_screen.dart
├── providers/
│   └── language_provider.dart
├── services/
│   ├── notification_service.dart
│   └── schedule_store.dart
├── widgets/
│   ├── bottom_navigation.dart
│   ├── weather_card.dart
│   └── treatment_item.dart
└── l10n/   # Localization files (13 languages)
```

### Dependencies & Technologies
- `Flutter` SDK, `Dart`  
- `flutter_localizations`, `shared_preferences`  
- `camera`, `image_picker`, `http`  
- `flutter_local_notifications`, `permission_handler`, `geolocator`  
- `cached_network_image`, `flutter_spinkit`, `fluttertoast`, `lottie`  

---

## 🎨 UI/UX Design
- Farmer-first approach with minimal cognitive load  
- Modern Material Design, gradient backgrounds, rounded corners  
- Color-coded info: Green = good, Red = urgent, Blue = info  
- Grid-based layout, horizontal scrollable cards, expandable sections  
- Accessibility: screen-reader friendly, large touch targets, haptic feedback  

---

## 🌍 Localization & Accessibility
- 13 languages supported: English, Hindi, Telugu, Tamil, Kannada, Malayalam, Marathi, Gujarati, Bengali, Punjabi, Odia, Assamese  
- Accessibility: text overflow handling, high contrast, large touch targets  

---

## 📊 Data & State Management
- `SharedPreferences` for settings & language preferences  
- Local storage for tasks & notifications  
- Real-time updates using `setState()`  
- Dynamic language selection & progress tracking  

---

## 🚀 Key Innovations
- Floating popup notifications for urgent alerts  
- Expandable task management for reduced cognitive load  
- Real-time market integration for decision-making  
- Multi-language plant health analysis  
- Seasonal intelligence for context-aware guidance  

---

## 🎯 Target Users & Use Cases
- Small-scale farmers (Telugu regions)  
- Agricultural extension workers & farm consultants  
- Agricultural students & researchers  

**Use Cases:**
- Daily farm monitoring (tasks, weather, plant health)  
- Disease detection (AI camera-based analysis)  
- Market intelligence (price trends)  
- Learning & guidance (seasonal tips & pro advice)  
- Task management with reminders  

---

## 📈 Current Status & Next Steps
**Completed:**
- Full UI/UX system  
- Multi-language support  
- Home dashboard & market integration  
- Notifications & task management  

**Planned:**
- AI camera-based disease detection  
- Real API integration for market prices  
- Push notifications & user authentication  
- Data synchronization & backup  

---

## 🎉 Project Highlights
- 2,672 lines of Flutter code  
- Production-ready UI with zero design flaws  
- 13-language localization  
- Scalable and maintainable architecture  
- Demo-ready mode for hackathon presentation  

---

## 📚 References
- [Flutter Documentation](https://flutter.dev/docs)  
- [Firebase Documentation](https://firebase.google.com/docs)  
- Agricultural datasets & resources  

---

## 🖼️ Assets / Screenshots
<p align="center">
  <img src="assets/logo.png" alt="App Logo" width="220" /><br/>
  <img src="assets/screenshot1.png" alt="Home Screen" width="600" />
</p>

---

<p align="center">
  <b>Hackathon:</b> AIGNITE 2K25 | Organized by MLSC<br/>
</p>
=======
# GreenDot
Flutter App
>>>>>>> a686d1d829f188fc5c47fab47f6ebe4c74622244
