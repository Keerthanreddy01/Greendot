import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/preferences_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _landController = TextEditingController();
  String _selectedUnit = 'Acres';
  String _selectedTheme = 'System';
  final Set<String> _selectedCrops = {};

  final List<Map<String, String>> _crops = [
    {'name': 'Rice', 'icon': '🌾'},
    {'name': 'Wheat', 'icon': '🌾'},
    {'name': 'Maize', 'icon': '🌽'},
    {'name': 'Cotton', 'icon': '🌱'},
    {'name': 'Vegetables', 'icon': '🥬'},
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentSettings();
  }

  void _loadCurrentSettings() {
    final prefs = Provider.of<PreferencesProvider>(context, listen: false);
    setState(() {
      _landController.text = prefs.preferences.landArea?.toString() ?? '';
      _selectedUnit = prefs.preferences.landUnit == 'acres' ? 'Acres' : 'Hectares';
      _selectedTheme = prefs.preferences.theme.isEmpty ? 'System' : 
                       prefs.preferences.theme[0].toUpperCase() + prefs.preferences.theme.substring(1);
      _selectedCrops.addAll(prefs.preferences.selectedCrops);
    });
  }

  void _saveSettings() {
    final prefsProvider = Provider.of<PreferencesProvider>(context, listen: false);
    
    // Save farm details
    if (_landController.text.isNotEmpty) {
      final landSize = double.tryParse(_landController.text);
      if (landSize != null) {
        prefsProvider.updateFarmDetails(
          landArea: landSize,
          landUnit: _selectedUnit.toLowerCase(),
          farmLocation: prefsProvider.preferences.farmLocation,
        );
      }
    }
    
    // Save crops
    if (_selectedCrops.isNotEmpty) {
      prefsProvider.updateSelectedCrops(_selectedCrops.toList());
    }
    
    // Save theme
    prefsProvider.updateTheme(_selectedTheme.toLowerCase());
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved successfully! ✅'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          TextButton.icon(
            onPressed: _saveSettings,
            icon: const Icon(Icons.save, color: Colors.white),
            label: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Farm Size
            Text(
              'Farm Details',
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
            const SizedBox(height: 32),

            // Crops
            Text(
              'Your Crops',
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
            const SizedBox(height: 32),

            // Theme
            Text(
              'Appearance',
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
            const SizedBox(height: 40),

            // Reset button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Reset Settings?'),
                      content: const Text('This will clear all your preferences and show the onboarding again.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Provider.of<PreferencesProvider>(context, listen: false)
                                .resetPreferences();
                            Navigator.pop(context);
                            Navigator.of(context).pushNamedAndRemoveUntil('/onboarding', (route) => false);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reset All Settings'),
              ),
            ),
          ],
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
