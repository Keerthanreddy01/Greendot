import '../models/market_price_model.dart';

class MarketPriceService {
  // Demo market prices for major crops
  static List<MarketPrice> getDemoPrices() {
    final now = DateTime.now();
    
    return [
      // Cotton
      MarketPrice(
        cropName: 'Cotton',
        cropNameLocal: 'कपास',
        minPrice: 5000,
        maxPrice: 6200,
        unit: 'quintal',
        marketName: 'APMC Adilabad',
        location: 'Adilabad, Telangana',
        distanceKm: 12.5,
        lastUpdated: now,
        trend: 'up',
        changePercent: 3.5,
      ),
      MarketPrice(
        cropName: 'Cotton',
        cropNameLocal: 'कपास',
        minPrice: 4800,
        maxPrice: 5900,
        unit: 'quintal',
        marketName: 'Nizamabad Market',
        location: 'Nizamabad, Telangana',
        distanceKm: 45.2,
        lastUpdated: now,
        trend: 'up',
        changePercent: 2.8,
      ),
      
      // Rice
      MarketPrice(
        cropName: 'Rice',
        cropNameLocal: 'चावल',
        minPrice: 2840,
        maxPrice: 2890,
        unit: 'quintal',
        marketName: 'APMC Warangal',
        location: 'Warangal, Telangana',
        distanceKm: 8.3,
        lastUpdated: now,
        trend: 'stable',
        changePercent: 0.5,
      ),
      MarketPrice(
        cropName: 'Rice',
        cropNameLocal: 'चावल',
        minPrice: 2800,
        maxPrice: 2850,
        unit: 'quintal',
        marketName: 'Karimnagar Market',
        location: 'Karimnagar, Telangana',
        distanceKm: 28.7,
        lastUpdated: now,
        trend: 'down',
        changePercent: -1.2,
      ),
      
      // Wheat
      MarketPrice(
        cropName: 'Wheat',
        cropNameLocal: 'गेहूं',
        minPrice: 2200,
        maxPrice: 2400,
        unit: 'quintal',
        marketName: 'APMC Sangareddy',
        location: 'Sangareddy, Telangana',
        distanceKm: 15.8,
        lastUpdated: now,
        trend: 'up',
        changePercent: 4.2,
      ),
      
      // Maize
      MarketPrice(
        cropName: 'Maize',
        cropNameLocal: 'मक्का',
        minPrice: 1900,
        maxPrice: 1960,
        unit: 'quintal',
        marketName: 'Khammam Market',
        location: 'Khammam, Telangana',
        distanceKm: 22.4,
        lastUpdated: now,
        trend: 'stable',
        changePercent: 0.2,
      ),
      
      // Chilli
      MarketPrice(
        cropName: 'Chilli',
        cropNameLocal: 'मिर्च',
        minPrice: 12000,
        maxPrice: 12400,
        unit: 'quintal',
        marketName: 'Guntur Market',
        location: 'Guntur, Andhra Pradesh',
        distanceKm: 185.5,
        lastUpdated: now,
        trend: 'up',
        changePercent: 5.8,
      ),
      
      // Turmeric
      MarketPrice(
        cropName: 'Turmeric',
        cropNameLocal: 'हल्दी',
        minPrice: 8500,
        maxPrice: 8650,
        unit: 'quintal',
        marketName: 'APMC Nizamabad',
        location: 'Nizamabad, Telangana',
        distanceKm: 42.1,
        lastUpdated: now,
        trend: 'up',
        changePercent: 2.5,
      ),
      
      // Sugarcane
      MarketPrice(
        cropName: 'Sugarcane',
        cropNameLocal: 'गन्ना',
        minPrice: 340,
        maxPrice: 360,
        unit: 'quintal',
        marketName: 'Sugar Factory Nalgonda',
        location: 'Nalgonda, Telangana',
        distanceKm: 35.6,
        lastUpdated: now,
        trend: 'stable',
        changePercent: 0.0,
      ),
      
      // Soybean
      MarketPrice(
        cropName: 'Soybean',
        cropNameLocal: 'सोयाबीन',
        minPrice: 4200,
        maxPrice: 4350,
        unit: 'quintal',
        marketName: 'APMC Adilabad',
        location: 'Adilabad, Telangana',
        distanceKm: 12.5,
        lastUpdated: now,
        trend: 'up',
        changePercent: 3.2,
      ),
      
      // Groundnut
      MarketPrice(
        cropName: 'Groundnut',
        cropNameLocal: 'मूंगफली',
        minPrice: 5800,
        maxPrice: 6100,
        unit: 'quintal',
        marketName: 'Mahbubnagar Market',
        location: 'Mahbubnagar, Telangana',
        distanceKm: 52.3,
        lastUpdated: now,
        trend: 'down',
        changePercent: -1.5,
      ),
      
      // Tomato
      MarketPrice(
        cropName: 'Tomato',
        cropNameLocal: 'टमाटर',
        minPrice: 1200,
        maxPrice: 1450,
        unit: 'quintal',
        marketName: 'Vegetable Market Hyderabad',
        location: 'Hyderabad, Telangana',
        distanceKm: 68.9,
        lastUpdated: now,
        trend: 'up',
        changePercent: 8.5,
      ),
      
      // Onion
      MarketPrice(
        cropName: 'Onion',
        cropNameLocal: 'प्याज',
        minPrice: 2200,
        maxPrice: 2500,
        unit: 'quintal',
        marketName: 'APMC Sangareddy',
        location: 'Sangareddy, Telangana',
        distanceKm: 15.8,
        lastUpdated: now,
        trend: 'stable',
        changePercent: 1.0,
      ),
    ];
  }

  // Get prices for a specific crop
  static List<MarketPrice> getPricesForCrop(String cropName) {
    return getDemoPrices()
        .where((price) => price.cropName.toLowerCase() == cropName.toLowerCase())
        .toList();
  }

  // Get nearby markets (sorted by distance)
  static List<MarketPrice> getNearbyMarkets({double maxDistanceKm = 50}) {
    final prices = getDemoPrices();
    prices.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return prices.where((p) => p.distanceKm <= maxDistanceKm).toList();
  }

  // Get trending prices (prices going up)
  static List<MarketPrice> getTrendingPrices() {
    return getDemoPrices()
        .where((price) => price.trend == 'up' && price.changePercent > 2.0)
        .toList()
      ..sort((a, b) => b.changePercent.compareTo(a.changePercent));
  }

  // Get best prices (highest average price)
  static List<MarketPrice> getBestPrices() {
    final prices = getDemoPrices();
    prices.sort((a, b) => b.avgPrice.compareTo(a.avgPrice));
    return prices;
  }

  // Search crops
  static List<MarketPrice> searchCrops(String query) {
    final lowerQuery = query.toLowerCase();
    return getDemoPrices()
        .where((price) =>
            price.cropName.toLowerCase().contains(lowerQuery) ||
            price.cropNameLocal.contains(query))
        .toList();
  }
}
