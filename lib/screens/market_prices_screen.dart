import 'package:flutter/material.dart';
import '../models/market_price_model.dart';
import '../services/market_price_service.dart';
import '../widgets/bottom_navigation.dart';

class MarketPricesScreen extends StatefulWidget {
  const MarketPricesScreen({super.key});

  @override
  State<MarketPricesScreen> createState() => _MarketPricesScreenState();
}

class _MarketPricesScreenState extends State<MarketPricesScreen> {
  List<MarketPrice> _allPrices = [];
  List<MarketPrice> _filteredPrices = [];
  String _selectedTab = 'Sort by: Price';
  
  @override
  void initState() {
    super.initState();
    _loadPrices();
  }

  void _loadPrices() {
    setState(() {
      _allPrices = MarketPriceService.getDemoPrices();
      _filteredPrices = _allPrices;
      // Sort by price by default
      _filteredPrices.sort((a, b) => b.avgPrice.compareTo(a.avgPrice));
    });
  }

  void _handleTabChange(String tab) {
    setState(() {
      _selectedTab = tab;
      if (tab == 'Sort by: Price') {
        _filteredPrices.sort((a, b) => b.avgPrice.compareTo(a.avgPrice));
      } else if (tab == 'Filter') {
        _filteredPrices = _allPrices;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final featuredCrop = _allPrices.isNotEmpty ? _allPrices[0] : null;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFE8F5E9),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2E7D32)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Market Prices',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF2E7D32)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Featured Crop Card (Wheat)
          if (featuredCrop != null) _buildFeaturedCropCard(featuredCrop),
          
          // Tabs
          _buildTabs(),
          
          // Crop List
          Expanded(
            child: _buildCropList(),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 2),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.mic, color: Colors.white),
      ),
    );
  }

  Widget _buildFeaturedCropCard(MarketPrice price) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Illustration placeholder
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFF9E6),
                  Color(0xFFE8F5E9),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.agriculture,
                size: 60,
                color: Colors.orange.shade700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${price.cropName} (${price.cropNameLocal})',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Today\'s Price:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹ ${price.avgPrice.toStringAsFixed(0)} / ${price.unit}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.trending_up,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    final tabs = ['Sort by: Price', 'Filter', 'Tasks & Alerts'];
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = _selectedTab == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => _handleTabChange(tab),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Colors.grey[200] 
                      : const Color(0xFFFAF5E8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      tab,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected 
                            ? const Color(0xFF2E7D32) 
                            : Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (isSelected)
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        height: 2,
                        width: 40,
                        color: const Color(0xFF2E7D32),
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCropList() {
    if (_filteredPrices.isEmpty) {
      return const Center(
        child: Text(
          'No crops found',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredPrices.length,
      itemBuilder: (context, index) {
        return _buildCropCard(_filteredPrices[index], index);
      },
    );
  }

  Widget _buildCropCard(MarketPrice price, int index) {
    Color trendColor = price.trend == 'up'
        ? const Color(0xFF4CAF50)
        : price.trend == 'down'
            ? Colors.red.shade600
            : Colors.grey.shade600;

    IconData cropIcon = index % 3 == 0 
        ? Icons.agriculture 
        : index % 3 == 1 
            ? Icons.eco 
            : Icons.grass;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              cropIcon,
              color: Colors.orange.shade700,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${price.cropName} (${price.cropNameLocal})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price.marketName,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${price.avgPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: price.trend == 'up' 
                          ? Colors.red 
                          : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        price.trend == 'up' 
                            ? '3' 
                            : price.trend == 'down'
                                ? '↓'
                                : '→',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (price.trend == 'down')
                    Text(
                      '-${price.changePercent.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: trendColor,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else if (price.trend == 'up')
                    Text(
                      '↗ ${price.changePercent.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: trendColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '₹ ${price.avgPrice.toStringAsFixed(0)} / ${price.unit}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
