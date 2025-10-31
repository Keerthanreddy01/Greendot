class MarketPrice {
  final String cropName;
  final String cropNameLocal;
  final double minPrice;
  final double maxPrice;
  final String unit;
  final String marketName;
  final String location;
  final double distanceKm;
  final DateTime lastUpdated;
  final String trend; // up, down, stable
  final double changePercent;

  MarketPrice({
    required this.cropName,
    required this.cropNameLocal,
    required this.minPrice,
    required this.maxPrice,
    required this.unit,
    required this.marketName,
    required this.location,
    required this.distanceKm,
    required this.lastUpdated,
    required this.trend,
    required this.changePercent,
  });

  double get avgPrice => (minPrice + maxPrice) / 2;

  factory MarketPrice.fromJson(Map<String, dynamic> json) {
    return MarketPrice(
      cropName: json['cropName'] ?? '',
      cropNameLocal: json['cropNameLocal'] ?? '',
      minPrice: (json['minPrice'] ?? 0).toDouble(),
      maxPrice: (json['maxPrice'] ?? 0).toDouble(),
      unit: json['unit'] ?? 'quintal',
      marketName: json['marketName'] ?? '',
      location: json['location'] ?? '',
      distanceKm: (json['distanceKm'] ?? 0).toDouble(),
      lastUpdated: json['lastUpdated'] != null 
          ? DateTime.parse(json['lastUpdated']) 
          : DateTime.now(),
      trend: json['trend'] ?? 'stable',
      changePercent: (json['changePercent'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cropName': cropName,
      'cropNameLocal': cropNameLocal,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'unit': unit,
      'marketName': marketName,
      'location': location,
      'distanceKm': distanceKm,
      'lastUpdated': lastUpdated.toIso8601String(),
      'trend': trend,
      'changePercent': changePercent,
    };
  }
}
