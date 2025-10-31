class FertilizerRecommendation {
  final String name;
  final String type; // Organic, Chemical, Bio
  final String npkRatio; // e.g., "10-26-26"
  final double quantity; // kg per acre
  final String applicationMethod;
  final String timing;
  final List<String> benefits;
  final List<String> precautions;
  final bool isOrganic;
  final double price; // per kg
  final String? imageUrl;

  FertilizerRecommendation({
    required this.name,
    required this.type,
    required this.npkRatio,
    required this.quantity,
    required this.applicationMethod,
    required this.timing,
    required this.benefits,
    required this.precautions,
    this.isOrganic = false,
    required this.price,
    this.imageUrl,
  });
}

class PesticideRecommendation {
  final String name;
  final String type; // Insecticide, Fungicide, Herbicide, Bio-pesticide
  final String targetPest;
  final String activeIngredient;
  final double dosage; // ml or gm per liter
  final String applicationMethod;
  final String safetyPeriod; // days before harvest
  final List<String> precautions;
  final String toxicityLevel; // Low, Moderate, High
  final bool isBioPesticide;
  final double price;
  final String? imageUrl;

  PesticideRecommendation({
    required this.name,
    required this.type,
    required this.targetPest,
    required this.activeIngredient,
    required this.dosage,
    required this.applicationMethod,
    required this.safetyPeriod,
    required this.precautions,
    required this.toxicityLevel,
    this.isBioPesticide = false,
    required this.price,
    this.imageUrl,
  });
}

class InputRecommendationRequest {
  final String cropName;
  final String cropStage; // Seedling, Vegetative, Flowering, Fruiting
  final String soilType;
  final double soilPh;
  final double nitrogenLevel;
  final double phosphorusLevel;
  final double potassiumLevel;
  final String? detectedDisease;
  final String? detectedPest;
  final String season;

  InputRecommendationRequest({
    required this.cropName,
    required this.cropStage,
    required this.soilType,
    required this.soilPh,
    required this.nitrogenLevel,
    required this.phosphorusLevel,
    required this.potassiumLevel,
    this.detectedDisease,
    this.detectedPest,
    required this.season,
  });
}
