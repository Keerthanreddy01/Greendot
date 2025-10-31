import '../models/fertilizer_model.dart';

class FertilizerAdvisorService {
  static final FertilizerAdvisorService _instance = FertilizerAdvisorService._internal();
  factory FertilizerAdvisorService() => _instance;
  FertilizerAdvisorService._internal();

  Future<List<FertilizerRecommendation>> recommendFertilizers(
    InputRecommendationRequest request,
  ) async {
    // Simulate AI processing
    await Future.delayed(const Duration(seconds: 1));

    List<FertilizerRecommendation> recommendations = [];

    // NPK recommendations based on soil levels
    if (request.nitrogenLevel < 200) {
      recommendations.add(FertilizerRecommendation(
        name: 'Urea',
        type: 'Chemical',
        npkRatio: '46-0-0',
        quantity: 50,
        applicationMethod: 'Broadcasting or top dressing',
        timing: 'Split application: 50% at sowing, 25% at tillering, 25% at flowering',
        benefits: [
          'Quick nitrogen supply',
          'Promotes vegetative growth',
          'Improves leaf color',
          'Cost-effective',
        ],
        precautions: [
          'Do not apply on waterlogged soil',
          'Maintain 5-7 days gap from irrigation',
          'Store in dry place',
        ],
        isOrganic: false,
        price: 300,
      ));

      recommendations.add(FertilizerRecommendation(
        name: 'Vermicompost',
        type: 'Organic',
        npkRatio: '2-1-1',
        quantity: 500,
        applicationMethod: 'Mix with soil or top dressing',
        timing: 'Apply 2-3 weeks before sowing',
        benefits: [
          'Improves soil structure',
          'Increases water retention',
          'Adds beneficial microbes',
          'Long-lasting effect',
        ],
        precautions: [
          'Ensure complete decomposition',
          'Mix well with soil',
          'Avoid over-application',
        ],
        isOrganic: true,
        price: 150,
      ));
    }

    if (request.phosphorusLevel < 15) {
      recommendations.add(FertilizerRecommendation(
        name: 'DAP (Diammonium Phosphate)',
        type: 'Chemical',
        npkRatio: '18-46-0',
        quantity: 40,
        applicationMethod: 'Basal application',
        timing: 'At the time of sowing or transplanting',
        benefits: [
          'High phosphorus content',
          'Promotes root development',
          'Improves flowering and fruiting',
          'Enhances crop maturity',
        ],
        precautions: [
          'Apply below seed level',
          'Avoid direct contact with seeds',
          'Use protective gear during handling',
        ],
        isOrganic: false,
        price: 350,
      ));
    }

    if (request.potassiumLevel < 150) {
      recommendations.add(FertilizerRecommendation(
        name: 'Muriate of Potash (MOP)',
        type: 'Chemical',
        npkRatio: '0-0-60',
        quantity: 30,
        applicationMethod: 'Broadcasting or banding',
        timing: 'Split application: 50% basal, 50% at flowering',
        benefits: [
          'Improves crop quality',
          'Enhances disease resistance',
          'Better water use efficiency',
          'Improves shelf life of produce',
        ],
        precautions: [
          'Not suitable for chloride-sensitive crops',
          'Avoid over-application',
          'Maintain proper soil moisture',
        ],
        isOrganic: false,
        price: 280,
      ));
    }

    // Organic alternatives for all crops
    if (request.soilType == 'clay' || request.soilPh > 7.5) {
      recommendations.add(FertilizerRecommendation(
        name: 'Gypsum',
        type: 'Organic',
        npkRatio: '0-0-0',
        quantity: 250,
        applicationMethod: 'Broadcasting and incorporation',
        timing: 'Before sowing or during land preparation',
        benefits: [
          'Improves soil structure in clay soils',
          'Reduces soil pH',
          'Adds calcium and sulfur',
          'Improves water penetration',
        ],
        precautions: [
          'Mix thoroughly with soil',
          'May take time to show effect',
          'Test soil pH before application',
        ],
        isOrganic: true,
        price: 120,
      ));
    }

    return recommendations;
  }

  Future<List<PesticideRecommendation>> recommendPesticides(
    InputRecommendationRequest request,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    List<PesticideRecommendation> recommendations = [];

    // Common pest recommendations
    recommendations.add(PesticideRecommendation(
      name: 'Neem Oil',
      type: 'Bio-pesticide',
      targetPest: 'Aphids, Whiteflies, Mites',
      activeIngredient: 'Azadirachtin',
      dosage: 5,
      applicationMethod: 'Foliar spray',
      safetyPeriod: '1 day',
      precautions: [
        'Apply in early morning or evening',
        'Avoid application during flowering',
        'Safe for beneficial insects',
        'Repeat application every 7-10 days',
      ],
      toxicityLevel: 'Low',
      isBioPesticide: true,
      price: 200,
    ));

    if (request.detectedDisease?.contains('Blight') ?? false) {
      recommendations.add(PesticideRecommendation(
        name: 'Copper Oxychloride',
        type: 'Fungicide',
        targetPest: 'Late Blight, Early Blight',
        activeIngredient: 'Copper Oxychloride 50% WP',
        dosage: 3,
        applicationMethod: 'Foliar spray',
        safetyPeriod: '7 days',
        precautions: [
          'Use protective clothing',
          'Do not spray during hot weather',
          'Maintain proper interval between sprays',
          'Do not exceed recommended dose',
        ],
        toxicityLevel: 'Moderate',
        isBioPesticide: false,
        price: 150,
      ));
    }

    recommendations.add(PesticideRecommendation(
      name: 'Bacillus thuringiensis (Bt)',
      type: 'Bio-pesticide',
      targetPest: 'Caterpillars, Leaf eaters',
      activeIngredient: 'Bacillus thuringiensis',
      dosage: 2,
      applicationMethod: 'Foliar spray',
      safetyPeriod: '0 days',
      precautions: [
        'Apply when larvae are young',
        'Completely safe for humans and animals',
        'Store in cool, dry place',
        'Use fresh preparation',
      ],
      toxicityLevel: 'Low',
      isBioPesticide: true,
      price: 180,
    ));

    recommendations.add(PesticideRecommendation(
      name: 'Pheromone Traps',
      type: 'Bio-pesticide',
      targetPest: 'Fruit flies, Moths',
      activeIngredient: 'Species-specific pheromones',
      dosage: 10, // traps per acre
      applicationMethod: 'Install traps in field',
      safetyPeriod: '0 days',
      precautions: [
        'Replace lures every 30-45 days',
        'Install at appropriate height',
        'No chemical exposure',
        'Environmentally friendly',
      ],
      toxicityLevel: 'Low',
      isBioPesticide: true,
      price: 350,
    ));

    return recommendations;
  }

  String getSafetyRating(PesticideRecommendation pesticide) {
    if (pesticide.isBioPesticide) return 'Safest - Organic farming approved';
    if (pesticide.toxicityLevel == 'Low') return 'Safe - Minimal precautions needed';
    if (pesticide.toxicityLevel == 'Moderate') return 'Moderate - Follow safety guidelines';
    return 'Use with caution - Strict safety measures required';
  }

  String getApplicationTips(String cropStage) {
    switch (cropStage.toLowerCase()) {
      case 'seedling':
        return 'Focus on soil health with organic matter. Avoid heavy chemical applications.';
      case 'vegetative':
        return 'Increase nitrogen for leaf growth. Monitor for early pest signs.';
      case 'flowering':
        return 'Reduce nitrogen, increase potassium. Avoid pesticide spraying during peak flowering.';
      case 'fruiting':
        return 'Balanced NPK with emphasis on potassium. Use only bio-pesticides if needed.';
      default:
        return 'Follow stage-specific fertilization schedule.';
    }
  }
}
