import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/bottom_navigation.dart';
import '../services/voice_assistant_service.dart';
import '../services/firebase_service.dart';
import '../localization/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> _todayTasks = [];
  List<Map<String, dynamic>> _overdueTasks = [];
  List<Map<String, dynamic>> _notifications = [];
  List<Map<String, dynamic>> _plantHealth = [];
  List<Map<String, dynamic>> _marketPrices = [];
  bool _isLoading = false;
  bool _showTasks = false; // Start collapsed
  String _userName = 'Farmer'; // Default name

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadData();
    _initializeVoiceAssistant();
  }

  void _initializeVoiceAssistant() async {
    await VoiceAssistantService.initialize();
  }

  Future<void> _loadUserData() async {
    final user = _firebaseService.currentUser;
    if (user != null) {
      setState(() {
        // Get name from display name or email
        _userName = user.displayName ?? user.email?.split('@')[0] ?? 'Farmer';
      });
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _todayTasks = [
        {
          'id': '1',
          'title': 'Water tomato plants',
          'description': 'Morning watering session in greenhouse A',
          'type': 'watering',
          'priority': 'high',
          'timeSlot': '7:00 AM - 8:00 AM',
          'completed': false,
          'estimatedDuration': '30 min',
        },
        {
          'id': '2',
          'title': 'Check for pests',
          'description': 'Inspect cucumber leaves for aphids',
          'type': 'inspection',
          'priority': 'medium',
          'timeSlot': '10:00 AM - 10:30 AM',
          'completed': false,
          'estimatedDuration': '45 min',
        },
        {
          'id': '3',
          'title': 'Harvest lettuce',
          'description': 'Ready for harvest in plot B',
          'type': 'harvesting',
          'priority': 'high',
          'timeSlot': '6:00 PM - 7:00 PM',
          'completed': false,
          'estimatedDuration': '60 min',
        },
      ];
      
      _overdueTasks = [
        {
          'id': '4',
          'title': 'Fertilize pepper plants',
          'description': 'Overdue by 2 days',
          'type': 'fertilizing',
          'priority': 'urgent',
        },
      ];

      _notifications = [
        {
          'id': '1',
          'title': 'Weather Update',
          'message': 'Perfect weather for planting this week!',
          'type': 'weather',
          'priority': 'low',
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        },
        {
          'id': '2',
          'title': 'Tip of the Day',
          'message': 'Morning is the best time for irrigation.',
          'type': 'info',
          'priority': 'low',
          'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
        },
      ];

      _plantHealth = [
        {
          'name': 'Tomatoes',
          'health': 85,
          'status': 'Good',
          'issues': ['Minor pest activity'],
          'location': 'Greenhouse A',
        },
        {
          'name': 'Lettuce',
          'health': 95,
          'status': 'Excellent',
          'issues': [],
          'location': 'Plot B',
        },
        {
          'name': 'Peppers',
          'health': 70,
          'status': 'Fair',
          'issues': ['Needs fertilization', 'Low moisture'],
          'location': 'Field 1',
        },
        {
          'name': 'Cucumbers',
          'health': 78,
          'status': 'Good',
          'issues': ['Monitor for aphids'],
          'location': 'Greenhouse B',
        },
      ];

      // Market Prices Data for Telangana
      _marketPrices = [
        {
          'marketName': 'Hyderabad APMC',
          'distance': '15 km',
          'crops': [
            {'name': 'Rice', 'price': 'â‚¹2,850', 'unit': '/quintal', 'change': '+2.5%', 'trending': true},
            {'name': 'Cotton', 'price': 'â‚¹6,200', 'unit': '/quintal', 'change': '+1.8%', 'trending': true},
            {'name': 'Maize', 'price': 'â‚¹1,940', 'unit': '/quintal', 'change': '-0.5%', 'trending': false},
          ],
        },
        {
          'marketName': 'Warangal Market',
          'distance': '42 km',
          'crops': [
            {'name': 'Rice', 'price': 'â‚¹2,820', 'unit': '/quintal', 'change': '+1.2%', 'trending': true},
            {'name': 'Turmeric', 'price': 'â‚¹8,500', 'unit': '/quintal', 'change': '+3.1%', 'trending': true},
            {'name': 'Cotton', 'price': 'â‚¹6,150', 'unit': '/quintal', 'change': '+0.8%', 'trending': true},
          ],
        },
        {
          'marketName': 'Nizamabad APMC',
          'distance': '38 km',
          'crops': [
            {'name': 'Turmeric', 'price': 'â‚¹8,650', 'unit': '/quintal', 'change': '+4.2%', 'trending': true},
            {'name': 'Rice', 'price': 'â‚¹2,890', 'unit': '/quintal', 'change': '+2.8%', 'trending': true},
            {'name': 'Chilli', 'price': 'â‚¹12,400', 'unit': '/quintal', 'change': '+5.5%', 'trending': true},
          ],
        },
        {
          'marketName': 'Karimnagar Market',
          'distance': '28 km',
          'crops': [
            {'name': 'Rice', 'price': 'â‚¹2,870', 'unit': '/quintal', 'change': '+1.9%', 'trending': true},
            {'name': 'Maize', 'price': 'â‚¹1,960', 'unit': '/quintal', 'change': '+1.1%', 'trending': true},
            {'name': 'Cotton', 'price': 'â‚¹6,180', 'unit': '/quintal', 'change': '+1.2%', 'trending': true},
          ],
        },
        {
          'marketName': 'Khammam APMC',
          'distance': '52 km',
          'crops': [
            {'name': 'Rice', 'price': 'â‚¹2,840', 'unit': '/quintal', 'change': '+2.1%', 'trending': true},
            {'name': 'Cotton', 'price': 'â‚¹6,220', 'unit': '/quintal', 'change': '+2.2%', 'trending': true},
            {'name': 'Chilli', 'price': 'â‚¹12,200', 'unit': '/quintal', 'change': '+3.8%', 'trending': true},
          ],
        },
      ];
      
      _isLoading = false;
    });
  }

  String _getGreeting() {
    final localizations = AppLocalizations.of(context);
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return '${localizations.goodMorning}, $_userName!';
    } else if (hour < 17) {
      return '${localizations.goodAfternoon}, $_userName!';
    } else {
      return '${localizations.goodEvening}, $_userName!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            HapticFeedback.lightImpact();
            await _loadData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. HEADER - Greeting & Identity (Compact)
                _buildCompactHeader(),

                const SizedBox(height: 20),

                // 2. WEATHER - Compact version
                _buildCompactWeatherCard(),

                const SizedBox(height: 20),

                // 3. TODAY'S TASKS - Simple version
                _buildTodayTasks(),

                const SizedBox(height: 20),

                // 4. QUICK ACTIONS - Bigger version
                _buildBiggerQuickActions(),

                const SizedBox(height: 20),

                // 5. MARKET PRICES - Critical for selling decisions
                _buildMarketPrices(),

                const SizedBox(height: 20),

                // 6. PLANT HEALTH - Monitor crop status
                _buildPlantHealthMonitoring(),

                const SizedBox(height: 20),

                // 7. SEASONAL ADVICE - Timely farming tips
                _buildSeasonalRecommendations(),

                const SizedBox(height: 100), // Bottom navigation space
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          VoiceAssistantService.startListening(context);
        },
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.mic, color: Colors.white),
      ),
    );
  }

  Widget _buildTopAlertBanner() {
    final urgentNotifications = _notifications.where((n) => n['priority'] == 'urgent').toList();
    
    if (urgentNotifications.isEmpty) {
      return const SizedBox.shrink();
    }

    final alert = urgentNotifications.first;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFE53E3E),
            const Color(0xFFD53F8C),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE53E3E).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.priority_high,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tap for details',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Dismiss alert
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.close,
                  color: Colors.white.withOpacity(0.8),
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4CAF50),
            Color(0xFF2E7D32),
            Color(0xFF1B5E20),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Green',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'FARM',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white.withOpacity(0.95),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _getGreeting(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.eco,
                  size: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.pushNamed(context, '/language');
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.translate,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    HapticFeedback.lightImpact();
                    // Show logout confirmation
                    final shouldLogout = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    );
                    
                    if (shouldLogout == true && mounted) {
                      try {
                        await FirebaseService().signOut();
                        if (mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Logout failed: $e')),
                          );
                        }
                      }
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.logout,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUrgentNotifications() {
    // Only show urgent notifications
    final urgentNotifications = _notifications.where((n) => n['priority'] == 'urgent' || n['priority'] == 'high').toList();
    
    if (urgentNotifications.isEmpty) {
      return const SizedBox.shrink(); // Don't show anything if no urgent notifications
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.priority_high,
              color: Colors.red,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Important Alerts',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: urgentNotifications.length > 2 ? 2 : urgentNotifications.length, // Max 2 urgent notifications
          itemBuilder: (context, index) {
            final notification = urgentNotifications[index];
            return _buildSimpleNotificationCard(notification);
          },
        ),
      ],
    );
  }

  Widget _buildSimpleNotificationCard(Map<String, dynamic> notification) {
    final priorityColors = {
      'urgent': Colors.red,
      'high': Colors.orange,
      'medium': Colors.blue,
      'low': Colors.grey,
    };

    final typeIcons = {
      'weather': Icons.cloud,
      'disease': Icons.warning,
      'harvest': Icons.agriculture,
      'general': Icons.info,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: priorityColors[notification['priority']]!.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: priorityColors[notification['priority']] ?? Colors.grey,
            width: 4,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            typeIcons[notification['type']] ?? Icons.info,
            color: priorityColors[notification['priority']] ?? Colors.grey,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: priorityColors[notification['priority']],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification['message'],
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final priorityColors = {
      'urgent': Colors.red,
      'high': Colors.orange,
      'medium': Colors.blue,
      'low': Colors.grey,
    };

    final typeIcons = {
      'weather': Icons.cloud,
      'disease': Icons.warning,
      'harvest': Icons.agriculture,
      'general': Icons.info,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: priorityColors[notification['priority']] ?? Colors.grey,
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            typeIcons[notification['type']] ?? Icons.info,
            color: priorityColors[notification['priority']] ?? Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification['message'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatTimeAgo(notification['timestamp']),
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }

  Widget _buildEnhancedWeatherCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2196F3),
            Color(0xFF1976D2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2196F3).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Weather',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.wb_sunny,
                        color: Colors.yellow,
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '24Â°C',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Sunny',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Humidity: 65%',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Wind: 8 km/h',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: Colors.yellow,
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Perfect weather for outdoor farming activities!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantHealthMonitoring() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plant Health Overview',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2E7D32),
              ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _plantHealth.length,
            itemBuilder: (context, index) {
              final plant = _plantHealth[index];
              return _buildPlantHealthCard(plant);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlantHealthCard(Map<String, dynamic> plant) {
    final health = plant['health'] as int;
    final healthColor = health >= 80
        ? Colors.green
        : health >= 60
            ? Colors.orange
            : Colors.red;

    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                plant['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: healthColor.withOpacity(0.1),
                ),
                child: Center(
                  child: Text(
                    '$health%',
                    style: TextStyle(
                      color: healthColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: health / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(healthColor),
          ),
          const SizedBox(height: 8),
          Text(
            plant['status'],
            style: TextStyle(
              color: healthColor,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            plant['location'],
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          if (plant['issues'].isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'âš ï¸ ${plant['issues'].length} issue${plant['issues'].length > 1 ? 's' : ''}',
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEnhancedQuickActions() {
    final localizations = AppLocalizations.of(context);
    
    final actions = [
      {
        'icon': Icons.camera_alt,
        'label': localizations.scanPlant,
        'color': const Color(0xFF4CAF50),
        'route': '/camera',
        'description': localizations.scanPlantDisease,
      },
      {
        'icon': Icons.water_drop,
        'label': localizations.irrigation,
        'color': const Color(0xFF00BCD4),
        'route': '/irrigation',
        'description': localizations.wateringReminder,
      },
      {
        'icon': Icons.schedule,
        'label': localizations.tasks,
        'color': const Color(0xFF2196F3),
        'route': '/schedule',
        'description': localizations.todayTasks,
      },
      {
        'icon': Icons.lightbulb_outline,
        'label': localizations.quickTips,
        'color': const Color(0xFFFF9800),
        'route': '/tips',
        'description': localizations.proTips,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.quickActions,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2E7D32),
              ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.2,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return _buildEnhancedActionCard(
              icon: action['icon'] as IconData,
              label: action['label'] as String,
              description: action['description'] as String,
              color: action['color'] as Color,
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pushNamed(context, action['route'] as String);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildEnhancedActionCard({
    required IconData icon,
    required String label,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: color,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E7D32),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedTodayTasks() {
    final completedTasks = _todayTasks.where((task) => task['completed'] == true).length;
    final totalTasks = _todayTasks.length;
    final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Tasks",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2E7D32),
                      ),
                ),
                if (totalTasks > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    '$completedTasks of $totalTasks completed',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
            if (_todayTasks.isNotEmpty)
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/schedule');
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('View All'),
              ),
          ],
        ),
        if (totalTasks > 0) ...[
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
            minHeight: 6,
          ),
        ],
        const SizedBox(height: 16),
        if (_todayTasks.isEmpty)
          _buildEmptyTasksCard()
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _todayTasks.length > 3 ? 3 : _todayTasks.length,
            itemBuilder: (context, index) {
              final task = _todayTasks[index];
              return _buildEnhancedTaskCard(task, index);
            },
          ),
      ],
    );
  }

  Widget _buildEmptyTasksCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.withOpacity(0.1),
            Colors.green.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              color: Color(0xFF4CAF50),
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'All caught up!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No tasks scheduled for today. Your farm is in great shape!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedTaskCard(Map<String, dynamic> task, int index) {
    final taskTypeIcons = {
      'watering': Icons.water_drop,
      'fertilizing': Icons.scatter_plot,
      'pestControl': Icons.bug_report,
      'harvesting': Icons.agriculture,
      'planting': Icons.eco,
      'pruning': Icons.content_cut,
      'inspection': Icons.search,
      'other': Icons.task,
    };

    final taskTypeColors = {
      'watering': Colors.blue,
      'fertilizing': Colors.green,
      'pestControl': Colors.red,
      'harvesting': Colors.orange,
      'planting': Colors.green,
      'pruning': Colors.brown,
      'inspection': Colors.purple,
      'other': Colors.grey,
    };

    final priorityColors = {
      'urgent': Colors.red,
      'high': Colors.orange,
      'medium': Colors.blue,
      'low': Colors.grey,
    };

    final isCompleted = task['completed'] ?? false;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.grey[50] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isCompleted
            ? Border.all(color: Colors.green.withOpacity(0.3))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isCompleted ? 0.02 : 0.1),
            blurRadius: isCompleted ? 5 : 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: taskTypeColors[task['type']]!.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  taskTypeIcons[task['type']],
                  color: taskTypeColors[task['type']],
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            task['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: isCompleted
                                  ? Colors.grey[600]
                                  : const Color(0xFF2E7D32),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: priorityColors[task['priority']]!
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            task['priority'].toUpperCase(),
                            style: TextStyle(
                              color: priorityColors[task['priority']],
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (task['description'].isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        task['description'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 6),
              Text(
                task['timeSlot'] ?? 'No time set',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.timer,
                size: 16,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 6),
              Text(
                task['estimatedDuration'] ?? 'No duration',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    HapticFeedback.lightImpact();
                    setState(() {
                      task['completed'] = !isCompleted;
                    });
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isCompleted
                              ? 'Task marked as incomplete'
                              : 'Task completed! Great job! ðŸŽ‰',
                        ),
                        backgroundColor: isCompleted
                            ? Colors.orange
                            : const Color(0xFF4CAF50),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? const Color(0xFF4CAF50)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(
                      isCompleted ? Icons.check : Icons.check_circle_outline,
                      color: isCompleted ? Colors.white : Colors.grey[600],
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedFarmStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Farm Analytics',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2E7D32),
              ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.6,
          children: [
            _buildEnhancedStatCard(
              title: 'Active Tasks',
              value: '${_todayTasks.length}',
              change: '+2 from yesterday',
              changePositive: true,
              icon: Icons.task_alt,
              color: Colors.blue,
            ),
            _buildEnhancedStatCard(
              title: 'Plants Scanned',
              value: '47',
              change: '+12 this week',
              changePositive: true,
              icon: Icons.camera_alt,
              color: Colors.green,
            ),
            _buildEnhancedStatCard(
              title: 'Health Score',
              value: '87%',
              change: '+5% this month',
              changePositive: true,
              icon: Icons.favorite,
              color: Colors.red,
            ),
            _buildEnhancedStatCard(
              title: 'Yield Prediction',
              value: '2.4T',
              change: '+15% vs last season',
              changePositive: true,
              icon: Icons.trending_up,
              color: Colors.purple,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEnhancedStatCard({
    required String title,
    required String value,
    required String change,
    required bool changePositive,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              Icon(
                changePositive ? Icons.trending_up : Icons.trending_down,
                color: changePositive ? Colors.green : Colors.red,
                size: 12,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2E7D32),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            change,
            style: TextStyle(
              fontSize: 9,
              color: changePositive ? Colors.green : Colors.red,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonalRecommendations() {
    final currentMonth = DateTime.now().month;
    final seasonalTips = _getSeasonalTips(currentMonth);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF8BC34A).withOpacity(0.1),
            const Color(0xFF4CAF50).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF8BC34A).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF8BC34A).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF8BC34A),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Seasonal Recommendations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...seasonalTips.map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF8BC34A),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        tip,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  List<String> _getSeasonalTips(int month) {
    // Spring (March-May)
    if (month >= 3 && month <= 5) {
      return [
        'Perfect time for planting tomatoes and peppers',
        'Start preparing soil with compost and organic matter',
        'Begin seed germination for summer crops indoors',
        'Monitor for early pest activity as temperatures rise',
      ];
    }
    // Summer (June-August)
    else if (month >= 6 && month <= 8) {
      return [
        'Increase watering frequency during hot weather',
        'Harvest early summer crops like lettuce and radishes',
        'Apply mulch to conserve soil moisture',
        'Monitor plants for heat stress and provide shade if needed',
      ];
    }
    // Fall (September-November)
    else if (month >= 9 && month <= 11) {
      return [
        'Plant winter crops like kale and Brussels sprouts',
        'Begin harvesting summer crops before first frost',
        'Collect and store seeds for next season',
        'Prepare garden beds for winter cover crops',
      ];
    }
    // Winter (December-February)
    else {
      return [
        'Plan next year\'s garden layout and crop rotation',
        'Order seeds and supplies for spring planting',
        'Maintain greenhouse or indoor growing systems',
        'Prune dormant fruit trees and berry bushes',
      ];
    }
  }

  Widget _buildEnhancedProTips() {
    final tips = [
      {
        'title': 'Watering Wisdom',
        'tip': 'Water your tomato plants early morning for better absorption and to prevent fungal diseases.',
        'category': 'irrigation',
        'icon': Icons.water_drop,
        'color': Colors.blue,
      },
      {
        'title': 'Pest Prevention',
        'tip': 'Companion planting with marigolds can naturally repel harmful insects from your vegetables.',
        'category': 'pest_control',
        'icon': Icons.bug_report,
        'color': Colors.red,
      },
      {
        'title': 'Soil Health',
        'tip': 'Add coffee grounds to your compost for nitrogen-rich soil that plants love.',
        'category': 'soil',
        'icon': Icons.eco,
        'color': Colors.green,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.withOpacity(0.1),
            Colors.yellow.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.lightbulb,
                  color: Colors.orange,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Smart Farming Tips',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 140,
            child: PageView.builder(
              itemCount: tips.length,
              itemBuilder: (context, index) {
                final tip = tips[index];
                return Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
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
                          Icon(
                            tip['icon'] as IconData,
                            color: tip['color'] as Color,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            tip['title'] as String,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: tip['color'] as Color,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Text(
                          tip['tip'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/tips');
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('View All Tips'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketPrices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.storefront,
                color: Colors.orange,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Market Prices - Telangana',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2E7D32),
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Live prices from nearby markets',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/market-prices');
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _marketPrices.length,
            itemBuilder: (context, index) {
              final market = _marketPrices[index];
              return _buildMarketCard(market);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMarketCard(Map<String, dynamic> market) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
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
          // Market Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.orange,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      market['marketName'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      market['distance'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Crop Prices
          Expanded(
            child: ListView.builder(
              itemCount: market['crops'].length,
              itemBuilder: (context, cropIndex) {
                final crop = market['crops'][cropIndex];
                return _buildCropPriceRow(crop);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCropPriceRow(Map<String, dynamic> crop) {
    final isPositive = crop['trending'] as bool;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Crop Icon
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.grass,
              color: Colors.green,
              size: 14,
            ),
          ),
          const SizedBox(width: 12),
          // Crop Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  crop['name'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      crop['price'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      crop['unit'],
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Price Change
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: isPositive 
                  ? Colors.green.withOpacity(0.1) 
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 12,
                ),
                const SizedBox(width: 2),
                Text(
                  crop['change'],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactWeatherCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2196F3),
            Color(0xFF1976D2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2196F3).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.wb_sunny,
            color: Colors.yellow,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '24°C',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sunny • Perfect for farming',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'H: 65%',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
              Text(
                'W: 8km/h',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodayTasks() {
    final completedTasks = _todayTasks.where((task) => task['completed'] == true).length;
    final totalTasks = _todayTasks.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _showTasks = !_showTasks;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.task_alt,
                    color: Color(0xFF4CAF50),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).todayTasks,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        totalTasks > 0 
                            ? '$completedTasks of $totalTasks completed'
                            : AppLocalizations.of(context).noTasks,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _showTasks ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
        if (_showTasks && totalTasks > 0) ...[
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: totalTasks > 3 ? 3 : totalTasks,
            itemBuilder: (context, index) {
              final task = _todayTasks[index];
              return _buildTaskCard(task);
            },
          ),
        ],
      ],
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    final isCompleted = task['completed'] ?? false;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.grey[50] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.task,
            color: const Color(0xFF4CAF50),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted ? Colors.grey[600] : const Color(0xFF2E7D32),
                  ),
                ),
                if (task['timeSlot'] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    task['timeSlot'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                task['completed'] = !isCompleted;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isCompleted ? const Color(0xFF4CAF50) : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                isCompleted ? Icons.check : Icons.check_circle_outline,
                color: isCompleted ? Colors.white : Colors.grey[600],
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiggerQuickActions() {
    final actions = [
      {
        'icon': Icons.camera_alt,
        'label': 'Scan Plant',
        'color': const Color(0xFF4CAF50),
        'route': '/camera',
        'description': 'Check plant health',
      },
      {
        'icon': Icons.bug_report,
        'label': 'AI Disease Detection',
        'color': const Color(0xFFE91E63),
        'route': '/ai-disease-detection',
        'description': 'Detect plant diseases',
      },
      {
        'icon': Icons.storefront,
        'label': 'Market Prices',
        'color': const Color(0xFFFF9800),
        'route': '/market-prices',
        'description': 'Live crop prices',
      },
      {
        'icon': Icons.agriculture,
        'label': 'Crop Advisor',
        'color': const Color(0xFF4CAF50),
        'route': '/crop-recommendation',
        'description': 'AI crop recommendations',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2E7D32),
              ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.8,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            
            return _buildBiggerActionCard(
              icon: action['icon'] as IconData,
              label: action['label'] as String,
              description: action['description'] as String,
              color: action['color'] as Color,
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pushNamed(context, action['route'] as String);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildBiggerActionCard({
    required IconData icon,
    required String label,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.withOpacity(0.15),
                        color.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: color.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: 28,
                    color: color,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2E7D32),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
