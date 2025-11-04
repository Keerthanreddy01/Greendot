import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_preferences.dart';

/// Provider for managing user preferences with persistence
class PreferencesProvider extends ChangeNotifier {
  static const String _prefsKey = 'user_preferences';
  
  UserPreferences _preferences = UserPreferences();
  bool _isLoading = true;

  UserPreferences get preferences => _preferences;
  bool get isLoading => _isLoading;
  bool get hasCompletedOnboarding => _preferences.onboardingCompleted;
  
  ThemeMode get themeMode {
    switch (_preferences.theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  PreferencesProvider() {
    _loadPreferences();
  }

  /// Load preferences from SharedPreferences
  Future<void> _loadPreferences() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final prefs = await SharedPreferences.getInstance();
      final prefsJson = prefs.getString(_prefsKey);
      
      if (prefsJson != null) {
        final Map<String, dynamic> decoded = jsonDecode(prefsJson);
        _preferences = UserPreferences.fromJson(decoded);
      }
    } catch (e) {
      debugPrint('Error loading preferences: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Save preferences to SharedPreferences
  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final prefsJson = jsonEncode(_preferences.toJson());
      await prefs.setString(_prefsKey, prefsJson);
    } catch (e) {
      debugPrint('Error saving preferences: $e');
    }
  }

  /// Update farm details
  Future<void> updateFarmDetails({
    double? landArea,
    String? landUnit,
    String? farmLocation,
  }) async {
    _preferences = _preferences.copyWith(
      landArea: landArea,
      landUnit: landUnit,
      farmLocation: farmLocation,
    );
    notifyListeners();
    await _savePreferences();
  }

  /// Update selected crops
  Future<void> updateSelectedCrops(List<String> crops) async {
    _preferences = _preferences.copyWith(selectedCrops: crops);
    notifyListeners();
    await _savePreferences();
  }

  /// Update theme
  Future<void> updateTheme(String theme) async {
    _preferences = _preferences.copyWith(theme: theme);
    notifyListeners();
    await _savePreferences();
  }

  /// Update language
  Future<void> updateLanguage(String language, String countryCode) async {
    _preferences = _preferences.copyWith(
      language: language,
      countryCode: countryCode,
    );
    notifyListeners();
    await _savePreferences();
  }

  /// Update measurement units
  Future<void> updateMeasurementUnits({
    String? temperatureUnit,
    String? distanceUnit,
  }) async {
    _preferences = _preferences.copyWith(
      temperatureUnit: temperatureUnit,
      distanceUnit: distanceUnit,
    );
    notifyListeners();
    await _savePreferences();
  }

  /// Update notification preferences
  Future<void> updateNotificationPreferences({
    bool? weatherAlerts,
    bool? cropHealthAlerts,
    bool? marketPriceAlerts,
  }) async {
    _preferences = _preferences.copyWith(
      weatherAlerts: weatherAlerts,
      cropHealthAlerts: cropHealthAlerts,
      marketPriceAlerts: marketPriceAlerts,
    );
    notifyListeners();
    await _savePreferences();
  }

  /// Mark onboarding as completed
  Future<void> completeOnboarding() async {
    _preferences = _preferences.copyWith(onboardingCompleted: true);
    notifyListeners();
    await _savePreferences();
  }

  /// Reset all preferences (for testing/logout)
  Future<void> resetPreferences() async {
    _preferences = UserPreferences();
    notifyListeners();
    await _savePreferences();
  }
}
