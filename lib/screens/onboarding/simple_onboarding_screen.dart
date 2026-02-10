import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/preferences_provider.dart';
import '../../localization/app_localizations.dart';

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

  // Dynamic list of common crops based on context
  List<Map<String, String>> _getCrops(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      {'id': 'Rice', 'name': l10n.rice, 'icon': '🌾'},
      {'id': 'Wheat', 'name': l10n.wheat, 'icon': '🌾'},
      {'id': 'Maize', 'name': l10n.maize, 'icon': '🌽'},
      {'id': 'Cotton', 'name': l10n.cotton, 'icon': '🌱'},
      {'id': 'Vegetables', 'name': l10n.vegetables, 'icon': '🥬'},
    ];
  }

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
    final l10n = AppLocalizations.of(context);
    final crops = _getCrops(context);
    
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
                l10n.setupFarm,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.setupFarmSubtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),

              // Farm Size Section
              Text(
                l10n.farmSize,
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
                        labelText: l10n.size,
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
                      items: [l10n.acres, l10n.hectares].map((unit) {
                        return DropdownMenuItem(
                          value: unit == l10n.acres ? 'Acres' : 'Hectares',
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
                l10n.whatDoYouGrow,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: crops.map((crop) {
                  final isSelected = _selectedCrops.contains(crop['id']);
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
                          _selectedCrops.add(crop['id']!);
                        } else {
                          _selectedCrops.remove(crop['id']);
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
                l10n.chooseTheme,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  {'val': 'Light', 'label': l10n.light, 'icon': Icons.light_mode},
                  {'val': 'Dark', 'label': l10n.dark, 'icon': Icons.dark_mode},
                  {'val': 'System', 'label': l10n.system, 'icon': Icons.brightness_auto},
                ].map((theme) {
                  final isSelected = _selectedTheme == theme['val'];
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          theme['icon'] as IconData,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(theme['label'] as String),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedTheme = theme['val'] as String;
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
                  child: Text(
                    l10n.startFarming,
                    style: const TextStyle(
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
                    l10n.skipForNow,
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
