import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class GeminiService {
  // Gemini API key configured via --dart-define (do not hardcode)
  static const String _apiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'YOUR_GEMINI_API_KEY_HERE',
  );
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';
  
  // For text-only queries (Voice Assistant)
  static Future<String> generateText(String prompt, {String? language}) async {
    if (_apiKey == 'YOUR_GEMINI_API_KEY_HERE') {
      return 'కృపయా మీ అభివృద్ధి జట్టు Gemini API కీని కాన్ఫిగర్ చేయండి';
    }

    try {
      final url = Uri.parse('$_baseUrl/gemini-1.5-flash:generateContent?key=$_apiKey');
      
      // Customize prompt based on language
      String systemPrompt = '''
You are Kisan, an intelligent farming assistant for Indian farmers.
Respond in English language clearly and helpfully.
Provide accurate agricultural advice.

RESPONSE LENGTH:
- For market price queries: Provide DETAILED information with all available prices
- For other queries: Keep responses concise (2-3 sentences)

User question: $prompt

Be friendly, supportive, and thorough when discussing prices.
''';

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': systemPrompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 800,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'];
        return text.trim();
      } else {
        print('Gemini API Error: ${response.statusCode} - ${response.body}');
        return 'Sorry, there was an issue. Please try again.';
      }
    } catch (e) {
      print('Error calling Gemini API: $e');
      return 'Network issue. Please check your internet connection.';
    }
  }

  // For image analysis (Plant Disease Detection)
  static Future<Map<String, dynamic>> analyzeImage(File imageFile, {String? language}) async {
    if (_apiKey == 'YOUR_GEMINI_API_KEY_HERE') {
      return {
        'success': false,
        'error': 'Please configure Gemini API key in gemini_service.dart',
        'errorTe': 'కృపయా Gemini API కీని కాన్ఫిగర్ చేయండి'
      };
    }

    try {
      final url = Uri.parse('$_baseUrl/gemini-pro-vision:generateContent?key=$_apiKey');
      
      // Read image and convert to base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      String prompt = '''
Analyze this plant image and provide a detailed farming disease report in ${language ?? 'Telugu'} language.

If NO PLANT is visible in the image:
- Respond: "మొక్క కనిపించడం లేదు. దయచేసి మొక్కను సరిగ్గా ఫోటో తీయండి." (No plant detected. Please place the plant properly in the frame)

If a PLANT is visible:
1. Plant Type (మొక్క రకం)
2. Health Status (ఆరోగ్య స్థితి): Healthy/Diseased/Needs Attention
3. Disease Name (వ్యాధి పేరు) if any
4. Severity (తీవ్రత): Low/Medium/High/Critical
5. Symptoms (లక్షణాలు): List visible symptoms
6. Causes (కారణాలు): Why this happened
7. Treatment (చికిత్స): Step-by-step cure (organic & chemical options)
8. Prevention (నివారణ): How to prevent future occurrence
9. Confidence (నమ్మకం): Your confidence level (percentage)

Format as JSON with Telugu text.
''';

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
                {
                  'inline_data': {
                    'mime_type': 'image/jpeg',
                    'data': base64Image
                  }
                }
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.4,
            'topK': 32,
            'topP': 0.8,
            'maxOutputTokens': 1024,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'];
        
        // Parse the response
        return _parseGeminiResponse(text);
      } else {
        print('Gemini Vision API Error: ${response.statusCode} - ${response.body}');
        return {
          'success': false,
          'error': 'API Error',
          'message': 'విశ్లేషణ విఫలమైంది. దయచేసి మళ్లీ ప్రయత్నించండి.'
        };
      }
    } catch (e) {
      print('Error analyzing image with Gemini: $e');
      return {
        'success': false,
        'error': 'Network Error',
        'message': 'నెట్వర్క్ సమస్య. దయచేసి ఇంటర్నెట్ కనెక్షన్ తనిఖీ చేయండి.'
      };
    }
  }

  static Map<String, dynamic> _parseGeminiResponse(String text) {
    try {
      // Try to extract JSON from the response
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch != null) {
        final jsonStr = jsonMatch.group(0)!;
        final parsed = jsonDecode(jsonStr);
        return {
          'success': true,
          'data': parsed,
        };
      }
      
      // If not JSON, parse as structured text
      return {
        'success': true,
        'rawText': text,
        'isNoPlant': text.contains('మొక్క కనిపించడం లేదు') || 
                     text.toLowerCase().contains('no plant') ||
                     text.contains('place the plant'),
        'data': {
          'message': text,
        }
      };
    } catch (e) {
      print('Error parsing Gemini response: $e');
      return {
        'success': true,
        'rawText': text,
        'data': {
          'message': text,
        }
      };
    }
  }

  // Voice Assistant - Conversational AI
  static Future<String> processVoiceCommand(String command, {String? language}) async {
    String enhancedPrompt = '''
User asked: "$command"

You are Kisan, a helpful farming assistant. Answer in English clearly and concisely.

Available Market Prices (per quintal):

MAJOR CROPS:
- Cotton: ₹5000-6300 (trending UP 2.8-4.1%)
- Rice: ₹2800-2920 (mixed trends)
- Wheat: ₹2180-2400 (trending UP 3.5-4.2%)
- Maize: ₹1900-1980 (stable to UP 1.5%)

PULSES & OILSEEDS:
- Soybean: ₹4180-4350 (trending UP 2.8-3.2%)
- Groundnut: ₹5750-6100 (trending DOWN)
- Pigeon Pea: ₹6750-7200 (trending UP 3.8-4.5%)
- Red Gram: ₹7200-7600 (trending UP 5.2%)
- Sunflower: ₹5400-5800 (trending UP 3.5%)
- Sesame: ₹8200-8600 (trending UP 2.8%)

VEGETABLES:
- Tomato: ₹1150-1450 (trending UP 7.2-8.5%)
- Onion: ₹2150-2500 (stable)
- Potato: ₹1750-2100 (trending UP 2.5-3.2%)

SPICES:
- Chilli: ₹11800-12400 (trending UP 4.2-5.8%)
- Turmeric: ₹8400-8650 (trending UP 2.1-2.5%)
- Coriander: ₹6500-7200 (stable)
- Cumin: ₹28500-29500 (trending UP 6.5%)

OTHER CROPS:
- Sugarcane: ₹335-360 (stable)
- Jowar: ₹2200-2400 (stable)
- Bajra: ₹2000-2150 (trending UP 2.2%)

MARKETS:
- Warangal APMC (8.3 km away)
- Adilabad APMC (12.5 km away)
- Sangareddy APMC (15.8 km away)
- Karimnagar Market (28.7 km away)
- Nizamabad APMC (42.1 km away)
- Hyderabad APMC (72.5 km away)

Weather: Sunny, 24°C, perfect for farming
Irrigation tip: Water at 7 AM, soil moisture 65%

INSTRUCTIONS:
- If user asks about specific crop prices, list ALL available prices for that crop from different markets
- If user asks about all prices or market prices in general, provide a comprehensive summary categorized by crop type
- Include price range, trend direction (UP/DOWN/stable), and change percentage
- Mention nearby markets
- Be detailed and helpful, don't limit to 1-2 sentences when discussing prices
''';

    return await generateText(enhancedPrompt, language: 'English');
  }

  // Quick health check for API key
  static Future<bool> checkApiKey() async {
    if (_apiKey == 'YOUR_GEMINI_API_KEY_HERE') {
      return false;
    }

    try {
      final url = Uri.parse('$_baseUrl/gemini-pro:generateContent?key=$_apiKey');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': 'Hello'}
              ]
            }
          ],
        }),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
