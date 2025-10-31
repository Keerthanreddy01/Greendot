import '../models/market_price_model.dart';

class MarketPriceService {
  // Demo market prices for major crops - Comprehensive list
  static List<MarketPrice> getDemoPrices() {
    final now = DateTime.now();
    
    return [
      // Cotton - Multiple markets
      MarketPrice(
        cropName: 'Cotton',
        cropNameLocal: 'कपास / పత్తి',
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
        cropNameLocal: 'कपास / పత్తి',
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
      MarketPrice(
        cropName: 'Cotton',
        cropNameLocal: 'कपास / పత్తి',
        minPrice: 5100,
        maxPrice: 6300,
        unit: 'quintal',
        marketName: 'Warangal APMC',
        location: 'Warangal, Telangana',
        distanceKm: 38.7,
        lastUpdated: now,
        trend: 'up',
        changePercent: 4.1,
      ),
      
      // Rice - Multiple markets
      MarketPrice(
        cropName: 'Rice',
        cropNameLocal: 'चावल / బియ్యం',
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
        cropNameLocal: 'चावल / బియ్యం',
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
      MarketPrice(
        cropName: 'Rice',
        cropNameLocal: 'चावल / బియ్యం',
        minPrice: 2860,
        maxPrice: 2920,
        unit: 'quintal',
        marketName: 'Hyderabad APMC',
        location: 'Hyderabad, Telangana',
        distanceKm: 72.5,
        lastUpdated: now,
        trend: 'up',
        changePercent: 1.8,
      ),
      
      // Wheat
      MarketPrice(
        cropName: 'Wheat',
        cropNameLocal: 'गेहूं / గోధుమ',
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
      MarketPrice(
        cropName: 'Wheat',
        cropNameLocal: 'गेहूं / గోధుమ',
        minPrice: 2180,
        maxPrice: 2380,
        unit: 'quintal',
        marketName: 'Nizamabad APMC',
        location: 'Nizamabad, Telangana',
        distanceKm: 42.1,
        lastUpdated: now,
        trend: 'up',
        changePercent: 3.5,
      ),
      
      // Maize
      MarketPrice(
        cropName: 'Maize',
        cropNameLocal: 'मक्का / మొక్కజొన్న',
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
      MarketPrice(
        cropName: 'Maize',
        cropNameLocal: 'मक्का / మొక్కజొన్న',
        minPrice: 1920,
        maxPrice: 1980,
        unit: 'quintal',
        marketName: 'Adilabad APMC',
        location: 'Adilabad, Telangana',
        distanceKm: 12.5,
        lastUpdated: now,
        trend: 'up',
        changePercent: 1.5,
      ),
      
      // Chilli
      MarketPrice(
        cropName: 'Chilli',
        cropNameLocal: 'मिर्च / మిరప',
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
      MarketPrice(
        cropName: 'Chilli',
        cropNameLocal: 'मिर्च / మిరప',
        minPrice: 11800,
        maxPrice: 12200,
        unit: 'quintal',
        marketName: 'Khammam APMC',
        location: 'Khammam, Telangana',
        distanceKm: 22.4,
        lastUpdated: now,
        trend: 'up',
        changePercent: 4.2,
      ),
      
      // Turmeric
      MarketPrice(
        cropName: 'Turmeric',
        cropNameLocal: 'हल्दी / పసుపు',
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
      MarketPrice(
        cropName: 'Turmeric',
        cropNameLocal: 'हल्दी / పసుపు',
        minPrice: 8400,
        maxPrice: 8600,
        unit: 'quintal',
        marketName: 'Sangareddy Market',
        location: 'Sangareddy, Telangana',
        distanceKm: 15.8,
        lastUpdated: now,
        trend: 'up',
        changePercent: 2.1,
      ),
      
      // Sugarcane
      MarketPrice(
        cropName: 'Sugarcane',
        cropNameLocal: 'गन्ना / చెరకు',
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
      MarketPrice(
        cropName: 'Sugarcane',
        cropNameLocal: 'गन्ना / చెరకు',
        minPrice: 335,
        maxPrice: 355,
        unit: 'quintal',
        marketName: 'Medak Sugar Mill',
        location: 'Medak, Telangana',
        distanceKm: 28.3,
        lastUpdated: now,
        trend: 'stable',
        changePercent: 0.0,
      ),
      
      // Soybean
      MarketPrice(
        cropName: 'Soybean',
        cropNameLocal: 'सोयाबीन / సోయాబీన్',
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
      MarketPrice(
        cropName: 'Soybean',
        cropNameLocal: 'सोयाबीन / సోయాబీన్',
        minPrice: 4180,
        maxPrice: 4320,
        unit: 'quintal',
        marketName: 'Warangal Market',
        location: 'Warangal, Telangana',
        distanceKm: 8.3,
        lastUpdated: now,
        trend: 'up',
        changePercent: 2.8,
      ),
      
      // Groundnut
      MarketPrice(
        cropName: 'Groundnut',
        cropNameLocal: 'मूंगफली / వేరుశనగ',
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
      MarketPrice(
        cropName: 'Groundnut',
        cropNameLocal: 'मूंगफली / వేరుశనగ',
        minPrice: 5750,
        maxPrice: 6050,
        unit: 'quintal',
        marketName: 'Warangal APMC',
        location: 'Warangal, Telangana',
        distanceKm: 8.3,
        lastUpdated: now,
        trend: 'down',
        changePercent: -0.8,
      ),
      
      // Tomato
      MarketPrice(
        cropName: 'Tomato',
        cropNameLocal: 'टमाटर / టమాట',
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
      MarketPrice(
        cropName: 'Tomato',
        cropNameLocal: 'टमाटर / టమాట',
        minPrice: 1150,
        maxPrice: 1400,
        unit: 'quintal',
        marketName: 'Sangareddy Market',
        location: 'Sangareddy, Telangana',
        distanceKm: 15.8,
        lastUpdated: now,
        trend: 'up',
        changePercent: 7.2,
      ),
      
      // Onion
      MarketPrice(
        cropName: 'Onion',
        cropNameLocal: 'प्याज / ఉల్లి',
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
      MarketPrice(
        cropName: 'Onion',
        cropNameLocal: 'प्याज / ఉల్లి',
        minPrice: 2150,
        maxPrice: 2450,
        unit: 'quintal',
        marketName: 'Karimnagar Market',
        location: 'Karimnagar, Telangana',
        distanceKm: 28.7,
        lastUpdated: now,
        trend: 'stable',
        changePercent: 0.5,
      ),
      
      // Additional crops
      // Potato
      MarketPrice(
        cropName: 'Potato',
        cropNameLocal: 'आलू / బంగాళాదుంప',
        minPrice: 1800,
        maxPrice: 2100,
        unit: 'quintal',
        marketName: 'Hyderabad APMC',
        location: 'Hyderabad, Telangana',
        distanceKm: 72.5,
        lastUpdated: now,
        trend: 'up',
        changePercent: 3.2,
      ),
      MarketPrice(
        cropName: 'Potato',
        cropNameLocal: 'आलू / బంగాళాదుంప',
        minPrice: 1750,
        maxPrice: 2050,
        unit: 'quintal',
        marketName: 'Warangal Market',
        location: 'Warangal, Telangana',
        distanceKm: 8.3,
        lastUpdated: now,
        trend: 'up',
        changePercent: 2.5,
      ),
      
      // Pigeon Pea (Toor Dal)
      MarketPrice(
        cropName: 'Pigeon Pea',
        cropNameLocal: 'तूर दाल / కంది',
        minPrice: 6800,
        maxPrice: 7200,
        unit: 'quintal',
        marketName: 'Karimnagar Market',
        location: 'Karimnagar, Telangana',
        distanceKm: 28.7,
        lastUpdated: now,
        trend: 'up',
        changePercent: 4.5,
      ),
      MarketPrice(
        cropName: 'Pigeon Pea',
        cropNameLocal: 'तूर दाल / కంది',
        minPrice: 6750,
        maxPrice: 7150,
        unit: 'quintal',
        marketName: 'Nizamabad APMC',
        location: 'Nizamabad, Telangana',
        distanceKm: 42.1,
        lastUpdated: now,
        trend: 'up',
        changePercent: 3.8,
      ),
      
      // Red Gram (Arhar Dal)
      MarketPrice(
        cropName: 'Red Gram',
        cropNameLocal: 'अरहर दाल / కంది పప్పు',
        minPrice: 7200,
        maxPrice: 7600,
        unit: 'quintal',
        marketName: 'Warangal APMC',
        location: 'Warangal, Telangana',
        distanceKm: 8.3,
        lastUpdated: now,
        trend: 'up',
        changePercent: 5.2,
      ),
      
      // Sunflower
      MarketPrice(
        cropName: 'Sunflower',
        cropNameLocal: 'सूरजमुखी / పొద్దుతిరుగుడు',
        minPrice: 5400,
        maxPrice: 5800,
        unit: 'quintal',
        marketName: 'Mahbubnagar Market',
        location: 'Mahbubnagar, Telangana',
        distanceKm: 52.3,
        lastUpdated: now,
        trend: 'up',
        changePercent: 3.5,
      ),
      
      // Sesame (Til)
      MarketPrice(
        cropName: 'Sesame',
        cropNameLocal: 'तिल / నువ్వులు',
        minPrice: 8200,
        maxPrice: 8600,
        unit: 'quintal',
        marketName: 'Nizamabad APMC',
        location: 'Nizamabad, Telangana',
        distanceKm: 42.1,
        lastUpdated: now,
        trend: 'up',
        changePercent: 2.8,
      ),
      
      // Coriander
      MarketPrice(
        cropName: 'Coriander',
        cropNameLocal: 'धनिया / కొత్తిమీర',
        minPrice: 6500,
        maxPrice: 7200,
        unit: 'quintal',
        marketName: 'Sangareddy Market',
        location: 'Sangareddy, Telangana',
        distanceKm: 15.8,
        lastUpdated: now,
        trend: 'stable',
        changePercent: 0.8,
      ),
      
      // Cumin (Jeera)
      MarketPrice(
        cropName: 'Cumin',
        cropNameLocal: 'जीरा / జీలకర్ర',
        minPrice: 28500,
        maxPrice: 29500,
        unit: 'quintal',
        marketName: 'Hyderabad APMC',
        location: 'Hyderabad, Telangana',
        distanceKm: 72.5,
        lastUpdated: now,
        trend: 'up',
        changePercent: 6.5,
      ),
      
      // Jowar (Sorghum)
      MarketPrice(
        cropName: 'Jowar',
        cropNameLocal: 'ज्वार / జొన్న',
        minPrice: 2200,
        maxPrice: 2400,
        unit: 'quintal',
        marketName: 'Mahbubnagar Market',
        location: 'Mahbubnagar, Telangana',
        distanceKm: 52.3,
        lastUpdated: now,
        trend: 'stable',
        changePercent: 0.5,
      ),
      
      // Bajra (Pearl Millet)
      MarketPrice(
        cropName: 'Bajra',
        cropNameLocal: 'बाजरा / సజ్జ',
        minPrice: 2000,
        maxPrice: 2150,
        unit: 'quintal',
        marketName: 'Warangal APMC',
        location: 'Warangal, Telangana',
        distanceKm: 8.3,
        lastUpdated: now,
        trend: 'up',
        changePercent: 2.2,
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
