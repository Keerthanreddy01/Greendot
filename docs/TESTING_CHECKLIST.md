# Firebase Authentication Testing Checklist

## ✅ What to Test After App Launches

### 1. **Clear Current Session (if logged in)**
If you see the Home Screen instead of Login Screen:
- Go to your device's **Settings** → **Apps** → **Greendot**
- Tap **Storage** → **Clear Data**
- Restart the app

---

## 2. **Test Google Sign-In** 🔴 PRIORITY

### Steps:
1. ✅ Open the app → See Splash Screen (5 seconds)
2. ✅ Select Language (if first time)
3. ✅ See Login Screen
4. ✅ Tap **"Sign up with Google"** button
5. ✅ Google account picker should appear
6. ✅ Select your Google account
7. ✅ App should:
   - Show success message
   - Create user in Firestore database
   - Navigate to Home Screen
   
### Expected Result:
- ✅ No errors
- ✅ Smooth Google Sign-In flow
- ✅ Redirects to Home Screen
- ✅ User data saved in Firebase

### If Error Occurs:
- Check if SHA-1 is properly added in Firebase Console
- Check terminal logs for specific error

---

## 3. **Test Email/Password Sign-Up**

### Steps:
1. ✅ On Login Screen, tap **"Sign Up"** at bottom
2. ✅ Fill in:
   - Name: Test User
   - Email: testuser@example.com
   - Password: password123
   - Confirm Password: password123
3. ✅ Tap **"Sign Up"** button
4. ✅ Should create account and go to Home Screen

### Expected Result:
- ✅ Account created successfully
- ✅ User document created in Firestore
- ✅ Navigate to Home Screen

---

## 4. **Test Email/Password Login**

### Steps:
1. ✅ Logout (clear app data)
2. ✅ Open app → Login Screen
3. ✅ Enter email and password
4. ✅ Tap **"Login"** button
5. ✅ Should login and go to Home Screen

---

## 5. **Test Forgot Password**

### Steps:
1. ✅ On Login Screen, tap **"Forgot Password?"**
2. ✅ Enter registered email
3. ✅ Tap **"Send Reset Link"**
4. ✅ Check email for password reset link

---

## 6. **Verify Firestore Database**

### In Firebase Console:
1. Go to: https://console.firebase.google.com/
2. Select project: `greendot-a2731`
3. Go to **Firestore Database**
4. Check **users** collection
5. Verify user documents are created with:
   - userId
   - email
   - name
   - createdAt
   - updatedAt

---

## 7. **Test for Multiple Users**

### Install APK on another device:
1. ✅ Build release APK
2. ✅ Install on friend's phone
3. ✅ They sign up with their Google account
4. ✅ Check Firebase Console - new user document created
5. ✅ Each user has isolated data

---

## Current Configuration Status

✅ **Firebase Core** - Initialized  
✅ **Firebase Auth** - Email/Password enabled  
✅ **Firebase Auth** - Google Sign-in enabled  
✅ **SHA-1 Certificate** - Added to Firebase  
✅ **google-services.json** - Updated with SHA-1  
⏳ **Firestore Database** - Needs to be created in Firebase Console  
⏳ **Firebase Storage** - Needs to be created (for image uploads)  

---

## Next Steps After Testing

1. **Create Firestore Database** (if not done):
   - Firebase Console → Build → Firestore Database
   - Create database in test mode
   - Region: asia-south1 (India)

2. **Create Firebase Storage**:
   - Firebase Console → Build → Storage
   - Start in test mode
   - For plant image uploads

3. **Update Security Rules** (before production):
   - Set proper read/write rules
   - User-based access control

4. **Build Release APK**:
   ```bash
   flutter build apk --release
   ```
   - APK location: `build/app/outputs/flutter-apk/app-release.apk`

---

## Troubleshooting

### Google Sign-In fails with "sign_in_failed"
- **Solution**: SHA-1 not properly added
- Add SHA-1 to Firebase Console
- Download new google-services.json
- Rebuild app

### "CONFIGURATION_NOT_FOUND" error
- **Solution**: Email/Password not enabled
- Firebase Console → Authentication → Sign-in method
- Enable Email/Password

### "Email already in use"
- **Solution**: User-friendly error already shown
- Use different email or login instead

### Firestore permission denied
- **Solution**: Create Firestore Database
- Firebase Console → Firestore Database → Create

---

**Project**: Greendot  
**Firebase Project ID**: greendot-a2731  
**Package Name**: com.example.green_dot  
**Authentication Methods**: Email/Password, Google Sign-In
