class IrrigationSchedule {
  final String id;
  final DateTime scheduledTime;
  final int duration; // in minutes
  final String zone;
  final double soilMoisture;
  final double weatherForecast;
  final bool isAutomatic;
  final String status; // pending, active, completed, cancelled

  IrrigationSchedule({
    required this.id,
    required this.scheduledTime,
    required this.duration,
    required this.zone,
    required this.soilMoisture,
    required this.weatherForecast,
    required this.isAutomatic,
    required this.status,
  });

  factory IrrigationSchedule.fromJson(Map<String, dynamic> json) {
    return IrrigationSchedule(
      id: json['id'] ?? '',
      scheduledTime: DateTime.parse(json['scheduledTime']),
      duration: json['duration'] ?? 0,
      zone: json['zone'] ?? '',
      soilMoisture: (json['soilMoisture'] ?? 0.0).toDouble(),
      weatherForecast: (json['weatherForecast'] ?? 0.0).toDouble(),
      isAutomatic: json['isAutomatic'] ?? false,
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scheduledTime': scheduledTime.toIso8601String(),
      'duration': duration,
      'zone': zone,
      'soilMoisture': soilMoisture,
      'weatherForecast': weatherForecast,
      'isAutomatic': isAutomatic,
      'status': status,
    };
  }
}

class SoilMoistureData {
  final String sensorId;
  final double moisture;
  final DateTime timestamp;
  final String zone;

  SoilMoistureData({
    required this.sensorId,
    required this.moisture,
    required this.timestamp,
    required this.zone,
  });

  factory SoilMoistureData.fromJson(Map<String, dynamic> json) {
    return SoilMoistureData(
      sensorId: json['sensorId'] ?? '',
      moisture: (json['moisture'] ?? 0.0).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
      zone: json['zone'] ?? '',
    );
  }
}
