import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/market_data_model.dart';
import '../providers/market_data_provider.dart';
import '../localization/app_localizations.dart';

class MarketPricesScreen extends StatefulWidget {
  const MarketPricesScreen({super.key});

  @override
  State<MarketPricesScreen> createState() => _MarketPricesScreenState();
}

class _MarketPricesScreenState extends State<MarketPricesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          l10n.mandiPrices,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.green[700],
        elevation: 2,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => 
                    context.read<MarketDataProvider>().setFilters(query: value),
                  decoration: InputDecoration(
                    hintText: l10n.searchCrops,
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16, bottom: 12),
                child: Consumer<MarketDataProvider>(
                  builder: (context, provider, _) => Row(
                    children: [
                      _buildFilterChip(
                        label: provider.selectedState.isEmpty ? l10n.allStates : provider.selectedState,
                        onTap: () => _showStatePicker(context, provider),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: provider.selectedDistrict.isEmpty ? l10n.allDistricts : provider.selectedDistrict,
                        onTap: () => _showDistrictPicker(context, provider),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Consumer<MarketDataProvider>(
        builder: (context, provider, _) {
          if (provider.status == MarketDataStatus.loading && provider.marketData.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.status == MarketDataStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('${l10n.error}: ${provider.errorMessage}'),
                  ElevatedButton(
                    onPressed: () => provider.loadData(forceRefresh: true),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadData(forceRefresh: true),
            child: provider.marketData.isEmpty
                ? Center(child: Text(l10n.noDataFound))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.marketData.length + (provider.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == provider.marketData.length) {
                        provider.loadMore();
                        return const Center(child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ));
                      }
                      final item = provider.marketData[index];
                      return _buildMarketCard(item, l10n);
                    },
                  ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip({required String label, required VoidCallback onTap}) {
    return ActionChip(
      onPressed: onTap,
      label: Text(label),
      backgroundColor: Colors.white,
      avatar: const Icon(Icons.arrow_drop_down, size: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildMarketCard(MarketData item, AppLocalizations l10n) {
    final trendColor = item.trend == 'up' ? Colors.green : (item.trend == 'down' ? Colors.red : Colors.blue);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: trendColor.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: trendColor.withOpacity(0.1),
                  child: Icon(Icons.agriculture, color: trendColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.commodity,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        '${item.market}, ${item.district}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: trendColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item.trend == 'up' ? Icons.trending_up : (item.trend == 'down' ? Icons.trending_down : Icons.trending_flat),
                        color: trendColor,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.trend.toUpperCase(),
                        style: TextStyle(color: trendColor, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPriceCol(l10n.minPrice, '₹${item.minPrice.toInt()}', Colors.grey),
                _buildPriceCol(l10n.modalPrice, '₹${item.modalPrice.toInt()}', Colors.green[700]!),
                _buildPriceCol(l10n.maxPrice, '₹${item.maxPrice.toInt()}', Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCol(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: color)),
      ],
    );
  }

  void _showStatePicker(BuildContext context, MarketDataProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        children: provider.states.map((s) => ListTile(
          title: Text(s),
          onTap: () {
            provider.setFilters(state: s);
            Navigator.pop(context);
          },
        )).toList(),
      ),
    );
  }

  void _showDistrictPicker(BuildContext context, MarketDataProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        children: provider.districts.map((d) => ListTile(
          title: Text(d),
          onTap: () {
            provider.setFilters(district: d);
            Navigator.pop(context);
          },
        )).toList(),
      ),
    );
  }
}
