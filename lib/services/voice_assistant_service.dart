import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'gemini_service.dart';

class VoiceAssistantService {
  static final SpeechToText _speechToText = SpeechToText();
  static FlutterTts? _flutterTts;
  static bool _speechEnabled = false;
  static bool _isListening = false;

  static FlutterTts get flutterTts {
    _flutterTts ??= FlutterTts();
    return _flutterTts!;
  }

  // Telugu language mappings
  static final Map<String, String> _teluguResponses = {
    'greeting': 'నమస్కారం! నేను కిసాన్, మీ వ్యవసాయ సహాయకుడిని. మీకు ఎలా సహాయం చేయాలి?',
    'weather': 'వాతావరణం గురించి తెలుసుకోవాలంటే, మీ ప్రాంతంలో ఈరోజు ఎండగా ఉంది. ఉష్ణోగ్రత 24 డిగ్రీలు. వ్యవసాయానికి అనుకూలమైన వాతావరణం.',
    'market_prices': '''మార్కెట్ ధరలు (క్వింటల్‌కు):

ముఖ్య పంటలు:
- పత్తి: ₹5000-6300 (పెరుగుతోంది 2.8-4.1%)
- బియ్యం: ₹2800-2920
- గోధుమ: ₹2180-2400 (పెరుగుతోంది 3.5-4.2%)
- మొక్కజొన్న: ₹1900-1980

కూరగాయలు:
- టమాట: ₹1150-1450 (పెరుగుతోంది 7.2-8.5%)
- ఉల్లి: ₹2150-2500
- బంగాళాదుంప: ₹1750-2100

కాయధాన్యాలు:
- సోయాబీన్: ₹4180-4350 (పెరుగుతోంది 2.8-3.2%)
- వేరుశనగ: ₹5750-6100
- కంది: ₹6750-7200 (పెరుగుతోంది 3.8-4.5%)

మసాలాలు:
- మిరప: ₹11800-12400 (పెరుగుతోంది 4.2-5.8%)
- పసుపు: ₹8400-8650 (పెరుగుతోంది 2.1-2.5%)
- జీలకర్ర: ₹28500-29500 (పెరుగుతోంది 6.5%)

సమీపంలోని మార్కెట్లు: వరంగల్ (8.3 km), సంగారెడ్డి (15.8 km), కరీంనగర్ (28.7 km)''',
    'crop_health': 'పంట ఆరోగ్యం తనిఖీ చేయాలంటే, మీ పంట యొక్క ఫోటో తీసి అప్లోడ్ చేయండి. నేను వివరణాత్మక నివేదిక ఇస్తాను.',
    'tasks': 'ఈరోజు మీకు 3 పనులు ఉన్నాయి: టమాటో మొక్కలకు నీరు పెట్టడం, కీటకాలను తనిఖీ చేయడం, కూరగాయల కోత.',
    'irrigation': 'నీటిపారుదల గురించి తెలుసుకోవాలంటే, మీ పంటలకు ఉదయం 7 గంటలకు నీరు పెట్టడం మంచిది. నేల తేమ స్థాయి 65 శాతం ఉంది.',
    'fertilizer': 'ఎరువుల గురించి తెలుసుకోవాలంటే, మీ టమాటో మొక్కలకు NPK ఎరువులు వేయాల్సిన సమయం వచ్చింది.',
    'pest_control': 'కీటక నియంత్రణ గురించి తెలుసుకోవాలంటే, మీ కూరగాయల మొక్కలపై కొన్ని కీటకాలు కనిపిస్తున్నాయి. వెంటనే చర్య తీసుకోండి.',
    'help': 'సహాయం కావాలంటే, మీరు వాతావరణం, మార్కెట్ ధరలు, పంట ఆరోగ్యం, పనుల జాబితా, నీటిపారుదల గురించి అడగవచ్చు.',
    'not_understood': 'క్షమించండి, నేను అర్థం చేసుకోలేకపోయాను. దయచేసి మళ్లీ ప్రయత్నించండి లేదా సరళమైన పదాలలో అడగండి.',
  };

  // Telugu command keywords
  static final Map<String, List<String>> _teluguKeywords = {
    'weather': ['వాతావరణం', 'వేచర్', 'వాతావరణ', 'ఉష్ణోగ్రత', 'వర్షం', 'ఎండ', 'గాలి'],
    'market_prices': ['మార్కెట్', 'ధర', 'ధరలు', 'విలువ', 'అమ్మకం', 'కొనుగోలు', 'ధన'],
    'crop_health': ['పంట', 'ఆరోగ్యం', 'నివేదిక', 'తనిఖీ', 'వ్యాధి', 'రోగం', 'గుణమట్టం'],
    'tasks': ['పని', 'పనులు', 'కార్యం', 'షెడ్యూల్', 'జాబితా', 'రిమైండర్'],
    'irrigation': ['నీరు', 'నీటిపారుదల', 'పోత', 'నిల్వ', 'తేమ', 'వాటర్'],
    'fertilizer': ['ఎరువు', 'పోషకాలు', 'NPK', 'యూరియా', 'రసాయనాలు'],
    'pest_control': ['కీటకాలు', 'పురుగులు', 'నిర్మూలన', 'రక్షణ', 'మందు', 'స్ప్రే'],
    'farmers': ['రైతులు', 'వ్యవసాయదారులు', 'రైతు', 'కృషికుడు'],
    'traders': ['వ్యాపారులు', 'వర్తకులు', 'కొనుగోలుదారులు'],
    'deal': ['ఒప్పందం', 'డీల్', 'అమ్మకం', 'కాంట్రాక్ట్'],
  };

  static Future<void> initialize() async {
    try {
      _speechEnabled = await _speechToText.initialize(
        onError: (error) {
          print('Speech recognition error: $error');
          _isListening = false;
        },
        onStatus: (status) {
          print('Speech recognition status: $status');
          if (status == 'done' || status == 'notListening') {
            _isListening = false;
          }
        },
        debugLogging: true,
      );

      await flutterTts.setLanguage("te-IN");
      await flutterTts.setSpeechRate(0.8);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);

      print('Voice Assistant initialized. Speech enabled: $_speechEnabled');
    } catch (e) {
      print('Error initializing voice assistant: $e');
      _speechEnabled = false;
    }
  }

  static Future<void> startListening(BuildContext context) async {
    if (!_speechEnabled) {
      await initialize();
      if (!_speechEnabled) {
        _showErrorDialog(context, 'వాయిస్ గుర్తింపు అందుబాటులో లేదు. మైక్రోఫోన్ అనుమతిని తనిఖీ చేయండి.');
        return;
      }
    }

    if (_isListening) {
      print('Already listening, ignoring request');
      return;
    }

    _isListening = true;
    
    // Show listening dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return _buildListeningDialog(dialogContext);
      },
    );

    try {
      await _speechToText.listen(
        onResult: (result) {
          print('Speech result: ${result.recognizedWords}, final: ${result.finalResult}');
          if (result.finalResult && result.recognizedWords.isNotEmpty) {
            Navigator.of(context, rootNavigator: true).pop(); // Close dialog
            _processVoiceCommand(context, result.recognizedWords);
            _isListening = false;
          }
        },
        listenFor: const Duration(seconds: 60),
        pauseFor: const Duration(seconds: 10),
        partialResults: true,
        localeId: 'en-IN', // Use English-India for better recognition
        cancelOnError: false,
        listenMode: ListenMode.confirmation,
      );

      // Auto-close dialog if no speech detected after 60 seconds
      Future.delayed(const Duration(seconds: 61), () {
        if (_isListening) {
          _stopListening();
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          _showErrorDialog(context, 'No speech detected. Please try again and speak clearly.');
        }
      });
    } catch (e) {
      print('Error starting speech recognition: $e');
      _isListening = false;
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      _showErrorDialog(context, 'వాయిస్ గుర్తింపు ప్రారంభించడంలో లోపం. మళ్లీ ప్రయత్నించండి.');
    }
  }

  static void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('లోపం'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('సరే'),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildListeningDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF4CAF50).withOpacity(0.3),
                    const Color(0xFF4CAF50),
                  ],
                ),
              ),
              child: const Icon(
                Icons.mic,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Listening...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E7D32),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Speak now - Ask about weather, prices, farming tips',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    _stopListening();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _stopListening();
                    Navigator.of(context).pop();
                    _processVoiceCommand(context, "How is the weather today?");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                  ),
                  child: const Text(
                    'Try Example',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static void _stopListening() {
    if (_isListening) {
      _speechToText.stop();
      _isListening = false;
    }
  }

  static Future<void> _processVoiceCommand(BuildContext context, String command) async {
    // Try Gemini API first for better responses
    String response;
    try {
      response = await GeminiService.processVoiceCommand(command, language: 'Telugu');
      
      // Fallback to local responses if Gemini fails or API not configured
      if (response.contains('configure') || response.contains('కాన్ఫిగర్')) {
        response = _analyzeCommand(command);
      }
    } catch (e) {
      print('Gemini error, using fallback: $e');
      response = _analyzeCommand(command);
    }
    
    await _speakResponse(response);
    _showResponseDialog(context, command, response);
  }

  static String _analyzeCommand(String command) {
    String lowerCommand = command.toLowerCase();
    
    // Check for greeting
    if (lowerCommand.contains('హాయ్') || 
        lowerCommand.contains('నమస్కారం') || 
        lowerCommand.contains('హలో')) {
      return _teluguResponses['greeting']!;
    }

    // Analyze based on keywords
    for (String category in _teluguKeywords.keys) {
      for (String keyword in _teluguKeywords[category]!) {
        if (lowerCommand.contains(keyword)) {
          return _teluguResponses[category] ?? _teluguResponses['not_understood']!;
        }
      }
    }

    // Check for specific phrases
    if (lowerCommand.contains('ఎలా ఉంది') || lowerCommand.contains('ఏమిటి')) {
      if (lowerCommand.contains('వాతావరణం')) {
        return _teluguResponses['weather']!;
      }
      if (lowerCommand.contains('ధర')) {
        return _teluguResponses['market_prices']!;
      }
    }

    if (lowerCommand.contains('సహాయం') || lowerCommand.contains('హెల్ప్')) {
      return _teluguResponses['help']!;
    }

    // Generate dynamic responses based on context
    if (lowerCommand.contains('రైతు') && lowerCommand.contains('సంప్రదింపు')) {
      return _getFarmerContactResponse();
    }

    if (lowerCommand.contains('వ్యాపారి') && lowerCommand.contains('మంచి')) {
      return _getBestTraderResponse();
    }

    if (lowerCommand.contains('ఒప్పందం') && lowerCommand.contains('ప్రారంభించు')) {
      return _getDealStartResponse();
    }

    return _teluguResponses['not_understood']!;
  }

  static String _getFarmerContactResponse() {
    final farmers = [
      'R. రెడ్డి నిజామాబాద్ నుండి టమాటో సాగు చేస్తున్నారు. ఫోన్: +91-9876543210',
      'S. లక్ష్మి కరీంనగర్ నుండి వరి సాగు చేస్తున్నారు. ఫోన్: +91-9876543211',
      'K. సునీల్ మహబూబ్‌నగర్ నుండి పత్తి సాగు చేస్తున్నారు. ఫోన్: +91-9876543212',
    ];
    
    final random = math.Random();
    final selectedFarmer = farmers[random.nextInt(farmers.length)];
    
    return 'టాప్ రైతుల వివరాలు: $selectedFarmer. మరిన్ని వివరాలకు రైతుల విభాగంలో చూడండి.';
  }

  static String _getBestTraderResponse() {
    return '''అత్యుత్తమ హామీ వ్యాపారి: తెలంగాణ అగ్రి ట్రేడర్స్
ధర: అధిక మార్కెట్ రేట్
హామీ: వెంటనే చెల్లింపు
రేటింగ్: 4.9 స్టార్లు
ఫోన్: +91-9876540001''';
  }

  static String _getDealStartResponse() {
    return '''ఒప్పందం ప్రారంభించడానికి ఈ దశలను అనుసరించండి:
1. పంట ఆరోగ్య నివేదిక రూపొందించండి
2. వ్యాపారిని ఎంచుకోండి
3. పరిమాణం మరియు వివరాలు నమోదు చేయండి
4. ధర లెక్కింపు తనిఖీ చేయండి
5. ఒప్పందాన్ని నిర్ధారించండి''';
  }

  static Future<void> _speakResponse(String response) async {
    try {
      await _flutterTts?.speak(response);
    } catch (e) {
      print('Error speaking response: $e');
    }
  }

  static void _showResponseDialog(BuildContext context, String command, String response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF4CAF50).withOpacity(0.3),
                        const Color(0xFF4CAF50),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.smart_toy,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'కిసాన్ సమాధానం',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'మీరు అడిగారు: "$command"',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  response,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2E7D32),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          startListening(context);
                        },
                        icon: const Icon(Icons.mic),
                        label: const Text('మళ్లీ అడగండి'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF4CAF50),
                          side: const BorderSide(color: Color(0xFF4CAF50)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('సరి'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> stopSpeaking() async {
    try {
      await _flutterTts?.stop();
    } catch (e) {
      print('Error stopping speech: $e');
    }
  }

  // Quick response methods for common queries
  static Future<void> speakWeatherUpdate(BuildContext context) async {
    const response = 'ఈరోజు వాతావరణం ఎండగా ఉంది. ఉష్ణోగ్రత 24 డిగ్రీలు. వ్యవసాయానికి అనుకూలమైన వాతావరణం.';
    await _speakResponse(response);
  }

  static Future<void> speakMarketPrices(BuildContext context) async {
    const response = '''ఈరోజు మార్కెట్ ధరలు:
పత్తి 5000 నుండి 6300 రూపాయలు, పెరుగుతోంది.
బియ్యం 2800 నుండి 2920 రూపాయలు.
టమాట 1150 నుండి 1450 రూపాయలు, బాగా పెరుగుతోంది.
మిరప 11800 నుండి 12400 రూపాయలు.
పసుపు 8400 నుండి 8650 రూపాయలు.
క్వింటల్‌కు ధరలు. మరిన్ని వివరాలకు మార్కెట్ విభాగం చూడండి.''';
    await _speakResponse(response);
  }

  static Future<void> speakTaskReminder(BuildContext context, List<String> tasks) async {
    final taskCount = tasks.length;
    String response = 'ఈరోజు మీకు $taskCount పనులు ఉన్నాయి: ';
    response += tasks.take(3).join(', ');
    if (tasks.length > 3) {
      response += ' మరియు మరిన్ని...';
    }
    await _speakResponse(response);
  }

  static Future<void> speakNotification(BuildContext context, String notification) async {
    String response = 'హెచ్చరిక: $notification';
    await _speakResponse(response);
  }

  // Voice commands for navigation
  static Future<void> handleNavigationCommand(BuildContext context, String destination) async {
    switch (destination.toLowerCase()) {
      case 'home':
      case 'హోమ్':
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        await _speakResponse('హోమ్ పేజీకి వెళ్తున్నాము');
        break;
      case 'market':
      case 'మార్కెట్':
        Navigator.pushNamed(context, '/marketplace');
        await _speakResponse('మార్కెట్‌ప్లేస్‌కు వెళ్తున్నాము');
        break;
      case 'tasks':
      case 'పనులు':
        Navigator.pushNamed(context, '/schedule');
        await _speakResponse('పనుల జాబితాకు వెళ్తున్నాము');
        break;
      case 'camera':
      case 'కెమెరా':
        Navigator.pushNamed(context, '/camera');
        await _speakResponse('కెమెరాను తెరుస్తున్నాము');
        break;
      default:
        await _speakResponse('క్షమించండి, ఆ పేజీ దొరకలేదు');
    }
  }
}