import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../widgets/bottom_navigation.dart';
import '../services/voice_assistant_service.dart';

class ConsumerMarketplaceScreen extends StatefulWidget {
  const ConsumerMarketplaceScreen({Key? key}) : super(key: key);

  @override
  State<ConsumerMarketplaceScreen> createState() => _ConsumerMarketplaceScreenState();
}

class _ConsumerMarketplaceScreenState extends State<ConsumerMarketplaceScreen>
    with TickerProviderStateMixin {
  
  List<Map<String, dynamic>> _availableProducts = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  String _selectedCategory = 'all';
  String _selectedQuality = 'all';
  String _searchQuery = '';
  bool _isLoading = false;
  
  final TextEditingController _searchController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadConsumerProducts();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadConsumerProducts() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _availableProducts = [
        {
          'id': '1',
          'name': 'Organic Tomatoes',
          'nameInTelugu': 'సేంద్రీయ టమాటలు',
          'category': 'vegetables',
          'price': 85.0,
          'unit': 'kg',
          'farmerName': 'R. Reddy',
          'farmerLocation': 'Nizamabad',
          'farmerPhone': '+91-9876543210',
          'cropHealth': 95,
          'qualityGrade': 'A+',
          'harvestDate': DateTime.now().subtract(const Duration(days: 2)),
          'certifications': ['Organic Certified', 'Pesticide Free', 'ISO 9001'],
          'healthReport': {
            'nutritionalValue': 98,
            'pestResidues': 0,
            'freshness': 96,
            'organicContent': 100,
            'shelfLife': '7-10 days',
            'storageRecommendation': 'Cool, dry place',
          },
          'farmerExperience': '15 years',
          'farmSize': '25 acres',
          'farmerRating': 4.8,
          'images': ['tomato1.jpg', 'tomato2.jpg'],
          'description': 'Premium quality organic tomatoes grown using traditional farming methods.',
          'descriptionInTelugu': 'సాంప్రదాయ వ్యవసాయ పద్ధతుల్లో పెంచిన అత్యుత్తమ నాణ్యత సేంద్రీయ టమాటలు.',
          'availableQuantity': 500,
          'minimumOrder': 5,
          'deliveryTime': '2-3 days',
          'reviews': [
            {'rating': 5, 'comment': 'అద్భుతమైన నాణ్యత', 'customer': 'రవి కుమార్'},
            {'rating': 4, 'comment': 'చాలా తాజాగా ఉంది', 'customer': 'సుధా దేవి'},
          ],
        },
        {
          'id': '2',
          'name': 'Premium Basmati Rice',
          'nameInTelugu': 'ప్రీమియం బాస్మతి వరి',
          'category': 'grains',
          'price': 120.0,
          'unit': 'kg',
          'farmerName': 'S. Lakshmi',
          'farmerLocation': 'Karimnagar',
          'farmerPhone': '+91-9876543211',
          'cropHealth': 92,
          'qualityGrade': 'A',
          'harvestDate': DateTime.now().subtract(const Duration(days: 15)),
          'certifications': ['FSSAI Approved', 'Export Quality', 'Quality Assured'],
          'healthReport': {
            'nutritionalValue': 94,
            'pestResidues': 2,
            'freshness': 90,
            'organicContent': 80,
            'shelfLife': '12 months',
            'storageRecommendation': 'Air-tight container',
          },
          'farmerExperience': '12 years',
          'farmSize': '40 acres',
          'farmerRating': 4.9,
          'images': ['rice1.jpg', 'rice2.jpg'],
          'description': 'Aromatic basmati rice with long grains and excellent cooking quality.',
          'descriptionInTelugu': 'సుగంధం గల పొడవైన గింజలతో అద్భుతమైన వంట నాణ్యతతో కూడిన బాస్మతి వరి.',
          'availableQuantity': 2000,
          'minimumOrder': 10,
          'deliveryTime': '3-5 days',
          'reviews': [
            {'rating': 5, 'comment': 'చాలా రుచికరంగా ఉంది', 'customer': 'అనిల్ రెడ్డి'},
            {'rating': 5, 'comment': 'మంచి నాణ్యత', 'customer': 'గీత శర్మ'},
          ],
        },
        {
          'id': '3',
          'name': 'Cotton - Export Quality',
          'nameInTelugu': 'పత్తి - ఎగుమతి నాణ్యత',
          'category': 'fiber',
          'price': 65.0,
          'unit': 'kg',
          'farmerName': 'K. Sunil',
          'farmerLocation': 'Mahbubnagar',
          'farmerPhone': '+91-9876543212',
          'cropHealth': 88,
          'qualityGrade': 'B+',
          'harvestDate': DateTime.now().subtract(const Duration(days: 30)),
          'certifications': ['Export Quality', 'Cotton Corporation Approved'],
          'healthReport': {
            'nutritionalValue': 85,
            'pestResidues': 5,
            'freshness': 85,
            'organicContent': 60,
            'shelfLife': '2 years',
            'storageRecommendation': 'Dry, ventilated warehouse',
          },
          'farmerExperience': '18 years',
          'farmSize': '60 acres',
          'farmerRating': 4.7,
          'images': ['cotton1.jpg', 'cotton2.jpg'],
          'description': 'High-grade cotton suitable for textile manufacturing and export.',
          'descriptionInTelugu': 'వస్త్ర తయారీ మరియు ఎగుమతికి అనుకూలమైన అధిక గ్రేడ్ పత్తి.',
          'availableQuantity': 10000,
          'minimumOrder': 100,
          'deliveryTime': '5-7 days',
          'reviews': [
            {'rating': 4, 'comment': 'మంచి గుణమట్టం', 'customer': 'రామ్ టెక్స్‌టైల్స్'},
            {'rating': 4, 'comment': 'ఎగుమతికి అనుకూలం', 'customer': 'కృష్ణ మిల్స్'},
          ],
        },
        {
          'id': '4',
          'name': 'Organic Turmeric Powder',
          'nameInTelugu': 'సేంద్రీయ పసుపు పొడి',
          'category': 'spices',
          'price': 180.0,
          'unit': 'kg',
          'farmerName': 'M. Priya',
          'farmerLocation': 'Warangal',
          'farmerPhone': '+91-9876543213',
          'cropHealth': 94,
          'qualityGrade': 'A+',
          'harvestDate': DateTime.now().subtract(const Duration(days: 45)),
          'certifications': ['Organic Certified', 'Ayush Approved', 'Export Quality'],
          'healthReport': {
            'nutritionalValue': 96,
            'pestResidues': 0,
            'freshness': 92,
            'organicContent': 100,
            'shelfLife': '18 months',
            'storageRecommendation': 'Cool, dry place',
          },
          'farmerExperience': '10 years',
          'farmSize': '15 acres',
          'farmerRating': 4.6,
          'images': ['turmeric1.jpg', 'turmeric2.jpg'],
          'description': 'Pure organic turmeric powder with high curcumin content.',
          'descriptionInTelugu': 'అధిక కర్క్యుమిన్ కంటెంట్ ఉన్న స్వచ్ఛమైన సేంద్రీయ పసుపు పొడి.',
          'availableQuantity': 800,
          'minimumOrder': 5,
          'deliveryTime': '2-4 days',
          'reviews': [
            {'rating': 5, 'comment': 'అద్భుతమైన రంగు మరియు రుచి', 'customer': 'లీల మల్లిక'},
            {'rating': 5, 'comment': 'స్వచ్ఛమైన నాణ్యత', 'customer': 'వేణు గోపాల్'},
          ],
        },
        {
          'id': '5',
          'name': 'Red Chilli - Guntur Variety',
          'nameInTelugu': 'ఎరుపు మిర్చి - గుంటూరు రకం',
          'category': 'spices',
          'price': 250.0,
          'unit': 'kg',
          'farmerName': 'P. Ravi',
          'farmerLocation': 'Khammam',
          'farmerPhone': '+91-9876543214',
          'cropHealth': 91,
          'qualityGrade': 'A',
          'harvestDate': DateTime.now().subtract(const Duration(days: 20)),
          'certifications': ['Spice Board Approved', 'Export Quality', 'FSSAI Approved'],
          'healthReport': {
            'nutritionalValue': 93,
            'pestResidues': 3,
            'freshness': 88,
            'organicContent': 75,
            'shelfLife': '24 months',
            'storageRecommendation': 'Dry, air-tight container',
          },
          'farmerExperience': '14 years',
          'farmSize': '30 acres',
          'farmerRating': 4.8,
          'images': ['chilli1.jpg', 'chilli2.jpg'],
          'description': 'Premium Guntur variety red chilli with intense heat and flavor.',
          'descriptionInTelugu': 'తీవ్రమైన కారం మరియు రుచితో కూడిన ప్రీమియం గుంటూరు రకం ఎరుపు మిర్చి.',
          'availableQuantity': 1200,
          'minimumOrder': 10,
          'deliveryTime': '3-5 days',
          'reviews': [
            {'rating': 5, 'comment': 'అద్భుతమైన కారం', 'customer': 'శ్రీనివాస్ రెస్టారెంట్'},
            {'rating': 4, 'comment': 'మంచి రంగు', 'customer': 'రమేష్ స్పైసెస్'},
          ],
        },
      ];

      _filteredProducts = List.from(_availableProducts);
      _isLoading = false;
    });
  }

  void _filterProducts() {
    setState(() {
      _filteredProducts = _availableProducts.where((product) {
        bool matchesCategory = _selectedCategory == 'all' || product['category'] == _selectedCategory;
        bool matchesQuality = _selectedQuality == 'all' || product['qualityGrade'].contains(_selectedQuality);
        bool matchesSearch = _searchQuery.isEmpty || 
                           product['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           product['nameInTelugu'].contains(_searchQuery) ||
                           product['farmerName'].toLowerCase().contains(_searchQuery.toLowerCase());
        
        return matchesCategory && matchesQuality && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'కస్టమర్ మార్కెట్ (Consumer Market)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              VoiceAssistantService.startListening(context);
            },
            icon: const Icon(Icons.mic, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadConsumerProducts,
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Column(
                  children: [
                    _buildSearchAndFilters(),
                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _buildProductGrid(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 3),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          VoiceAssistantService.startListening(context);
        },
        backgroundColor: const Color(0xFF2196F3),
        child: const Icon(Icons.mic, color: Colors.white),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'ఉత్పత్తులు లేదా రైతులను వెతకండి...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                        _filterProducts();
                      },
                      icon: const Icon(Icons.clear),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              _filterProducts();
            },
          ),
          
          const SizedBox(height: 16),
          
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('అన్నీ', 'all', 'category'),
                _buildFilterChip('కూరగాయలు', 'vegetables', 'category'),
                _buildFilterChip('ధాన్యాలు', 'grains', 'category'),
                _buildFilterChip('మసాలాలు', 'spices', 'category'),
                _buildFilterChip('ఫైబర్', 'fiber', 'category'),
                const SizedBox(width: 16),
                _buildFilterChip('A+', 'A+', 'quality'),
                _buildFilterChip('A', 'A', 'quality'),
                _buildFilterChip('B+', 'B+', 'quality'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, String filterType) {
    bool isSelected = (filterType == 'category' && _selectedCategory == value) ||
                     (filterType == 'quality' && _selectedQuality == value);
    
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            if (filterType == 'category') {
              _selectedCategory = selected ? value : 'all';
            } else if (filterType == 'quality') {
              _selectedQuality = selected ? value : 'all';
            }
          });
          _filterProducts();
        },
        selectedColor: const Color(0xFF2196F3).withOpacity(0.2),
        checkmarkColor: const Color(0xFF2196F3),
      ),
    );
  }

  Widget _buildProductGrid() {
    if (_filteredProducts.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'ఉత్పత్తులు లేవు',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'వేరే వెతుకు పదాలు ప్రయత్నించండి',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Product Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getCategoryColor(product['category']).withOpacity(0.1),
                  _getCategoryColor(product['category']).withOpacity(0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _getCategoryColor(product['category']).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(product['category']),
                    color: _getCategoryColor(product['category']),
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['nameInTelugu'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product['name'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getGradeColor(product['qualityGrade']).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    product['qualityGrade'],
                    style: TextStyle(
                      color: _getGradeColor(product['qualityGrade']),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Product Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price and Farmer Info
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹${product['price']}/${product['unit']}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2196F3),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.person, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                product['farmerName'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              product['farmerLocation'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.orange),
                            const SizedBox(width: 4),
                            Text(
                              product['farmerRating'].toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Health Report Summary
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.health_and_safety, color: Colors.green, size: 18),
                          const SizedBox(width: 8),
                          const Text(
                            'నాణ్యత హామీ (Quality Assurance)',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${product['cropHealth']}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildHealthMetric(
                              'పోషకాలు',
                              '${product['healthReport']['nutritionalValue']}%',
                              Icons.eco,
                            ),
                          ),
                          Expanded(
                            child: _buildHealthMetric(
                              'తాజాతనం',
                              '${product['healthReport']['freshness']}%',
                              Icons.refresh,
                            ),
                          ),
                          Expanded(
                            child: _buildHealthMetric(
                              'సేంద్రియ',
                              '${product['healthReport']['organicContent']}%',
                              Icons.nature,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Certifications
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: product['certifications'].map<Widget>((cert) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        cert,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 16),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _viewProductDetails(product),
                        icon: const Icon(Icons.info_outline),
                        label: const Text('వివరాలు చూడండి'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF2196F3),
                          side: const BorderSide(color: Color(0xFF2196F3)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _contactFarmer(product),
                        icon: const Icon(Icons.phone),
                        label: const Text('సంప్రదించండి'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.green, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'vegetables':
        return Colors.green;
      case 'grains':
        return Colors.orange;
      case 'spices':
        return Colors.red;
      case 'fiber':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'vegetables':
        return Icons.eco;
      case 'grains':
        return Icons.grain;
      case 'spices':
        return Icons.local_fire_department;
      case 'fiber':
        return Icons.content_cut;
      default:
        return Icons.agriculture;
    }
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A+':
        return Colors.green;
      case 'A':
        return Colors.lightGreen;
      case 'B+':
        return Colors.orange;
      case 'B':
        return Colors.deepOrange;
      default:
        return Colors.grey;
    }
  }

  void _viewProductDetails(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(product: product),
      ),
    );
  }

  void _contactFarmer(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(Icons.phone, color: Color(0xFF4CAF50)),
              const SizedBox(width: 12),
              Text(
                'రైతుని సంప్రదించండి',
                style: const TextStyle(
                  color: Color(0xFF2E7D32),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'రైతు: ${product['farmerName']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'ప్రాంతం: ${product['farmerLocation']}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                'అనుభవం: ${product['farmerExperience']}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                'ఫోన్: ${product['farmerPhone']}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2196F3),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('రద్దు చేయండి'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _makeCall(product['farmerPhone']);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
              ),
              child: const Text(
                'కాల్ చేయండి',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _makeCall(String phoneNumber) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('కాల్ చేస్తున్నాము: $phoneNumber'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }
}

// Product Details Screen
class ProductDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product['nameInTelugu'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Header
            Container(
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['nameInTelugu'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product['name'],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '₹${product['price']}/${product['unit']}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2196F3),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${product['cropHealth']}%',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const Text(
                              'ఆరోగ్యం',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product['descriptionInTelugu'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2E7D32),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Farmer Information
            Container(
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
                  const Text(
                    'రైతు వివరాలు (Farmer Information)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xFF4CAF50),
                        child: Text(
                          product['farmerName'].split(' ').map((e) => e[0]).join(''),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['farmerName'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product['farmerLocation'],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.orange, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  product['farmerRating'].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  product['farmerExperience'],
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFarmerStat('భూమి', product['farmSize']),
                      ),
                      Expanded(
                        child: _buildFarmerStat('ఫోన్', product['farmerPhone']),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Detailed Health Report
            Container(
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
                  const Text(
                    'వివరణాత్మక ఆరోగ్య నివేదిక (Detailed Health Report)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2,
                    children: [
                      _buildHealthReportItem(
                        'పోషకాలు',
                        '${product['healthReport']['nutritionalValue']}%',
                        Icons.eco,
                        Colors.green,
                      ),
                      _buildHealthReportItem(
                        'తాజాతనం',
                        '${product['healthReport']['freshness']}%',
                        Icons.refresh,
                        Colors.blue,
                      ),
                      _buildHealthReportItem(
                        'సేంద్రియ కంటెంట్',
                        '${product['healthReport']['organicContent']}%',
                        Icons.nature,
                        Colors.orange,
                      ),
                      _buildHealthReportItem(
                        'రసాయన అవశేషాలు',
                        '${product['healthReport']['pestResidues']}%',
                        Icons.warning,
                        product['healthReport']['pestResidues'] == 0 ? Colors.green : Colors.red,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStorageInfo(
                          'షెల్ఫ్ లైఫ్',
                          product['healthReport']['shelfLife'],
                          Icons.schedule,
                        ),
                      ),
                      Expanded(
                        child: _buildStorageInfo(
                          'నిల్వ',
                          product['healthReport']['storageRecommendation'],
                          Icons.storage,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Reviews Section
            if (product['reviews'].isNotEmpty) ...[
              Container(
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
                    const Text(
                      'కస్టమర్ రివ్యూలు (Customer Reviews)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...product['reviews'].map<Widget>((review) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Row(
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index < review['rating'] ? Icons.star : Icons.star_border,
                                      color: Colors.orange,
                                      size: 16,
                                    );
                                  }),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  review['customer'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              review['comment'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('కాల్ చేస్తున్నాము: ${product['farmerPhone']}'),
                          backgroundColor: const Color(0xFF4CAF50),
                        ),
                      );
                    },
                    icon: const Icon(Icons.phone),
                    label: const Text('రైతుని కాల్ చేయండి'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 100), // Bottom spacing
          ],
        ),
      ),
    );
  }

  Widget _buildFarmerStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E7D32),
          ),
        ),
      ],
    );
  }

  Widget _buildHealthReportItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStorageInfo(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
