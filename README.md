# � Green Life: Advanced Agricultural Intelligence

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)](https://firebase.google.com)
[![Gemini AI](https://img.shields.io/badge/Gemini_AI-4285F4?style=for-the-badge&logo=google&logoColor=white)](https://ai.google.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

**Green Life** is a production-grade agricultural ecosystem designed to empower farmers with state-of-the-art AI technology, real-time market data, and personalized farming insights. It bridges the gap between traditional farming and modern intelligence.

---

## ✨ Key Features

### 🔍 AI-Powered Disease Detection
Identify crop diseases instantly using our proprietary vision system powered by **Google Gemini AI**.
- **Real-time Scanning:** Point your camera at a plant and get an immediate diagnosis.
- **Deep Analysis:** Detailed symptoms, causes, and step-by-step treatment plans (Organic & Chemical).
- **Proactive Prevention:** Expert advice on how to prevent future outbreaks.

### 📊 Real-time Mandi Prices
Stay ahead of the market with live price feeds from across India.
- **Localized Data:** Filter by state, district, and crop types.
- **Trend Analysis:** Visual indicators showing whether prices are rising, falling, or stable.
- **Smart Search:** Quickly find the best markets for your harvest near you.

### �️ Multilingual Voice Assistant (Kisan)
Our AI assistant, **Kisan**, speaks your language.
- **Natural Language:** Ask questions about farming practices, weather, or prices in English, Hindi, Telugu, and more.
- **Context Aware:** Provides specific advice based on your local weather and farm conditions.

### � Government Schemes
Never miss out on financial support or subsidies.
- **Simplified Guides:** Easy-to-understand explanations of central and state schemes.
- **Application Tracking:** Direct links and documentation requirements for critical schemes.

### ☁️ Cloud Sync & Offline Access
- **Secure Profiles:** All your farm data and scan history are safely synced with Firebase.
- **Guest Mode:** Use essential features without the need for an account.

---

## 🛠️ Tech Stack

- **Core:** [Flutter](https://flutter.dev) & [Dart](https://dart.dev)
- **Backend:** [Firebase Authentication](https://firebase.google.com/docs/auth), [Cloud Firestore](https://firebase.google.com/docs/firestore), [Firebase Storage](https://firebase.google.com/docs/storage)
- **AI Core:** [Google Gemini 1.5 Flash](https://ai.google.dev/) (Vision & Conversational)
- **ML Integration:** [TFLite](https://www.tensorflow.org/lite) (Edge-computing fallback)
- **Local Cache:** [shared_preferences](https://pub.dev/packages/shared_preferences) & [sqflite](https://pub.dev/packages/sqflite)

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (v3.0.0+)
- Android Studio / VS Code
- A Gemini API Key from [Google AI Studio](https://aistudio.google.com/)

### Setup

1. **Clone the Repository**
   ```bash
   git clone https://github.com/Keerthanreddy01/GreenLife.git
   cd GreenLife
   ```

2. **Environment Configuration**
   Create a `.env` file in the root directory based on `.env.example`:
   ```env
   GEMINI_API_KEY=your_actual_key_here
   GOOGLE_SERVER_CLIENT_ID=your_client_id_here
   ```

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the Application**
   ```bash
   # Run for Android/iOS
   flutter run
   ```

---

## 🏗️ Architecture

The project follows a **Modified Clean Architecture** with a focus on high performance and testability:

- **`lib/features/`**: Domain-specific logic (e.g., AI Analysis, Market Data).
- **`lib/providers/`**: Application state management using the Provider pattern.
- **`lib/services/`**: Infrastructure layer for API calls and Firebase operations.
- **`lib/localization/`**: 10+ Indian languages support.
- **`lib/widgets/`**: Reusable premium UI components.

---

## �️ Roadmap
- [ ] **AI-Based Yield Forecasting:** Predictive analytics for harvest yields.
- [ ] **IoT Sensor Integration:** Real-time soil moisture and PH monitoring.
- [ ] **Community Forum:** A peer-to-peer knowledge sharing platform.
- [ ] **Pest Control Marketplace:** Direct linkage to local agricultural product suppliers.

---

## 🤝 Contributing
Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## � License
Distributed under the MIT License. See `LICENSE` for more information.

---

<p align="center">
  <b>Made with ❤️ by Applynk Studio</b>
</p>
