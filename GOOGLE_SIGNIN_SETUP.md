# Google Sign-In Setup Guide

## Your SHA-1 Fingerprint (Debug)
```
SHA1: 6F:64:B8:D0:A6:42:18:1D:EA:3E:A9:AB:E4:C8:F7:E3:12:AA:91:07
SHA256: F8:05:F7:8E:54:34:AD:68:B7:53:FF:79:55:BF:2D:1D:30:7B:14:F7:62:FF:8D:7F:2E:DD:D9:57:54:4A:36:76
```

## Steps to Enable Google Sign-In

### 1. Add SHA-1 to Firebase Console

1. **Go to Firebase Console**: https://console.firebase.google.com/
2. **Select your project**: `greendot-a2731`
3. **Click on the Gear Icon** (⚙️) next to "Project Overview"
4. **Select "Project settings"**
5. **Scroll down** to "Your apps" section
6. **Find your Android app**: `com.example.green_dot`
7. **Click "Add fingerprint"** button
8. **Paste the SHA-1**: `6F:64:B8:D0:A6:42:18:1D:EA:3E:A9:AB:E4:C8:F7:E3:12:AA:91:07`
9. **Click "Save"**

### 2. (Optional) Add SHA-256 as well

Click "Add fingerprint" again and paste:
```
F8:05:F7:8E:54:34:AD:68:B7:53:FF:79:55:BF:2D:1D:30:7B:14:F7:62:FF:8D:7F:2E:DD:D9:57:54:4A:36:76
```

### 3. Download Updated google-services.json

1. **In Firebase Console**, after adding SHA-1
2. **Click "Download google-services.json"** button
3. **Replace** the existing file at:
   ```
   android/app/google-services.json
   ```

### 4. Verify Google Sign-In is Enabled

1. **In Firebase Console**, go to **Authentication** → **Sign-in method**
2. **Ensure "Google"** is enabled (it should already be)
3. If not enabled, click **Google** → **Enable** → **Save**

### 5. Test Google Sign-In

After completing the above steps:

1. **Stop the app** (if running)
2. **Run the app again**:
   ```bash
   flutter run
   ```
3. **Try Google Sign-In** - it should now work!

---

## Quick Copy-Paste

**SHA-1 (for Firebase Console)**:
```
6F:64:B8:D0:A6:42:18:1D:EA:3E:A9:AB:E4:C8:F7:E3:12:AA:91:07
```

**SHA-256 (optional)**:
```
F8:05:F7:8E:54:34:AD:68:B7:53:FF:79:55:BF:2D:1D:30:7B:14:F7:62:FF:8D:7F:2E:DD:D9:57:54:4A:36:76
```

---

## Why This Is Needed

Google Sign-In requires SHA-1/SHA-256 fingerprints to verify that sign-in requests are coming from your legitimate app. Without it, Google rejects the authentication attempt with a `sign_in_failed` error.

## For Production Release

When you build a release APK, you'll need to:
1. Get the SHA-1 from your **release keystore**
2. Add it to Firebase Console the same way
3. Use this command to get release SHA-1:
   ```bash
   keytool -list -v -keystore path/to/your-release.keystore -alias your-alias
   ```

---

**Firebase Project**: greendot-a2731  
**Package Name**: com.example.green_dot  
**Debug Keystore**: `~/.android/debug.keystore`
