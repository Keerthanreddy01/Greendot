import 'package:intl/intl.dart';

class MarketData {
  final DateTime date;
  final String state;
  final String district;
  final String market;
  final String commodity;
  final double minPrice;
  final double maxPrice;
  final double modalPrice;

  MarketData({
    required this.date,
    required this.state,
    required this.district,
    required this.market,
    required this.commodity,
    required this.minPrice,
    required this.maxPrice,
    required this.modalPrice,
  });

  // Factory to parse CSV row (Kaggle format: date, state, district, market, commodity, min, max, modal)
  factory MarketData.fromCsv(List<dynamic> row) {
    return MarketData(
      date: _parseDate(row[0].toString()),
      state: row[1].toString(),
      district: row[2].toString(),
      market: row[3].toString(),
      commodity: row[4].toString(),
      minPrice: double.tryParse(row[5].toString()) ?? 0.0,
      maxPrice: double.tryParse(row[6].toString()) ?? 0.0,
      modalPrice: double.tryParse(row[7].toString()) ?? 0.0,
    );
  }

  factory MarketData.fromJson(Map<String, dynamic> json) {
    return MarketData(
      date: DateTime.parse(json['date']),
      state: json['state'],
      district: json['district'],
      market: json['market'],
      commodity: json['commodity'],
      minPrice: (json['min_price'] as num).toDouble(),
      maxPrice: (json['max_price'] as num).toDouble(),
      modalPrice: (json['modal_price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'state': state,
      'district': district,
      'market': market,
      'commodity': commodity,
      'min_price': minPrice,
      'max_price': maxPrice,
      'modal_price': modalPrice,
    };
  }

  static DateTime _parseDate(String dateStr) {
    try {
      // Handles formats like DD/MM/YYYY or YYYY-MM-DD
      if (dateStr.contains('/')) {
        return DateFormat('dd/MM/yyyy').parse(dateStr);
      }
      return DateTime.parse(dateStr);
    } catch (e) {
      return DateTime.now();
    }
  }

  // Trend logic calculated from modal price
  String get trend {
    // In a real scenario, this would compare with previous day's data
    // For now, we calculate based on where modal price sits between min/max
    double range = maxPrice - minPrice;
    if (range == 0) return 'stable';
    double position = (modalPrice - minPrice) / range;
    if (position > 0.6) return 'up';
    if (position < 0.4) return 'down';
    return 'stable';
  }
}
