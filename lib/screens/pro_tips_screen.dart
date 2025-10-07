import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';

class ProTipsScreen extends StatefulWidget {
  const ProTipsScreen({Key? key}) : super(key: key);

  @override
  State<ProTipsScreen> createState() => _ProTipsScreenState();
}

class _ProTipsScreenState extends State<ProTipsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pro Tips'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Today Tips'),
            Tab(text: 'Seasonal Advice'),
            Tab(text: 'Crop Care'),
            Tab(text: 'Pest Control'),
            Tab(text: 'Soil Health'),
            Tab(text: 'Irrigation'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTodayTips(),
          _buildSeasonalAdvice(),
          _buildCropCare(),
          _buildPestControl(),
          _buildSoilHealth(),
          _buildIrrigation(),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 2),
    );
  }

  Widget _buildTodayTips() {
    final tips = [
      {
        'title': 'Morning Watering',
        'description': 'Water your plants early morning (6-8 AM) for better absorption and to prevent fungal diseases.',
        'icon': Icons.water_drop,
        'color': Colors.blue,
        'difficulty': 'Easy',
      },
      {
        'title': 'Leaf Inspection',
        'description': 'Check leaves daily for discoloration, spots, or pest damage. Early detection prevents spread.',
        'icon': Icons.search,
        'color': Colors.green,
        'difficulty': 'Easy',
      },
      {
        'title': 'Soil Moisture Check',
        'description': 'Insert finger 2 inches into soil. If dry, water deeply. Avoid overwatering.',
        'icon': Icons.landscape,
        'color': Colors.brown,
        'difficulty': 'Medium',
      },
    ];

    return _buildTipsList(tips);
  }

  Widget _buildSeasonalAdvice() {
    final tips = [
      {
        'title': 'Winter Protection',
        'description': 'Cover sensitive plants during cold nights. Use frost cloth or mulch around root zones.',
        'icon': Icons.ac_unit,
        'color': Colors.lightBlue,
        'difficulty': 'Medium',
      },
      {
        'title': 'Summer Care',
        'description': 'Increase watering frequency and provide shade for delicate plants during hot afternoons.',
        'icon': Icons.wb_sunny,
        'color': Colors.orange,
        'difficulty': 'Easy',
      },
      {
        'title': 'Monsoon Preparation',
        'description': 'Ensure proper drainage and stake tall plants to prevent wind damage.',
        'icon': Icons.umbrella,
        'color': Colors.indigo,
        'difficulty': 'Hard',
      },
    ];

    return _buildTipsList(tips);
  }

  Widget _buildCropCare() {
    final tips = [
      {
        'title': 'Tomato Pruning',
        'description': 'Remove suckers (shoots between main stem and branches) to focus energy on fruit production.',
        'icon': Icons.content_cut,
        'color': Colors.red,
        'difficulty': 'Medium',
      },
      {
        'title': 'Companion Planting',
        'description': 'Plant basil near tomatoes to repel pests and improve flavor. Marigolds deter harmful insects.',
        'icon': Icons.group,
        'color': Colors.yellow,
        'difficulty': 'Easy',
      },
      {
        'title': 'Harvest Timing',
        'description': 'Pick vegetables when they reach optimal size and color. Harvesting encourages more production.',
        'icon': Icons.agriculture,
        'color': Colors.green,
        'difficulty': 'Medium',
      },
    ];

    return _buildTipsList(tips);
  }

  Widget _buildPestControl() {
    final tips = [
      {
        'title': 'Natural Pest Spray',
        'description': 'Mix neem oil with water (1:10 ratio) and spray in evening to control aphids and mites.',
        'icon': Icons.spa,
        'color': Colors.green,
        'difficulty': 'Easy',
      },
      {
        'title': 'Beneficial Insects',
        'description': 'Attract ladybugs and lacewings by planting dill, fennel, and yarrow near your crops.',
        'icon': Icons.bug_report,
        'color': Colors.red,
        'difficulty': 'Medium',
      },
      {
        'title': 'Physical Barriers',
        'description': 'Use row covers or copper tape around plants to prevent slug and snail damage.',
        'icon': Icons.shield,
        'color': Colors.grey,
        'difficulty': 'Easy',
      },
    ];

    return _buildTipsList(tips);
  }

  Widget _buildSoilHealth() {
    final tips = [
      {
        'title': 'Compost Addition',
        'description': 'Add compost monthly to improve soil structure, nutrition, and water retention.',
        'icon': Icons.recycling,
        'color': Colors.brown,
        'difficulty': 'Easy',
      },
      {
        'title': 'pH Testing',
        'description': 'Test soil pH every 6 months. Most vegetables prefer slightly acidic to neutral soil (6.0-7.0).',
        'icon': Icons.science,
        'color': Colors.purple,
        'difficulty': 'Medium',
      },
      {
        'title': 'Mulching',
        'description': 'Apply 2-3 inch layer of organic mulch to retain moisture and suppress weeds.',
        'icon': Icons.layers,
        'color': Colors.amber,
        'difficulty': 'Easy',
      },
    ];

    return _buildTipsList(tips);
  }

  Widget _buildIrrigation() {
    final tips = [
      {
        'title': 'Drip Irrigation',
        'description': 'Install drip irrigation for water efficiency. Delivers water directly to root zones.',
        'icon': Icons.opacity,
        'color': Colors.blue,
        'difficulty': 'Hard',
      },
      {
        'title': 'Watering Schedule',
        'description': 'Water deeply but less frequently to encourage deep root growth and drought tolerance.',
        'icon': Icons.schedule,
        'color': Colors.teal,
        'difficulty': 'Medium',
      },
      {
        'title': 'Rainwater Collection',
        'description': 'Set up rain barrels to collect and store rainwater for sustainable irrigation.',
        'icon': Icons.water,
        'color': Colors.lightBlue,
        'difficulty': 'Medium',
      },
    ];

    return _buildTipsList(tips);
  }

  Widget _buildTipsList(List<Map<String, dynamic>> tips) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tips.length,
      itemBuilder: (context, index) {
        final tip = tips[index];
        return _buildTipCard(tip);
      },
    );
  }

  Widget _buildTipCard(Map<String, dynamic> tip) {
    Color difficultyColor;
    switch (tip['difficulty']) {
      case 'Easy':
        difficultyColor = Colors.green;
        break;
      case 'Medium':
        difficultyColor = Colors.orange;
        break;
      case 'Hard':
        difficultyColor = Colors.red;
        break;
      default:
        difficultyColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: tip['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  tip['icon'],
                  color: tip['color'],
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tip['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: difficultyColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tip['difficulty'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: difficultyColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            tip['description'],
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Save Tip',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.share,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Share',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
