# Greendot - Release APK Build Guide

## ✅ Pre-Build Checklist

### 1. App is Ready for Release
- ✅ Firebase Authentication working (Email/Password + Google Sign-in)
- ✅ All screens enhanced with modern UI
- ✅ App name updated to "Greendot" everywhere
- ✅ Splash screen with smooth animations
- ✅ Updated package versions (Firebase packages to latest)

### 2. Important Changes Made
- **Package Name**: `greendot` (updated from `green_farm_app`)
- **App Label**: "Greendot"
- **Version**: 1.0.0+1
- **Min SDK**: 26 (Android 8.0+)
- **Target SDK**: Latest

## 🚀 Building Release APK

### Step 1: Clean the Project
```powershell
flutter clean
flutter pub get
```

### Step 2: Build Release APK
```powershell
flutter build apk --release
```

This will create the APK at:
```
build\app\outputs\flutter-apk\app-release.apk
```

### Step 3: Test the APK
1. Transfer the APK to your phone via:
   - USB cable
   - Email
   - Google Drive
   - Or any file sharing method

2. Install on your device:
   - Enable "Install from Unknown Sources" in Settings
   - Tap the APK file to install
   - Test all features:
     * Splash screen animation
     * Language selection
     * Login with Email/Password
     * Login with Google
     * Home screen navigation
     * All features working

### Step 4: Share with Friends
Once tested, you can share the APK file via:
- WhatsApp
- Email
- Google Drive
- File sharing apps

## 📱 APK Size Optimization (Optional)

### Build Split APKs (Smaller Size)
```powershell
flutter build apk --split-per-abi --release
```

This creates 3 APKs for different device architectures:
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM - most common)
- `app-x86_64-release.apk` (Intel chips)

**Recommendation**: Share the `app-arm64-v8a-release.apk` for most modern phones.

## 🔧 Troubleshooting

### Issue: Build Fails
```powershell
flutter clean
flutter pub get
flutter build apk --release --verbose
```

### Issue: APK Won't Install
- Make sure "Install from Unknown Sources" is enabled
- Check if you have enough storage
- Uninstall any previous version first

### Issue: Google Sign-in Not Working in Release
This is expected! You need to:
1. Get the release SHA-1 fingerprint
2. Add it to Firebase Console
3. Download updated google-services.json

**For now, the debug APK works fine for testing with friends!**

## 📋 Release APK vs Debug APK

| Feature | Debug APK | Release APK |
|---------|-----------|-------------|
| Size | Larger (~60MB) | Smaller (~20MB) |
| Performance | Slower | Faster |
| Google Sign-in | ✅ Works | Needs Release SHA-1 |
| Good for | Testing | Production |

## 🎯 Quick Build Command (Recommended for Sharing)

```powershell
flutter build apk --release
```

The APK will be at: `build\app\outputs\flutter-apk\app-release.apk`

## 🌟 Future Steps (For Play Store)

If you want to publish on Google Play Store:
1. Create a keystore for signing
2. Update build.gradle with signing config
3. Build App Bundle (AAB): `flutter build appbundle --release`
4. Upload to Play Store Console

For now, sharing the APK file with friends is perfectly fine!

## 📞 Support

If you face any issues:
1. Check the error messages
2. Run `flutter doctor` to check your setup
3. Review Firebase configuration
4. Check internet connection

---

**Made with ❤️ by Applynk Studio**
**App Version: 1.0.0**
