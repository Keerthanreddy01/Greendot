class DiseaseDetectionResult {
  final String diseaseName;
  final double confidence;
  final double healthScore;
  final String severity;
  final List<String> symptoms;
  final List<String> treatments;
  final List<String> preventions;
  final String imageUrl;

  DiseaseDetectionResult({
    required this.diseaseName,
    required this.confidence,
    required this.healthScore,
    required this.severity,
    required this.symptoms,
    required this.treatments,
    required this.preventions,
    required this.imageUrl,
  });

  factory DiseaseDetectionResult.fromJson(Map<String, dynamic> json) {
    return DiseaseDetectionResult(
      diseaseName: json['diseaseName'] ?? 'Unknown',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      healthScore: (json['healthScore'] ?? 0.0).toDouble(),
      severity: json['severity'] ?? 'Unknown',
      symptoms: List<String>.from(json['symptoms'] ?? []),
      treatments: List<String>.from(json['treatments'] ?? []),
      preventions: List<String>.from(json['preventions'] ?? []),
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diseaseName': diseaseName,
      'confidence': confidence,
      'healthScore': healthScore,
      'severity': severity,
      'symptoms': symptoms,
      'treatments': treatments,
      'preventions': preventions,
      'imageUrl': imageUrl,
    };
  }
}
