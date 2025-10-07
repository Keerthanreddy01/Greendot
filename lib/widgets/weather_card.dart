import 'package:flutter/material.dart';

class WeatherCard extends StatefulWidget {
  const WeatherCard({Key? key}) : super(key: key);

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  // Mock weather data - in real app, this would come from weather API
  final Map<String, dynamic> _weatherData = {
    'temperature': 28,
    'condition': 'Partly Cloudy',
    'humidity': 65,
    'windSpeed': 12,
    'uvIndex': 6,
    'precipitation': 20,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF64B5F6),
            Color(0xFF2196F3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Today\'s Weather',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getCurrentLocation(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
              Icon(
                _weatherData['icon'],
                size: 40,
                color: Colors.white,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Temperature and condition
          Row(
            children: [
              Text(
                '${_weatherData['temperature']}°',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _weatherData['condition'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Feels like ${_weatherData['temperature'] + 2}°',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Weather details
          Row(
            children: [
              Expanded(
                child: _buildWeatherDetail(
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: '${_weatherData['humidity']}%',
                ),
              ),
              Expanded(
                child: _buildWeatherDetail(
                  icon: Icons.air,
                  label: 'Wind Speed',
                  value: '${_weatherData['windSpeed']} km/h',
                ),
              ),
              Expanded(
                child: _buildWeatherDetail(
                  icon: Icons.wb_sunny,
                  label: 'UV Index',
                  value: '${_weatherData['uvIndex']}/10',
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Farming advice based on weather
          _buildFarmingAdvice(),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.white70,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }

  Widget _buildFarmingAdvice() {
    String advice = _getFarmingAdvice();
    IconData adviceIcon = _getAdviceIcon();
    Color adviceColor = _getAdviceColor();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            adviceIcon,
            color: adviceColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              advice,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFarmingAdvice() {
    final temp = _weatherData['temperature'] as int;
    final humidity = _weatherData['humidity'] as int;
    final precipitation = _weatherData['precipitation'] as int;

    if (precipitation > 80) {
      return '🌧️ Heavy rain expected. Ensure proper drainage for crops.';
    } else if (precipitation > 40) {
      return '🌦️ Light rain expected. Good for watering schedule.';
    } else if (temp > 35) {
      return '🌡️ Very hot day. Increase watering and provide shade.';
    } else if (temp < 10) {
      return '❄️ Cold weather. Protect sensitive plants from frost.';
    } else if (humidity < 30) {
      return '💧 Low humidity. Monitor plants for water stress.';
    } else if (humidity > 80) {
      return '🍃 High humidity. Watch for fungal diseases.';
    } else {
      return '✅ Perfect weather for farming activities!';
    }
  }

  IconData _getAdviceIcon() {
    final precipitation = _weatherData['precipitation'] as int;
    final temp = _weatherData['temperature'] as int;

    if (precipitation > 40) return Icons.umbrella;
    if (temp > 35) return Icons.thermostat;
    if (temp < 10) return Icons.ac_unit;
    return Icons.check_circle;
  }

  Color _getAdviceColor() {
    final precipitation = _weatherData['precipitation'] as int;
    final temp = _weatherData['temperature'] as int;

    if (precipitation > 80 || temp > 35 || temp < 10) {
      return Colors.orange;
    }
    return Colors.lightGreen;
  }

  String _getCurrentLocation() {
    // Mock location - in real app, this would come from location service
    return 'Bangalore, Karnataka';
  }
}
