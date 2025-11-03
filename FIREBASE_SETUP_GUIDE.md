# Firebase Integration Guide for Greendot App

This guide explains how to set up Firebase for your Greendot farming application.

## 🔥 Firebase Services Integrated

- **Firebase Authentication** - Email/Password and Google Sign-in
- **Cloud Firestore** - User data and app data storage
- **Firebase Storage** - Image uploads (plant photos, profile pictures)

## 📋 Prerequisites

1. Flutter SDK installed
2. Google account
3. Android Studio or VS Code with Flutter extension

## 🚀 Setup Instructions

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: `greendot-farming` (or your preferred name)
4. Enable/Disable Google Analytics (optional)
5. Click "Create project"

### Step 2: Add Android App

1. In Firebase Console, click the Android icon to add an Android app
2. Enter Android package name: `com.applynk.green_farm_app` (or check your `android/app/build.gradle.kts` file for the exact package name)
3. Enter app nickname: `Greendot Android`
4. Leave SHA-1 blank for now (we'll add it later for Google Sign-in)
5. Click "Register app"
6. Download `google-services.json`
7. Place it in `android/app/` directory

### Step 3: Configure Android

The Android configuration is already set up in the code, but verify these files exist:

**File: `android/build.gradle.kts`**
```kotlin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.0")
    }
}
```

**File: `android/app/build.gradle.kts`**
```kotlin
plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Add this line
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:32.7.0"))
}
```

### Step 4: Add iOS App (Optional)

1. In Firebase Console, click the iOS icon
2. Enter iOS bundle ID: `com.applynk.greenFarmApp`
3. Download `GoogleService-Info.plist`
4. Place it in `ios/Runner/` directory
5. Open Xcode and add the file to Runner target

### Step 5: Enable Authentication Methods

1. In Firebase Console, go to **Authentication**
2. Click **Get started**
3. Go to **Sign-in method** tab
4. Enable **Email/Password**
5. Enable **Google** sign-in
   - Enter project public-facing name: "Greendot"
   - Enter support email: your email
   - Click Save

### Step 6: Set up Firestore Database

1. In Firebase Console, go to **Firestore Database**
2. Click **Create database**
3. Choose **Start in test mode** (for development)
4. Select your preferred location
5. Click **Enable**

**Important:** Before production, update Firestore security rules:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Other collections can be added here
  }
}
```

### Step 7: Set up Firebase Storage

1. In Firebase Console, go to **Storage**
2. Click **Get started**
3. Choose **Start in test mode**
4. Click **Done**

**Important:** Before production, update Storage security rules:
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /user_profiles/{userId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /plant_images/{userId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### Step 8: Configure Firebase with FlutterFire CLI (Recommended)

The easiest way to configure Firebase is using FlutterFire CLI:

1. Install FlutterFire CLI:
```bash
dart pub global activate flutterfire_cli
```

2. Run the configuration command:
```bash
flutterfire configure
```

3. Select your Firebase project
4. Select platforms (Android, iOS, Web)
5. This will automatically generate `firebase_options.dart` with your configuration

**OR** manually update `lib/firebase_options.dart` with your Firebase project credentials from Firebase Console > Project Settings.

### Step 9: Get SHA-1 for Google Sign-in (Android)

1. Open terminal in your project root
2. Run (Windows):
```powershell
cd android
./gradlew signingReport
```

3. Find the SHA-1 fingerprint under `Task :app:signingReport`
4. Copy the SHA-1 value
5. Go to Firebase Console > Project Settings > Your Android App
6. Add the SHA-1 fingerprint
7. Download new `google-services.json` and replace the old one

### Step 10: Install Dependencies

Run in your project root:
```bash
flutter pub get
```

### Step 11: Test the Integration

1. Run the app:
```bash
flutter run
```

2. Try signing up with email/password
3. Try signing in with Google
4. Check Firebase Console to see if users are being created

## 📱 App Flow with Firebase

```
SplashScreen (5 seconds)
    ↓
Check Language Selected?
    ├─ No → Language Selection Screen
    └─ Yes → Check Firebase Auth
                ├─ Logged In → Home Screen
                └─ Not Logged In → Login Screen
                        ├─ Sign In → Home Screen
                        ├─ Sign Up → Home Screen
                        └─ Forgot Password → Reset Email Sent
```

## 🔧 Firestore Data Structure

### Users Collection
```javascript
users/{userId}
  - userId: string
  - email: string
  - name: string
  - createdAt: timestamp
  - updatedAt: timestamp
  - photoUrl: string (optional)
  - phoneNumber: string (optional)
  - location: string (optional)
  - farmSize: string (optional)
  - crops: array (optional)
```

## 🖼️ Firebase Storage Structure

```
/user_profiles/{userId}/
  - profile_picture.jpg
  
/plant_images/{userId}/
  - {timestamp}_{userId}.jpg
```

## 🔐 Security Best Practices

1. **Never commit** `google-services.json` or API keys to public repositories
2. Add to `.gitignore`:
```
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
```

3. Use **environment variables** for sensitive data in production
4. Update **Firestore and Storage rules** before deploying to production
5. Enable **App Check** in Firebase Console for additional security

## 🧪 Testing

### Test Email/Password Sign-in:
1. Open app → Login Screen
2. Click "Sign Up"
3. Enter name, email, password
4. Click "Sign Up"
5. Should navigate to Home Screen
6. Check Firebase Console > Authentication > Users

### Test Google Sign-in:
1. Open app → Login Screen
2. Click "Sign in with Google"
3. Select Google account
4. Should navigate to Home Screen

### Test Firestore:
```dart
// In your code, user data is automatically created on signup
// Check Firebase Console > Firestore Database > users collection
```

### Test Firebase Storage:
```dart
// Use the uploadImage function in FirebaseService
final String imageUrl = await FirebaseService().uploadImage(
  file: imageFile,
  path: 'plant_images',
);
```

## 🐛 Troubleshooting

### Issue: "Default FirebaseApp is not initialized"
**Solution:** Make sure Firebase is initialized in `main()` before `runApp()`

### Issue: Google Sign-in not working on Android
**Solution:** 
1. Verify SHA-1 fingerprint is added to Firebase Console
2. Download new `google-services.json`
3. Run `flutter clean` and rebuild

### Issue: "FirebaseException: PERMISSION_DENIED"
**Solution:** Check Firestore/Storage security rules

### Issue: Build fails with Firebase errors
**Solution:**
1. Run `flutter clean`
2. Delete `android/build` folder
3. Run `flutter pub get`
4. Rebuild

## 📚 Firebase Service Usage Examples

### Sign Up:
```dart
final FirebaseService _firebaseService = FirebaseService();

await _firebaseService.signUpWithEmail(
  email: 'farmer@example.com',
  password: 'password123',
  name: 'John Farmer',
);
```

### Sign In:
```dart
await _firebaseService.signInWithEmail(
  email: 'farmer@example.com',
  password: 'password123',
);
```

### Upload Image:
```dart
final String downloadUrl = await _firebaseService.uploadImage(
  file: File('/path/to/image.jpg'),
  path: 'plant_images',
);
```

### Update User Data:
```dart
await _firebaseService.updateUserData(
  userId,
  {
    'phoneNumber': '+91 9876543210',
    'location': 'Punjab, India',
    'farmSize': '5 acres',
  },
);
```

## 🎯 Next Steps

1. ✅ Set up Firebase project
2. ✅ Add Firebase configuration files
3. ✅ Enable Authentication methods
4. ✅ Set up Firestore Database
5. ✅ Set up Firebase Storage
6. ✅ Test authentication flow
7. 🔄 Update security rules for production
8. 🔄 Implement additional features (push notifications, analytics, etc.)

## 📞 Support

If you encounter any issues:
1. Check Firebase Console for errors
2. Review Firebase logs
3. Check Flutter console output
4. Refer to [Firebase Documentation](https://firebase.google.com/docs)

---

**Made with ❤️ by Applynk Studio**
