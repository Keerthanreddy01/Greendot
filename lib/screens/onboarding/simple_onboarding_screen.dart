import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/preferences_provider.dart';

class SimpleOnboardingScreen extends StatefulWidget {
  const SimpleOnboardingScreen({super.key});

  @override
  State<SimpleOnboardingScreen> createState() => _SimpleOnboardingScreenState();
}

class _SimpleOnboardingScreenState extends State<SimpleOnboardingScreen> {
  final _landController = TextEditingController();
  String _selectedUnit = 'Acres';
  String _selectedTheme = 'System';
  final Set<String> _selectedCrops = {};

  // Simple list of common crops
  final List<Map<String, String>> _crops = [
    {'name': 'Rice', 'icon': '🌾'},
    {'name': 'Wheat', 'icon': '🌾'},
    {'name': 'Maize', 'icon': '🌽'},
    {'name': 'Cotton', 'icon': '🌱'},
    {'name': 'Vegetables', 'icon': '🥬'},
  ];

  void _completeOnboarding() {
    final prefsProvider = Provider.of<PreferencesProvider>(context, listen: false);
    
    // Save farm details
    if (_landController.text.isNotEmpty) {
      final landSize = double.tryParse(_landController.text);
      if (landSize != null) {
        prefsProvider.updateFarmDetails(
          landArea: landSize,
          landUnit: _selectedUnit.toLowerCase(),
          farmLocation: '',
        );
      }
    }
    
    // Save crops
    if (_selectedCrops.isNotEmpty) {
      prefsProvider.updateSelectedCrops(_selectedCrops.toList());
    }
    
    // Save theme
    prefsProvider.updateTheme(_selectedTheme.toLowerCase());
    
    // Complete onboarding
    prefsProvider.completeOnboarding();
    
    // Navigate to home
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // Welcome Header
              Text(
                'Welcome to GreenDot! 🌱',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Let\'s set up your farm in just a minute',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),

              // Farm Size Section
              Text(
                '1. Your Farm Size',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _landController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Size',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedUnit,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      ),
                      items: ['Acres', 'Hectares'].map((unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedUnit = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Crops Section
              Text(
                '2. What do you grow?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _crops.map((crop) {
                  final isSelected = _selectedCrops.contains(crop['name']);
                  return FilterChip(
                    selected: isSelected,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(crop['icon']!),
                        const SizedBox(width: 8),
                        Text(crop['name']!),
                      ],
                    ),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedCrops.add(crop['name']!);
                        } else {
                          _selectedCrops.remove(crop['name']);
                        }
                      });
                    },
                    selectedColor: Theme.of(context).primaryColor.withOpacity(0.3),
                    checkmarkColor: Theme.of(context).primaryColor,
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),

              // Theme Section
              Text(
                '3. Choose Your Theme',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: ['Light', 'Dark', 'System'].map((theme) {
                  final isSelected = _selectedTheme == theme;
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          theme == 'Light' ? Icons.light_mode : 
                          theme == 'Dark' ? Icons.dark_mode : 
                          Icons.brightness_auto,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(theme),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedTheme = theme;
                        });
                      }
                    },
                    selectedColor: Theme.of(context).primaryColor.withOpacity(0.3),
                  );
                }).toList(),
              ),
              const SizedBox(height: 60),

              // Complete Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _completeOnboarding,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Start Farming 🚀',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                  child: TextButton(
                  onPressed: () {
                    Provider.of<PreferencesProvider>(context, listen: false)
                        .completeOnboarding();
                    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                  },
                  child: Text(
                    'Skip for now',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _landController.dispose();
    super.dispose();
  }
}
