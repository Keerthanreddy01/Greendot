class CropRecommendation {
  final String cropName;
  final String cropType;
  final double suitabilityScore;
  final String season;
  final int growthDuration;
  final double expectedYield;
  final String soilType;
  final String waterRequirement;
  final List<String> advantages;
  final List<String> requirements;
  final String imageUrl;

  CropRecommendation({
    required this.cropName,
    required this.cropType,
    required this.suitabilityScore,
    required this.season,
    required this.growthDuration,
    required this.expectedYield,
    required this.soilType,
    required this.waterRequirement,
    required this.advantages,
    required this.requirements,
    required this.imageUrl,
  });

  factory CropRecommendation.fromJson(Map<String, dynamic> json) {
    return CropRecommendation(
      cropName: json['cropName'] ?? '',
      cropType: json['cropType'] ?? '',
      suitabilityScore: (json['suitabilityScore'] ?? 0.0).toDouble(),
      season: json['season'] ?? '',
      growthDuration: json['growthDuration'] ?? 0,
      expectedYield: (json['expectedYield'] ?? 0.0).toDouble(),
      soilType: json['soilType'] ?? '',
      waterRequirement: json['waterRequirement'] ?? '',
      advantages: List<String>.from(json['advantages'] ?? []),
      requirements: List<String>.from(json['requirements'] ?? []),
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cropName': cropName,
      'cropType': cropType,
      'suitabilityScore': suitabilityScore,
      'season': season,
      'growthDuration': growthDuration,
      'expectedYield': expectedYield,
      'soilType': soilType,
      'waterRequirement': waterRequirement,
      'advantages': advantages,
      'requirements': requirements,
      'imageUrl': imageUrl,
    };
  }
}

class SoilData {
  final String soilType;
  final double nitrogen;
  final double phosphorus;
  final double potassium;
  final double ph;
  final double moisture;
  final double temperature;
  final double humidity;
  final double rainfall;

  SoilData({
    required this.soilType,
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.ph,
    required this.moisture,
    required this.temperature,
    required this.humidity,
    required this.rainfall,
  });

  Map<String, dynamic> toJson() {
    return {
      'soilType': soilType,
      'nitrogen': nitrogen,
      'phosphorus': phosphorus,
      'potassium': potassium,
      'ph': ph,
      'moisture': moisture,
      'temperature': temperature,
      'humidity': humidity,
      'rainfall': rainfall,
    };
  }
}
