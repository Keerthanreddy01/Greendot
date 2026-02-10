import 'package:flutter/material.dart';
import '../models/market_data_model.dart';
import '../services/kaggle_market_service.dart';

enum MarketDataStatus { initial, loading, loaded, error }

class MarketDataProvider extends ChangeNotifier {
  final KaggleMarketService _service = KaggleMarketService();
  
  List<MarketData> _allData = [];
  List<MarketData> _filteredData = [];
  MarketDataStatus _status = MarketDataStatus.initial;
  String _errorMessage = '';
  
  // Filters
  String _selectedState = '';
  String _selectedDistrict = '';
  String _searchQuery = '';
  
  String get selectedState => _selectedState;
  String get selectedDistrict => _selectedDistrict;
  String get searchQuery => _searchQuery;
  
  // Pagination
  int _currentPage = 1;
  static const int _pageSize = 20;

  List<MarketData> get marketData => _filteredData.take(_currentPage * _pageSize).toList();
  MarketDataStatus get status => _status;
  String get errorMessage => _errorMessage;
  bool get hasMore => _filteredData.length > (_currentPage * _pageSize);
  
  // Filter Metadata
  List<String> get states => _allData.map((e) => e.state).toSet().toList()..sort();
  List<String> get districts => _allData
      .where((e) => _selectedState.isEmpty || e.state == _selectedState)
      .map((e) => e.district)
      .toSet()
      .toList()
      ..sort();

  MarketDataProvider() {
    loadData();
  }

  Future<void> loadData({bool forceRefresh = false}) async {
    _status = MarketDataStatus.loading;
    notifyListeners();

    try {
      _allData = await _service.fetchMarketData(forceRefresh: forceRefresh);
      _applyFilters();
      _status = MarketDataStatus.loaded;
    } catch (e) {
      _status = MarketDataStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  void setFilters({String? state, String? district, String? query}) {
    if (state != null) _selectedState = state;
    if (district != null) _selectedDistrict = district;
    if (query != null) _searchQuery = query;
    
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredData = _service.filterData(
      _allData,
      state: _selectedState,
      district: _selectedDistrict,
      commodity: _searchQuery,
    );
    _currentPage = 1; // Reset pagination
  }

  void loadMore() {
    if (hasMore) {
      _currentPage++;
      notifyListeners();
    }
  }

  void resetFilters() {
    _selectedState = '';
    _selectedDistrict = '';
    _searchQuery = '';
    _applyFilters();
    notifyListeners();
  }
}
