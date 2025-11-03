import 'package:flutter/material.dart';
import '../models/market_price_model.dart';
import '../services/market_price_service.dart';

class MarketPricesScreen extends StatefulWidget {
  const MarketPricesScreen({super.key});

  @override
  State<MarketPricesScreen> createState() => _MarketPricesScreenState();
}

class _MarketPricesScreenState extends State<MarketPricesScreen> {
  List<MarketPrice> _allPrices = [];
  String _sortBy = 'price'; // price, distance, trending

  @override
  void initState() {
    super.initState();
    _loadPrices();
  }

  void _loadPrices() {
    setState(() {
      _allPrices = MarketPriceService.getDemoPrices();
      _sortPrices();
    });
  }

  void _sortPrices() {
    if (_sortBy == 'price') {
      _allPrices.sort((a, b) => b.avgPrice.compareTo(a.avgPrice));
    } else if (_sortBy == 'distance') {
      _allPrices.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    } else if (_sortBy == 'trending') {
      _allPrices.sort((a, b) => b.changePercent.compareTo(a.changePercent));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Market Prices 📊',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.green[700],
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort, color: Colors.white),
            onSelected: (value) {
              setState(() {
                _sortBy = value;
                _sortPrices();
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'price',
                child: Row(
                  children: [
                    Icon(Icons.currency_rupee, size: 20),
                    SizedBox(width: 8),
                    Text('Sort by Price'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'distance',
                child: Row(
                  children: [
                    Icon(Icons.location_on, size: 20),
                    SizedBox(width: 8),
                    Text('Sort by Distance'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'trending',
                child: Row(
                  children: [
                    Icon(Icons.trending_up, size: 20),
                    SizedBox(width: 8),
                    Text('Sort by Trending'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          _loadPrices();
        },
        child: _allPrices.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _allPrices.length,
                itemBuilder: (context, index) {
                  final price = _allPrices[index];
                  return _buildPriceCard(price, index);
                },
              ),
      ),
    );
  }

  Widget _buildPriceCard(MarketPrice price, int index) {
    Color trendColor = Colors.grey;
    IconData trendIcon = Icons.trending_flat;
    Color gradientStart = Colors.green[400]!;
    Color gradientEnd = Colors.green[600]!;

    if (price.trend == 'up') {
      trendColor = Colors.green;
      trendIcon = Icons.trending_up;
      gradientStart = Colors.green[400]!;
      gradientEnd = Colors.green[600]!;
    } else if (price.trend == 'down') {
      trendColor = Colors.red;
      trendIcon = Icons.trending_down;
      gradientStart = Colors.orange[400]!;
      gradientEnd = Colors.red[400]!;
    } else {
      gradientStart = Colors.blue[400]!;
      gradientEnd = Colors.blue[600]!;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(
                color: trendColor,
                width: 5,
              ),
            ),
          ),
          child: Column(
            children: [
              // Header with gradient
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      gradientStart.withOpacity(0.1),
                      gradientEnd.withOpacity(0.05),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    // Crop Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: trendColor.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.agriculture,
                        color: trendColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Crop Name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            price.cropName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            price.cropNameLocal,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Trend Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: trendColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: trendColor.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(trendIcon, color: trendColor, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '${price.changePercent >= 0 ? '+' : ''}${price.changePercent.toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: trendColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Price Details
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Price Range Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildPriceBox(
                            'Min Price',
                            '₹${price.minPrice.toStringAsFixed(0)}',
                            Colors.orange,
                            Icons.arrow_downward,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildPriceBox(
                            'Avg Price',
                            '₹${price.avgPrice.toStringAsFixed(0)}',
                            Colors.blue,
                            Icons.show_chart,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildPriceBox(
                            'Max Price',
                            '₹${price.maxPrice.toStringAsFixed(0)}',
                            Colors.green,
                            Icons.arrow_upward,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Market Info Card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey[200]!,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.store,
                                  color: Colors.green[700],
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      price.marketName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      price.location,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: Colors.blue[700],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${price.distanceKm} km',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(height: 1),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: Colors.grey[500],
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Updated ${_formatDate(price.lastUpdated)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.purple[50],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Per ${price.unit}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.purple[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceBox(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
