import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/preferences_provider.dart';
import 'onboarding_completion_screen.dart';

/// Theme selection screen - Fourth screen in onboarding
class OnboardingThemeSelectionScreen extends StatefulWidget {
  const OnboardingThemeSelectionScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingThemeSelectionScreen> createState() => _OnboardingThemeSelectionScreenState();
}

class _OnboardingThemeSelectionScreenState extends State<OnboardingThemeSelectionScreen> {
  String _selectedTheme = 'system';
  String _selectedTemperatureUnit = 'celsius';
  bool _weatherAlerts = true;
  bool _cropHealthAlerts = true;
  bool _marketPriceAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2E7D32)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Preferences',
          style: TextStyle(color: Color(0xFF2E7D32)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress indicator
              _buildProgressIndicator(step: 3, totalSteps: 4),
              
              const SizedBox(height: 32),
              
              // Title
              const Text(
                'Customize your app',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              
              const SizedBox(height: 8),
              
              const Text(
                'Choose your preferred theme and settings',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Theme selection
              _buildSectionTitle('App Theme'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildThemeCard(
                      theme: 'light',
                      icon: Icons.wb_sunny,
                      label: 'Light',
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFFFFF), Color(0xFFF5F5F5)],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildThemeCard(
                      theme: 'dark',
                      icon: Icons.nightlight_round,
                      label: 'Dark',
                      gradient: const LinearGradient(
                        colors: [Color(0xFF263238), Color(0xFF37474F)],
                      ),
                      iconColor: Colors.white,
                      textColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildThemeCard(
                      theme: 'system',
                      icon: Icons.brightness_auto,
                      label: 'Auto',
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF4CAF50).withOpacity(0.1),
                          const Color(0xFF2E7D32).withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Temperature unit
              _buildSectionTitle('Temperature Unit'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildUnitCard(
                      unit: 'celsius',
                      label: 'Celsius (°C)',
                      icon: Icons.thermostat,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildUnitCard(
                      unit: 'fahrenheit',
                      label: 'Fahrenheit (°F)',
                      icon: Icons.thermostat,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Notification preferences
              _buildSectionTitle('Notifications'),
              const SizedBox(height: 12),
              _buildNotificationToggle(
                title: 'Weather Alerts',
                subtitle: 'Get notified about weather changes',
                icon: Icons.wb_cloudy,
                value: _weatherAlerts,
                onChanged: (value) {
                  setState(() {
                    _weatherAlerts = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              _buildNotificationToggle(
                title: 'Crop Health Updates',
                subtitle: 'Disease detection and care tips',
                icon: Icons.health_and_safety,
                value: _cropHealthAlerts,
                onChanged: (value) {
                  setState(() {
                    _cropHealthAlerts = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              _buildNotificationToggle(
                title: 'Market Price Alerts',
                subtitle: 'Track crop prices in your area',
                icon: Icons.trending_up,
                value: _marketPriceAlerts,
                onChanged: (value) {
                  setState(() {
                    _marketPriceAlerts = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _continue,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator({required int step, required int totalSteps}) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isActive = index < step;
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: index < totalSteps - 1 ? 8 : 0),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF4CAF50) : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2E7D32),
      ),
    );
  }

  Widget _buildThemeCard({
    required String theme,
    required IconData icon,
    required String label,
    required Gradient gradient,
    Color? iconColor,
    Color? textColor,
  }) {
    final isSelected = _selectedTheme == theme;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTheme = theme;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade200,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: iconColor ?? const Color(0xFF4CAF50),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor ?? const Color(0xFF2E7D32),
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              const Icon(
                Icons.check_circle,
                color: Color(0xFF4CAF50),
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUnitCard({
    required String unit,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _selectedTemperatureUnit == unit;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTemperatureUnit = unit;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4CAF50) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF4CAF50),
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF2E7D32),
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationToggle({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF4CAF50),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF4CAF50),
          ),
        ],
      ),
    );
  }

  void _continue() async {
    final prefsProvider = Provider.of<PreferencesProvider>(context, listen: false);
    
    await prefsProvider.updateTheme(_selectedTheme);
    await prefsProvider.updateMeasurementUnits(temperatureUnit: _selectedTemperatureUnit);
    await prefsProvider.updateNotificationPreferences(
      weatherAlerts: _weatherAlerts,
      cropHealthAlerts: _cropHealthAlerts,
      marketPriceAlerts: _marketPriceAlerts,
    );

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OnboardingCompletionScreen(),
      ),
    );
  }
}
