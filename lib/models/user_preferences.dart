/// User preferences model for personalization
class UserPreferences {
  // Farm details
  final double? landArea;
  final String? landUnit; // 'acres' or 'hectares'
  final String? farmLocation;
  final List<String> selectedCrops;
  
  // App preferences
  final String theme; // 'light', 'dark', or 'system'
  final String language;
  final String countryCode;
  
  // Measurement preferences
  final String temperatureUnit; // 'celsius' or 'fahrenheit'
  final String distanceUnit; // 'km' or 'miles'
  
  // Notification preferences
  final bool weatherAlerts;
  final bool cropHealthAlerts;
  final bool marketPriceAlerts;
  
  // Onboarding status
  final bool onboardingCompleted;

  UserPreferences({
    this.landArea,
    this.landUnit = 'acres',
    this.farmLocation,
    this.selectedCrops = const [],
    this.theme = 'system',
    this.language = 'en',
    this.countryCode = 'US',
    this.temperatureUnit = 'celsius',
    this.distanceUnit = 'km',
    this.weatherAlerts = true,
    this.cropHealthAlerts = true,
    this.marketPriceAlerts = true,
    this.onboardingCompleted = false,
  });

  // Convert to JSON for SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'landArea': landArea,
      'landUnit': landUnit,
      'farmLocation': farmLocation,
      'selectedCrops': selectedCrops,
      'theme': theme,
      'language': language,
      'countryCode': countryCode,
      'temperatureUnit': temperatureUnit,
      'distanceUnit': distanceUnit,
      'weatherAlerts': weatherAlerts,
      'cropHealthAlerts': cropHealthAlerts,
      'marketPriceAlerts': marketPriceAlerts,
      'onboardingCompleted': onboardingCompleted,
    };
  }

  // Create from JSON
  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      landArea: json['landArea']?.toDouble(),
      landUnit: json['landUnit'] ?? 'acres',
      farmLocation: json['farmLocation'],
      selectedCrops: json['selectedCrops'] != null
          ? List<String>.from(json['selectedCrops'])
          : [],
      theme: json['theme'] ?? 'system',
      language: json['language'] ?? 'en',
      countryCode: json['countryCode'] ?? 'US',
      temperatureUnit: json['temperatureUnit'] ?? 'celsius',
      distanceUnit: json['distanceUnit'] ?? 'km',
      weatherAlerts: json['weatherAlerts'] ?? true,
      cropHealthAlerts: json['cropHealthAlerts'] ?? true,
      marketPriceAlerts: json['marketPriceAlerts'] ?? true,
      onboardingCompleted: json['onboardingCompleted'] ?? false,
    );
  }

  // Create a copy with modifications
  UserPreferences copyWith({
    double? landArea,
    String? landUnit,
    String? farmLocation,
    List<String>? selectedCrops,
    String? theme,
    String? language,
    String? countryCode,
    String? temperatureUnit,
    String? distanceUnit,
    bool? weatherAlerts,
    bool? cropHealthAlerts,
    bool? marketPriceAlerts,
    bool? onboardingCompleted,
  }) {
    return UserPreferences(
      landArea: landArea ?? this.landArea,
      landUnit: landUnit ?? this.landUnit,
      farmLocation: farmLocation ?? this.farmLocation,
      selectedCrops: selectedCrops ?? this.selectedCrops,
      theme: theme ?? this.theme,
      language: language ?? this.language,
      countryCode: countryCode ?? this.countryCode,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      weatherAlerts: weatherAlerts ?? this.weatherAlerts,
      cropHealthAlerts: cropHealthAlerts ?? this.cropHealthAlerts,
      marketPriceAlerts: marketPriceAlerts ?? this.marketPriceAlerts,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }
}
