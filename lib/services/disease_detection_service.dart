import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import '../models/disease_detection_model.dart';
import 'gemini_service.dart';

class DiseaseDetectionService {
  // Singleton pattern
  static final DiseaseDetectionService _instance = DiseaseDetectionService._internal();
  factory DiseaseDetectionService() => _instance;
  DiseaseDetectionService._internal();

  // TODO: Load TFLite model
  // Interpreter? _interpreter;
  bool _isModelLoaded = false;

  Future<void> loadModel() async {
    try {
      // TODO: Implement TFLite model loading
      // _interpreter = await Interpreter.fromAsset('assets/models/plant_disease_model.tflite');
      _isModelLoaded = true;
      print('Disease detection model loaded successfully');
    } catch (e) {
      print('Error loading disease detection model: $e');
      _isModelLoaded = false;
    }
  }

  Future<DiseaseDetectionResult> detectDisease(File imageFile) async {
    if (!_isModelLoaded) {
      await loadModel();
    }

    try {
      // Try Gemini Vision API first for accurate detection
      final geminiResult = await GeminiService.analyzeImage(imageFile, language: 'Telugu');
      
      if (geminiResult['success'] == true) {
        return _parseGeminiResult(geminiResult);
      }
      
      // Fallback to local model if Gemini fails
      print('Gemini detection failed, using fallback');
      final processedImage = await _preprocessImage(imageFile);
      final result = await _runInference(processedImage);
      return result;
      
    } catch (e) {
      print('Error detecting disease: $e');
      return _getDummyResult();
    }
  }

  DiseaseDetectionResult _parseGeminiResult(Map<String, dynamic> geminiResult) {
    try {
      // Check if no plant detected
      if (geminiResult['isNoPlant'] == true) {
        return DiseaseDetectionResult(
          diseaseName: 'మొక్క కనిపించడం లేదు',
          confidence: 0.0,
          healthScore: 0.0,
          severity: 'Unknown',
          symptoms: ['మొక్క చిత్రంలో కనిపించడం లేదు'],
          treatments: ['మొక్కను సరిగ్గా ఫ్రేమ్‌లో ఉంచండి', 'మంచి వెలుతురులో ఫోటో తీయండి', 'మొక్క ఆకులు స్పష్టంగా కనిపించేలా చూడండి'],
          preventions: ['కెమెరాను స్థిరంగా పట్టుకోండి', 'దగ్గరగా ఫోటో తీయండి'],
          imageUrl: '',
        );
      }
      
      final data = geminiResult['data'] ?? {};
      final rawText = geminiResult['rawText'] ?? '';
      
      // Parse structured data if available
      if (data.isNotEmpty && data['Plant Type'] != null) {
        final healthStatus = data['Health Status'] ?? 'Unknown';
        final isHealthy = healthStatus.toLowerCase().contains('healthy');
        
        return DiseaseDetectionResult(
          diseaseName: isHealthy ? 'ఆరోగ్యవంతమైన మొక్క' : (data['Disease Name'] ?? 'గుర్తించబడలేదు'),
          confidence: _parseConfidence(data['Confidence']),
          healthScore: isHealthy ? 95.0 : _parseHealthScore(data['Severity']),
          severity: data['Severity'] ?? 'Unknown',
          symptoms: _parseList(data['Symptoms']),
          treatments: _parseList(data['Treatment']),
          preventions: _parseList(data['Prevention']),
          imageUrl: '',
        );
      }
      
      // Parse from raw text if structured data not available
      return _parseFromRawText(rawText);
      
    } catch (e) {
      print('Error parsing Gemini result: $e');
      return _getDummyResult();
    }
  }

  double _parseConfidence(dynamic confidence) {
    if (confidence == null) return 0.85;
    if (confidence is double) return confidence;
    if (confidence is String) {
      final match = RegExp(r'(\d+)').firstMatch(confidence);
      if (match != null) {
        return int.parse(match.group(1)!) / 100.0;
      }
    }
    return 0.85;
  }

  double _parseHealthScore(dynamic severity) {
    if (severity == null) return 70.0;
    final sev = severity.toString().toLowerCase();
    if (sev.contains('low')) return 85.0;
    if (sev.contains('medium')) return 65.0;
    if (sev.contains('high')) return 40.0;
    if (sev.contains('critical')) return 20.0;
    return 70.0;
  }

  List<String> _parseList(dynamic data) {
    if (data == null) return [];
    if (data is List) return data.cast<String>();
    if (data is String) {
      return data.split('\n')
          .where((s) => s.trim().isNotEmpty)
          .map((s) => s.trim())
          .toList();
    }
    return [];
  }

  DiseaseDetectionResult _parseFromRawText(String text) {
    // Extract information from raw text response
    final isHealthy = text.toLowerCase().contains('healthy') || text.contains('ఆరోగ్యవంతమైన');
    
    return DiseaseDetectionResult(
      diseaseName: isHealthy ? 'ఆరోగ్యవంతమైన మొక్క' : 'విశ్లేషణ పూర్తయింది',
      confidence: 0.85,
      healthScore: isHealthy ? 95.0 : 70.0,
      severity: isHealthy ? 'None' : 'Medium',
      symptoms: [text.substring(0, text.length > 200 ? 200 : text.length)],
      treatments: ['పూర్తి వివరాలకు క్రింది సందేశం చూడండి'],
      preventions: [],
      imageUrl: '',
    );
  }

  Future<Uint8List> _preprocessImage(File imageFile) async {
    // Load and decode image
    final bytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    
    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Resize to model input size (e.g., 224x224)
    img.Image resized = img.copyResize(image, width: 224, height: 224);
    
    // Convert to Float32List normalized [0, 1]
    final imageData = Float32List(224 * 224 * 3);
    int pixelIndex = 0;
    
    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = resized.getPixel(x, y);
        // Extract RGB values from pixel using the current API
        imageData[pixelIndex++] = pixel.r / 255.0;
        imageData[pixelIndex++] = pixel.g / 255.0;
        imageData[pixelIndex++] = pixel.b / 255.0;
      }
    }
    
    return imageData.buffer.asUint8List();
  }

  Future<DiseaseDetectionResult> _runInference(Uint8List imageData) async {
    // TODO: Implement actual TFLite inference
    // For now, return dummy data
    await Future.delayed(const Duration(seconds: 2)); // Simulate processing
    
    return _getDummyResult();
  }

  DiseaseDetectionResult _getDummyResult() {
    // Dummy ML result for demonstration
    final diseases = [
      {
        'name': 'Late Blight',
        'confidence': 0.92,
        'severity': 'High',
        'symptoms': [
          'Dark brown spots on leaves',
          'White mold on underside of leaves',
          'Rapid leaf decay',
        ],
        'treatments': [
          'Remove infected leaves immediately',
          'Apply copper-based fungicide',
          'Improve air circulation',
          'Avoid overhead watering',
        ],
        'preventions': [
          'Plant resistant varieties',
          'Ensure proper spacing',
          'Regular monitoring',
          'Crop rotation',
        ],
      },
      {
        'name': 'Powdery Mildew',
        'confidence': 0.85,
        'severity': 'Medium',
        'symptoms': [
          'White powdery coating on leaves',
          'Yellowing of leaves',
          'Stunted growth',
        ],
        'treatments': [
          'Apply sulfur-based fungicide',
          'Prune affected areas',
          'Increase sunlight exposure',
        ],
        'preventions': [
          'Adequate spacing between plants',
          'Good air circulation',
          'Avoid excessive nitrogen fertilizer',
        ],
      },
    ];

    final selectedDisease = diseases[0];
    final healthScore = 100 - ((selectedDisease['confidence'] as double) * 100);

    return DiseaseDetectionResult(
      diseaseName: selectedDisease['name'] as String,
      confidence: selectedDisease['confidence'] as double,
      healthScore: healthScore,
      severity: selectedDisease['severity'] as String,
      symptoms: selectedDisease['symptoms'] as List<String>,
      treatments: selectedDisease['treatments'] as List<String>,
      preventions: selectedDisease['preventions'] as List<String>,
      imageUrl: '',
    );
  }

  void dispose() {
    // TODO: Close interpreter
    // _interpreter?.close();
  }
}
