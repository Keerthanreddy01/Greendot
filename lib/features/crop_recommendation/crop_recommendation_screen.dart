import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../models/crop_recommendation_model.dart';
import '../../services/crop_recommendation_service.dart';

class CropRecommendationScreen extends StatefulWidget {
  const CropRecommendationScreen({super.key});

  @override
  State<CropRecommendationScreen> createState() => _CropRecommendationScreenState();
}

class _CropRecommendationScreenState extends State<CropRecommendationScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _service = CropRecommendationService();

  // Controllers
  final _nitrogenController = TextEditingController();
  final _phosphorusController = TextEditingController();
  final _potassiumController = TextEditingController();
  final _phController = TextEditingController();
  final _rainfallController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _humidityController = TextEditingController();

  String _selectedSoilType = 'loam';
  bool _isLoading = false;
  List<CropRecommendation>? _recommendations;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _nitrogenController.dispose();
    _phosphorusController.dispose();
    _potassiumController.dispose();
    _phController.dispose();
    _rainfallController.dispose();
    _temperatureController.dispose();
    _humidityController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _getCropRecommendations() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _recommendations = null;
    });

    final soilData = SoilData(
      soilType: _selectedSoilType,
      nitrogen: double.parse(_nitrogenController.text),
      phosphorus: double.parse(_phosphorusController.text),
      potassium: double.parse(_potassiumController.text),
      ph: double.parse(_phController.text),
      moisture: 60.0,
      temperature: double.parse(_temperatureController.text),
      humidity: double.parse(_humidityController.text),
      rainfall: double.parse(_rainfallController.text),
    );

    try {
      final recommendations = await _service.recommendCrops(soilData);
      setState(() {
        _recommendations = recommendations;
        _isLoading = false;
      });
      _animationController.forward(from: 0);
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Recommendation'),
        elevation: 0,
        backgroundColor: Colors.green.shade700,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade700,
              Colors.green.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: _recommendations == null
              ? _buildInputForm(size)
              : _buildResultsScreen(size),
        ),
      ),
    );
  }

  Widget _buildInputForm(Size size) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Animation
            SizedBox(
              height: size.height * 0.15,
              child: Lottie.asset(
                'assets/animations/farming.json',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.agriculture, size: 80, color: Colors.white);
                },
              ),
            ),
            const SizedBox(height: 16),
            
            Text(
              'Tell us about your soil',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Get AI-powered crop recommendations based on your soil conditions',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Form Card
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Soil Type Dropdown
                    _buildSectionTitle('Soil Type'),
                    DropdownButtonFormField<String>(
                      value: _selectedSoilType,
                      decoration: _inputDecoration('Select soil type', Icons.terrain),
                      items: ['sandy', 'loam', 'clay', 'black', 'red']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => _selectedSoilType = value!),
                    ),
                    const SizedBox(height: 20),

                    // NPK Values
                    _buildSectionTitle('NPK Values (kg/ha)'),
                    Row(
                      children: [
                        Expanded(child: _buildNumberField(_nitrogenController, 'N', Icons.science)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildNumberField(_phosphorusController, 'P', Icons.science_outlined)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildNumberField(_potassiumController, 'K', Icons.biotech)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // pH Level
                    _buildSectionTitle('pH Level'),
                    _buildNumberField(_phController, 'pH (0-14)', Icons.water_drop),
                    const SizedBox(height: 20),

                    // Weather & Climate
                    _buildSectionTitle('Climate Conditions'),
                    Row(
                      children: [
                        Expanded(
                          child: _buildNumberField(
                            _temperatureController,
                            'Temp (°C)',
                            Icons.thermostat,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildNumberField(
                            _humidityController,
                            'Humidity (%)',
                            Icons.water,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildNumberField(_rainfallController, 'Rainfall (mm)', Icons.cloud),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _getCropRecommendations,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_awesome),
                          SizedBox(width: 8),
                          Text(
                            'Get Recommendations',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsScreen(Size size) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.shade700,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Recommended Crops',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_recommendations!.length} crops suitable for your soil',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Results List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _recommendations!.length,
              itemBuilder: (context, index) {
                final crop = _recommendations![index];
                return _buildCropCard(crop, index);
              },
            ),
          ),

          // Try Again Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() => _recommendations = null);
                _animationController.reverse();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Different Values'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCropCard(CropRecommendation crop, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 100)),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () => _showCropDetails(crop),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Crop Icon
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getCropIcon(crop.cropName),
                        color: Colors.green.shade700,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Crop Name & Season
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            crop.cropName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Text(
                                crop.season,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Suitability Score
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getScoreColor(crop.suitabilityScore),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${crop.suitabilityScore}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Quick Info
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _buildInfoChip(Icons.timer, '${crop.growthDuration} days', Colors.blue),
                    _buildInfoChip(Icons.trending_up, '${crop.expectedYield} tons/acre', Colors.orange),
                    _buildInfoChip(Icons.water_drop, crop.waterRequirement, Colors.cyan),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // View Details Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _showCropDetails(crop),
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('View Details'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.shade800,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showCropDetails(CropRecommendation crop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Crop Name
              Text(
                crop.cropName,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Advantages
              _buildDetailSection(
                'Key Advantages',
                Icons.thumb_up,
                Colors.green,
                crop.advantages,
              ),
              
              // Requirements
              _buildDetailSection(
                'Growing Requirements',
                Icons.checklist,
                Colors.orange,
                crop.requirements,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, IconData icon, Color color, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, size: 16, color: color.shade300),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ),
                ],
              ),
            )),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildNumberField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: _inputDecoration(label, icon),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        if (double.tryParse(value) == null) {
          return 'Invalid';
        }
        return null;
      },
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.green.shade700),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.green.shade700, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green.shade600;
    if (score >= 60) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  IconData _getCropIcon(String cropName) {
    final Map<String, IconData> icons = {
      'rice': Icons.rice_bowl,
      'wheat': Icons.grain,
      'tomato': Icons.local_florist,
      'potato': Icons.spa,
      'cotton': Icons.cloud,
      'sugarcane': Icons.grass,
      'maize': Icons.eco,
      'soybean': Icons.energy_savings_leaf,
    };
    return icons[cropName.toLowerCase()] ?? Icons.agriculture;
  }
}
