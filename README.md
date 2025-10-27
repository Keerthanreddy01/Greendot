lib/
├── main.dart
├── screens/
│   ├── splash_screen.dart
│   ├── language_selection_screen.dart
│   ├── home_screen.dart
│   ├── camera_scanner_screen.dart
│   ├── market_screen.dart
│   └── scan_result_screen.dart
├── providers/
│   ├── language_provider.dart
│   ├── task_provider.dart
│   └── weather_provider.dart
├── services/
│   ├── ai_service.dart            # TensorFlow Lite inference
│   ├── notification_service.dart
│   ├── api_service.dart           # Market + Weather
│   └── schedule_store.dart
├── widgets/
│   ├── bottom_navigation.dart
│   ├── weather_card.dart
│   ├── price_chart.dart
│   └── treatment_item.dart
└── l10n/
    └── app_*.arb
    
🧠 AI & ML Integration Pipeline
🌾 Plant Disease Detection Model
graph TD
A[📷 Capture Image] --> B[🧮 Preprocessing (resize, normalize)]
B --> C[🧠 TensorFlow Lite Inference]
C --> D[📋 Prediction (Disease Name + Confidence)]
D --> E[💊 Treatment Recommendation Engine]
E --> F[📱 UI Output in User’s Language]


Model: TensorFlow Lite CNN (trained on Indian crop dataset)

Accuracy: ~93% on major leaf diseases

Offline Mode: Runs locally using TFLite

Future: Cloud-assisted model updates (Firebase ML)
