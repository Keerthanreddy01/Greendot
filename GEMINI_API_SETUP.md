# Gemini API Setup Guide

## 🎯 Get Your Free Gemini API Key

### Step 1: Get API Key from Google AI Studio
1. Visit: https://makersuite.google.com/app/apikey
2. Click **"Get API Key"**
3. Select **"Create API key in new project"** or use existing project
4. Copy your API key (starts with `AIza...`)

### Step 2: Add API Key to Your App
1. Open file: `lib/services/gemini_service.dart`
2. Find line 7:
   ```dart
   static const String _apiKey = 'YOUR_GEMINI_API_KEY_HERE';
   ```
3. Replace `YOUR_GEMINI_API_KEY_HERE` with your actual API key:
   ```dart
   static const String _apiKey = 'AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
   ```
4. Save the file

### Step 3: Test the Integration
1. Run your app: `flutter run`
2. Test Voice Assistant:
   - Press the microphone button
   - Ask: "వాతావరణం ఎలా ఉంది?" (How is the weather?)
   - You should get an intelligent response!

3. Test Plant Disease Detection:
   - Go to Disease Detection screen
   - Take/upload a plant photo
   - If no plant: "మొక్క కనిపించడం లేదు"
   - If plant detected: Detailed disease analysis in Telugu!

## 🎁 What You Get with Gemini Integration

### Voice Assistant (Kisan AI) 🎤
- **Real conversational AI** instead of hardcoded responses
- Understands context and farming queries in Telugu/English
- Provides accurate weather, market prices, farming advice
- Natural language understanding

### Plant Disease Detection 📸
- **Accurate image analysis** using Gemini Vision
- Detects if plant is properly placed in frame
- Identifies plant type, diseases, and health status
- Provides treatment and prevention in Telugu
- Much better than random results!

## 🔒 Security Note
- ⚠️ **DO NOT share your API key publicly**
- ⚠️ **DO NOT commit API key to GitHub/version control**
- For production, use environment variables or secure storage

## 📊 Gemini API Free Tier
- **60 requests per minute**
- **1,500 requests per day**
- Perfect for testing and moderate usage
- Upgrade if you need more

## 🆚 Comparison: Before vs After

### Before (Without Gemini):
❌ Voice: Random Telugu responses, no context
❌ Disease: Random results, fake confidence scores
❌ No plant detection: Still shows disease results

### After (With Gemini):
✅ Voice: Intelligent conversations, understands context
✅ Disease: Real AI analysis, accurate diagnosis
✅ No plant detection: Asks to place plant properly
✅ Detailed Telugu reports with treatment plans

## 🔧 Troubleshooting

### If you see "Please configure Gemini API key":
- Check if API key is correctly pasted in `gemini_service.dart`
- Make sure there are no extra spaces
- Verify API key is active in Google AI Studio

### If you get network errors:
- Check internet connection
- Verify API key has not exceeded quota
- Check Google AI Studio dashboard for errors

### If responses are in English instead of Telugu:
- The system is working! Gemini auto-detects language
- It will respond in Telugu for Telugu queries
- You can force Telugu by updating prompts if needed

## 🎯 Alternative: Use Local TFLite Model

If you don't want to use Gemini API, you can:
1. Train a custom TFLite model
2. Place model file in `assets/models/`
3. Update `disease_detection_service.dart` to use local model
4. No internet required, but less accurate

## ✅ Next Steps After Setup

1. **Test both features thoroughly**
2. **Adjust prompts** in `gemini_service.dart` if needed
3. **Monitor API usage** in Google AI Studio
4. **Add more languages** by updating prompts

---

**Need Help?**
- Gemini API Docs: https://ai.google.dev/docs
- Flutter Integration: https://ai.google.dev/tutorials/flutter
