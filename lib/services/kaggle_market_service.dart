import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/market_data_model.dart';

class KaggleMarketService {
  static const String _cacheKey = 'cached_market_data';
  static const String _lastUpdateKey = 'last_market_update';
  
  // Example URL - Replace with your actual Kaggle Dataset Direct Download URL or Hosted CSV
  static const String _defaultUrl = 'https://raw.githubusercontent.com/Keerthanreddy01/Greendot/main/assets/data/mandi_prices_sample.csv';

  /// Fetches market data with caching and retry logic
  Future<List<MarketData>> fetchMarketData({String? url, bool forceRefresh = false}) async {
    final targetUrl = url ?? _defaultUrl;
    final prefs = await SharedPreferences.getInstance();
    
    // 1. Check Caching Strategy
    if (!forceRefresh) {
      final lastUpdate = prefs.getString(_lastUpdateKey);
      if (lastUpdate != null) {
        final lastUpdateTime = DateTime.parse(lastUpdate);
        // If data is less than 12 hours old, use cache
        if (DateTime.now().difference(lastUpdateTime).inHours < 12) {
          final cachedData = prefs.getString(_cacheKey);
          if (cachedData != null) {
            return _parseJsonList(cachedData);
          }
        }
      }
    }

    // 2. Network Fetch with Retry Logic
    try {
      final response = await _fetchWithRetry(targetUrl);
      
      if (response.statusCode == 200) {
        // 3. Parse CSV
        final List<List<dynamic>> rows = const CsvToListConverter().convert(response.body);
        
        // Skip header row and convert to objects
        final List<MarketData> data = rows.skip(1)
            .where((row) => row.length >= 8) // Basic validation
            .map((row) => MarketData.fromCsv(row))
            .toList();

        // 4. Update Cache
        await prefs.setString(_cacheKey, jsonEncode(data.map((e) => e.toJson()).toList()));
        await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());

        return data;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      // 5. Fallback to Cache on Error
      final cachedData = prefs.getString(_cacheKey);
      if (cachedData != null) {
        return _parseJsonList(cachedData);
      }
      rethrow;
    }
  }

  Future<http.Response> _fetchWithRetry(String url, {int retries = 3}) async {
    int attempt = 0;
    while (attempt < retries) {
      try {
        return await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));
      } catch (e) {
        attempt++;
        if (attempt >= retries) rethrow;
        await Future.delayed(Duration(seconds: attempt * 2));
      }
    }
    throw Exception('Max retries reached');
  }

  List<MarketData> _parseJsonList(String jsonStr) {
    final List<dynamic> list = jsonDecode(jsonStr);
    return list.map((item) => MarketData.fromJson(item)).toList();
  }

  /// Rural Optimization: Filter locally for faster responsiveness
  List<MarketData> filterData(List<MarketData> allData, {
    String? state,
    String? district,
    String? commodity,
  }) {
    return allData.where((item) {
      bool matchesState = state == null || state.isEmpty || item.state == state;
      bool matchesDistrict = district == null || district.isEmpty || item.district == district;
      bool matchesCommodity = commodity == null || commodity.isEmpty || 
          item.commodity.toLowerCase().contains(commodity.toLowerCase());
      return matchesState && matchesDistrict && matchesCommodity;
    }).toList();
  }
}
