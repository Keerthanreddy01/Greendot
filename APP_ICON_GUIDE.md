# App Icon Setup Guide

## Creating Your App Icon

To generate professional app icons for Greendot, follow these steps:

### Option 1: Use an Online Icon Generator (Recommended)
1. Visit: https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html
2. Upload a 512x512 PNG image with your logo (green leaf or farm-themed)
3. Set background color to `#4CAF50` (Green)
4. Download the generated icons
5. Extract and place the folders in `android/app/src/main/res/`

### Option 2: Use Canva or Design Tool
1. Create a 1024x1024 px design in Canva
2. Add a green leaf icon with "Greendot" text or just a leaf symbol
3. Export as PNG
4. Save to `assets/icon/app_icon.png`
5. Run: `flutter pub run flutter_launcher_icons`

### Option 3: Quick Setup (Manual)
1. Download a free farming/leaf icon from:
   - https://www.flaticon.com (search "farming" or "leaf")
   - https://icons8.com (search "agriculture")
2. Resize to 512x512 px using any image editor
3. Save as `assets/icon/app_icon.png`
4. Create a foreground version (transparent background) as `assets/icon/app_icon_foreground.png`
5. Run: `flutter pub run flutter_launcher_icons`

### Current Configuration
The app is configured in `pubspec.yaml` with:
- **App Name**: Greendot
- **Primary Color**: #4CAF50 (Green)
- **Theme**: Smart Farming Solutions

## After Creating Icons
Run these commands:
```bash
flutter pub get
flutter pub run flutter_launcher_icons
flutter clean
flutter build apk --release
```

Your icons will be automatically generated for all required sizes!
