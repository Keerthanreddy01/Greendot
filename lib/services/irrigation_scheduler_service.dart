import '../models/irrigation_model.dart';

class IrrigationSchedulerService {
  static final IrrigationSchedulerService _instance = IrrigationSchedulerService._internal();
  factory IrrigationSchedulerService() => _instance;
  IrrigationSchedulerService._internal();

  Future<IrrigationSchedule> generateSchedule({
    required String cropName,
    required String cropStage,
    required String soilType,
    required double farmSize,
    String? location,
    String zone = 'Main Field',
  }) async {
    // Get weather forecast
    final weatherData = await _getWeatherForecast(location ?? 'Default');

    // Calculate water requirement based on crop and stage
    final waterRequirement = _calculateWaterRequirement(
      cropName,
      cropStage,
      soilType,
      farmSize,
    );

    // Generate schedule
    final schedule = _createSchedule(
      waterRequirement,
      weatherData,
      cropStage,
    );

    return IrrigationSchedule(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      scheduledTime: schedule['nextIrrigation'] as DateTime,
      duration: schedule['duration'] as int,
      zone: zone,
      status: 'pending',
      soilMoisture: schedule['currentMoisture'] as double,
      weatherForecast: schedule['forecastTemp'] as double,
      isAutomatic: true,
    );
  }

  double _calculateWaterRequirement(
    String cropName,
    String cropStage,
    String soilType,
    double farmSize,
  ) {
    // Base water requirement (liters per acre per day)
    Map<String, double> baseRequirement = {
      'rice': 1500,
      'wheat': 800,
      'tomato': 600,
      'potato': 700,
      'cotton': 1000,
      'sugarcane': 1800,
      'maize': 900,
      'soybean': 650,
    };

    // Stage multiplier
    Map<String, double> stageMultiplier = {
      'seedling': 0.6,
      'vegetative': 1.0,
      'flowering': 1.3,
      'fruiting': 1.2,
      'maturity': 0.8,
    };

    // Soil type factor
    Map<String, double> soilFactor = {
      'sandy': 1.2,
      'loam': 1.0,
      'clay': 0.9,
    };

    double base = baseRequirement[cropName.toLowerCase()] ?? 800;
    double stage = stageMultiplier[cropStage.toLowerCase()] ?? 1.0;
    double soil = soilFactor[soilType.toLowerCase()] ?? 1.0;

    return base * stage * soil * farmSize;
  }

  Map<String, dynamic> _createSchedule(
    double waterRequirement,
    Map<String, dynamic> weatherData,
    String cropStage,
  ) {
    DateTime nextIrrigation = DateTime.now();
    double currentMoisture = 60.0;
    int duration = (waterRequirement / 100).round(); // Simplified calculation

    // Adjust based on weather
    if (weatherData['rainfall'] > 10) {
      nextIrrigation = nextIrrigation.add(const Duration(days: 2));
      currentMoisture = 75.0;
    } else if (weatherData['temperature'] > 35) {
      nextIrrigation = DateTime.now();
      currentMoisture = 40.0;
      duration = (duration * 1.2).round();
    } else {
      nextIrrigation = nextIrrigation.add(const Duration(days: 1));
    }

    return {
      'nextIrrigation': nextIrrigation,
      'duration': duration,
      'currentMoisture': currentMoisture,
      'forecastTemp': weatherData['temperature'] as double,
    };
  }

  Future<Map<String, dynamic>> _getWeatherForecast(String location) async {
    try {
      // Simulated weather data - replace with actual API call
      // final response = await http.get(
      //   Uri.parse('$_baseUrl/forecast?q=$location&appid=$_apiKey'),
      // );

      // For now, return mock data
      return {
        'temperature': 28.0,
        'humidity': 65.0,
        'rainfall': 0.0,
        'description': 'Clear sky',
      };
    } catch (e) {
      print('Error fetching weather: $e');
      return {
        'temperature': 28.0,
        'humidity': 60.0,
        'rainfall': 0.0,
        'description': 'Weather data unavailable',
      };
    }
  }

  Future<List<SoilMoistureData>> getSoilMoistureHistory(int days) async {
    // Mock data - replace with actual IoT sensor data
    List<SoilMoistureData> data = [];
    for (int i = days; i >= 0; i--) {
      data.add(SoilMoistureData(
        sensorId: 'SENSOR_001',
        timestamp: DateTime.now().subtract(Duration(days: i)),
        moisture: 45.0 + (i % 20),
        zone: 'Field A',
      ));
    }
    return data;
  }

  List<String> getIrrigationMethods() {
    return [
      'Drip Irrigation',
      'Sprinkler',
      'Flood Irrigation',
      'Furrow Irrigation',
      'Center Pivot',
      'Manual/Bucket',
    ];
  }
}
