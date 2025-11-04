import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/preferences_provider.dart';
import 'onboarding_theme_selection_screen.dart';

/// Crop selection screen - Third screen in onboarding
class OnboardingCropSelectionScreen extends StatefulWidget {
  const OnboardingCropSelectionScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingCropSelectionScreen> createState() => _OnboardingCropSelectionScreenState();
}

class _OnboardingCropSelectionScreenState extends State<OnboardingCropSelectionScreen> {
  final Set<String> _selectedCrops = {};

  static const List<Map<String, dynamic>> availableCrops = [
    {'name': 'Rice', 'icon': '🌾', 'color': Color(0xFFFFB300)},
    {'name': 'Wheat', 'icon': '🌾', 'color': Color(0xFFF57C00)},
    {'name': 'Cotton', 'icon': '🌺', 'color': Color(0xFFE1F5FE)},
    {'name': 'Sugarcane', 'icon': '🎋', 'color': Color(0xFF81C784)},
    {'name': 'Maize', 'icon': '🌽', 'color': Color(0xFFFFD54F)},
    {'name': 'Soybean', 'icon': '🫘', 'color': Color(0xFF8D6E63)},
    {'name': 'Turmeric', 'icon': '🧡', 'color': Color(0xFFFF9800)},
    {'name': 'Chili', 'icon': '🌶️', 'color': Color(0xFFE53935)},
    {'name': 'Tomato', 'icon': '🍅', 'color': Color(0xFFEF5350)},
    {'name': 'Onion', 'icon': '🧅', 'color': Color(0xFFB39DDB)},
    {'name': 'Potato', 'icon': '🥔', 'color': Color(0xFFBCAAA4)},
    {'name': 'Groundnut', 'icon': '🥜', 'color': Color(0xFFD7CCC8)},
    {'name': 'Pulses', 'icon': '🫘', 'color': Color(0xFF9FA8DA)},
    {'name': 'Vegetables', 'icon': '🥬', 'color': Color(0xFF66BB6A)},
    {'name': 'Fruits', 'icon': '🍇', 'color': Color(0xFFAB47BC)},
    {'name': 'Others', 'icon': '🌱', 'color': Color(0xFF4CAF50)},
  ];

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
          'Select Crops',
          style: TextStyle(color: Color(0xFF2E7D32)),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress indicator
                  _buildProgressIndicator(step: 2, totalSteps: 4),
                  
                  const SizedBox(height: 32),
                  
                  // Title
                  const Text(
                    'What do you grow?',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'Select all crops you grow (${_selectedCrops.length} selected)',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
            
            // Crops grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: availableCrops.length,
                itemBuilder: (context, index) {
                  final crop = availableCrops[index];
                  final isSelected = _selectedCrops.contains(crop['name']);
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedCrops.remove(crop['name']);
                        } else {
                          _selectedCrops.add(crop['name'] as String);
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF4CAF50)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF4CAF50)
                              : Colors.grey.shade200,
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            crop['icon'] as String,
                            style: TextStyle(
                              fontSize: 40,
                              color: isSelected ? Colors.white : null,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            crop['name'] as String,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF2E7D32),
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(height: 4),
                            const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _selectedCrops.isNotEmpty ? _continue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                elevation: _selectedCrops.isNotEmpty ? 4 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _selectedCrops.isEmpty ? 'Select at least 1 crop' : 'Continue',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_selectedCrops.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward),
                  ],
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

  void _continue() async {
    final prefsProvider = Provider.of<PreferencesProvider>(context, listen: false);
    await prefsProvider.updateSelectedCrops(_selectedCrops.toList());

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OnboardingThemeSelectionScreen(),
      ),
    );
  }
}
