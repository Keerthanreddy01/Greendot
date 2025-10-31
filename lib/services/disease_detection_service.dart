import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import '../models/disease_detection_model.dart';

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
      // Preprocess image
      final processedImage = await _preprocessImage(imageFile);
      
      // Run inference (placeholder for actual ML model)
      final result = await _runInference(processedImage);
      
      return result;
    } catch (e) {
      print('Error detecting disease: $e');
      return _getDummyResult();
    }
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
