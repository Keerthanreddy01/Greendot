import '../models/crop_recommendation_model.dart';

class CropRecommendationService {
  static final CropRecommendationService _instance = CropRecommendationService._internal();
  factory CropRecommendationService() => _instance;
  CropRecommendationService._internal();

  Future<List<CropRecommendation>> recommendCrops(SoilData soilData) async {
    // Simulate AI processing
    await Future.delayed(const Duration(seconds: 2));

    // Dummy ML-based recommendations
    final recommendations = <CropRecommendation>[];

    // Logic based on soil type
    if (soilData.soilType.toLowerCase().contains('loam')) {
      recommendations.add(CropRecommendation(
        cropName: 'Tomato',
        cropType: 'Vegetable',
        suitabilityScore: 0.95,
        season: 'Kharif',
        growthDuration: 90,
        expectedYield: 25.5,
        soilType: 'Loamy',
        waterRequirement: 'Medium',
        advantages: [
          'High market demand',
          'Good profit margins',
          'Multiple harvests possible',
        ],
        requirements: [
          'pH: 6.0-7.0',
          'Temperature: 20-30°C',
          'Well-drained soil',
        ],
        imageUrl: '',
      ));

      recommendations.add(CropRecommendation(
        cropName: 'Wheat',
        cropType: 'Cereal',
        suitabilityScore: 0.88,
        season: 'Rabi',
        growthDuration: 120,
        expectedYield: 35.0,
        soilType: 'Loamy',
        waterRequirement: 'Low',
        advantages: [
          'Staple crop',
          'Government support',
          'Storage friendly',
        ],
        requirements: [
          'pH: 6.5-7.5',
          'Temperature: 10-25°C',
          'Moderate water',
        ],
        imageUrl: '',
      ));
    }

    if (soilData.soilType.toLowerCase().contains('clay')) {
      recommendations.add(CropRecommendation(
        cropName: 'Rice',
        cropType: 'Cereal',
        suitabilityScore: 0.92,
        season: 'Kharif',
        growthDuration: 130,
        expectedYield: 40.0,
        soilType: 'Clayey',
        waterRequirement: 'High',
        advantages: [
          'High yield potential',
          'Assured market',
          'Suitable for monsoon',
        ],
        requirements: [
          'pH: 5.5-6.5',
          'Temperature: 25-35°C',
          'Abundant water',
        ],
        imageUrl: '',
      ));
    }

    if (soilData.rainfall > 800) {
      recommendations.add(CropRecommendation(
        cropName: 'Cotton',
        cropType: 'Cash Crop',
        suitabilityScore: 0.85,
        season: 'Kharif',
        growthDuration: 150,
        expectedYield: 20.0,
        soilType: 'Black/Red',
        waterRequirement: 'Medium',
        advantages: [
          'High economic value',
          'Multiple products (fiber, oil)',
          'Good export potential',
        ],
        requirements: [
          'pH: 6.5-8.0',
          'Temperature: 21-30°C',
          'Rainfall: 600-1200mm',
        ],
        imageUrl: '',
      ));
    }

    // Sort by suitability score
    recommendations.sort((a, b) => b.suitabilityScore.compareTo(a.suitabilityScore));

    return recommendations.take(5).toList();
  }

  Future<Map<String, dynamic>> analyzeSoilHealth(SoilData soilData) async {
    final String healthStatus;
    final double healthScore;
    final List<String> recommendations = [];

    // Calculate soil health score (0-100)
    double score = 50.0;

    // pH analysis
    if (soilData.ph >= 6.0 && soilData.ph <= 7.5) {
      score += 15;
    } else {
      recommendations.add('Adjust soil pH to 6.0-7.5 for optimal growth');
    }

    // NPK analysis
    if (soilData.nitrogen >= 200 && soilData.nitrogen <= 300) {
      score += 10;
    } else if (soilData.nitrogen < 200) {
      recommendations.add('Add nitrogen-rich fertilizer');
    }

    if (soilData.phosphorus >= 20 && soilData.phosphorus <= 40) {
      score += 10;
    } else if (soilData.phosphorus < 20) {
      recommendations.add('Add phosphate fertilizer');
    }

    if (soilData.potassium >= 200 && soilData.potassium <= 300) {
      score += 10;
    } else if (soilData.potassium < 200) {
      recommendations.add('Add potash fertilizer');
    }

    // Moisture analysis
    if (soilData.moisture >= 40 && soilData.moisture <= 60) {
      score += 5;
    } else {
      recommendations.add('Maintain soil moisture between 40-60%');
    }

    healthScore = score;

    if (healthScore >= 80) {
      healthStatus = 'Excellent';
    } else if (healthScore >= 60) {
      healthStatus = 'Good';
    } else if (healthScore >= 40) {
      healthStatus = 'Fair';
    } else {
      healthStatus = 'Poor';
    }

    return {
      'healthStatus': healthStatus,
      'healthScore': healthScore,
      'recommendations': recommendations,
      'npkRatio': '${soilData.nitrogen}:${soilData.phosphorus}:${soilData.potassium}',
    };
  }
}
