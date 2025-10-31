class PriceForecast {
  final String commodity;
  final DateTime date;
  final double currentPrice;
  final double predictedPrice;
  final double confidence; // 0-1
  final String trend; // up, down, stable
  final double percentageChange;
  final List<PriceHistory> historicalData;
  final List<double> predictions; // next 7-30 days

  PriceForecast({
    required this.commodity,
    required this.date,
    required this.currentPrice,
    required this.predictedPrice,
    required this.confidence,
    required this.trend,
    required this.percentageChange,
    required this.historicalData,
    required this.predictions,
  });

  factory PriceForecast.fromJson(Map<String, dynamic> json) {
    return PriceForecast(
      commodity: json['commodity'] as String,
      date: DateTime.parse(json['date'] as String),
      currentPrice: (json['currentPrice'] as num).toDouble(),
      predictedPrice: (json['predictedPrice'] as num).toDouble(),
      confidence: (json['confidence'] as num).toDouble(),
      trend: json['trend'] as String,
      percentageChange: (json['percentageChange'] as num).toDouble(),
      historicalData: (json['historicalData'] as List)
          .map((h) => PriceHistory.fromJson(h as Map<String, dynamic>))
          .toList(),
      predictions: (json['predictions'] as List)
          .map((p) => (p as num).toDouble())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commodity': commodity,
      'date': date.toIso8601String(),
      'currentPrice': currentPrice,
      'predictedPrice': predictedPrice,
      'confidence': confidence,
      'trend': trend,
      'percentageChange': percentageChange,
      'historicalData': historicalData.map((h) => h.toJson()).toList(),
      'predictions': predictions,
    };
  }
}

class PriceHistory {
  final DateTime date;
  final double price;
  final String market;

  PriceHistory({
    required this.date,
    required this.price,
    required this.market,
  });

  factory PriceHistory.fromJson(Map<String, dynamic> json) {
    return PriceHistory(
      date: DateTime.parse(json['date'] as String),
      price: (json['price'] as num).toDouble(),
      market: json['market'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'price': price,
      'market': market,
    };
  }
}

class MarketData {
  final String commodity;
  final String market;
  final double minPrice;
  final double maxPrice;
  final double modalPrice;
  final String unit;
  final DateTime lastUpdated;
  final bool isCached;

  MarketData({
    required this.commodity,
    required this.market,
    required this.minPrice,
    required this.maxPrice,
    required this.modalPrice,
    required this.unit,
    required this.lastUpdated,
    this.isCached = false,
  });

  factory MarketData.fromJson(Map<String, dynamic> json) {
    return MarketData(
      commodity: json['commodity'] as String,
      market: json['market'] as String,
      minPrice: (json['minPrice'] as num).toDouble(),
      maxPrice: (json['maxPrice'] as num).toDouble(),
      modalPrice: (json['modalPrice'] as num).toDouble(),
      unit: json['unit'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      isCached: json['isCached'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commodity': commodity,
      'market': market,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'modalPrice': modalPrice,
      'unit': unit,
      'lastUpdated': lastUpdated.toIso8601String(),
      'isCached': isCached,
    };
  }
}
