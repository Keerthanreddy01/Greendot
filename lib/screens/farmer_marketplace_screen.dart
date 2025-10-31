import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../widgets/bottom_navigation.dart';
import '../services/voice_assistant_service.dart';

class FarmerMarketplaceScreen extends StatefulWidget {
  const FarmerMarketplaceScreen({Key? key}) : super(key: key);

  @override
  State<FarmerMarketplaceScreen> createState() => _FarmerMarketplaceScreenState();
}

class _FarmerMarketplaceScreenState extends State<FarmerMarketplaceScreen>
    with TickerProviderStateMixin {
  List<Map<String, dynamic>> _topFarmers = [];
  List<Map<String, dynamic>> _verifiedTraders = [];
  List<Map<String, dynamic>> _marketPrices = [];
  Map<String, dynamic>? _selectedCrop;
  bool _isLoading = false;
  String _selectedTab = 'farmers';
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadMarketplaceData();
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
    super.dispose();
  }

  Future<void> _loadMarketplaceData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      // Top Farmers Data for Telangana
      _topFarmers = [
        {
          'id': '1',
          'name': 'R. Reddy',
          'village': 'Nizamabad',
          'district': 'Nizamabad',
          'crop': 'Tomatoes',
          'phone': '+91-9876543210',
          'experience': '15 years',
          'rating': 4.8,
          'totalSales': '₹12.5L',
          'verified': true,
          'specialization': ['Organic Farming', 'Pest Management'],
          'languages': ['Telugu', 'Hindi', 'English'],
          'cropHealth': 95,
          'landArea': '25 acres',
        },
        {
          'id': '2',
          'name': 'S. Lakshmi',
          'village': 'Karimnagar',
          'district': 'Karimnagar',
          'crop': 'Paddy',
          'phone': '+91-9876543211',
          'experience': '12 years',
          'rating': 4.9,
          'totalSales': '₹18.2L',
          'verified': true,
          'specialization': ['Water Management', 'High Yield Varieties'],
          'languages': ['Telugu', 'Hindi'],
          'cropHealth': 92,
          'landArea': '40 acres',
        },
        {
          'id': '3',
          'name': 'K. Sunil',
          'village': 'Mahbubnagar',
          'district': 'Mahbubnagar',
          'crop': 'Cotton',
          'phone': '+91-9876543212',
          'experience': '18 years',
          'rating': 4.7,
          'totalSales': '₹22.8L',
          'verified': true,
          'specialization': ['Cotton Varieties', 'Market Analysis'],
          'languages': ['Telugu', 'English'],
          'cropHealth': 88,
          'landArea': '60 acres',
        },
        {
          'id': '4',
          'name': 'M. Priya',
          'village': 'Warangal',
          'district': 'Warangal',
          'crop': 'Turmeric',
          'phone': '+91-9876543213',
          'experience': '10 years',
          'rating': 4.6,
          'totalSales': '₹8.5L',
          'verified': true,
          'specialization': ['Organic Turmeric', 'Export Quality'],
          'languages': ['Telugu'],
          'cropHealth': 94,
          'landArea': '15 acres',
        },
        {
          'id': '5',
          'name': 'P. Ravi',
          'village': 'Khammam',
          'district': 'Khammam',
          'crop': 'Chilli',
          'phone': '+91-9876543214',
          'experience': '14 years',
          'rating': 4.8,
          'totalSales': '₹15.3L',
          'verified': true,
          'specialization': ['Spice Quality', 'Post Harvest'],
          'languages': ['Telugu', 'Hindi'],
          'cropHealth': 91,
          'landArea': '30 acres',
        },
      ];

      // Verified Traders Data
      _verifiedTraders = [
        {
          'id': '1',
          'name': 'Telangana Agri Traders',
          'location': 'Hyderabad APMC',
          'phone': '+91-9876540001',
          'crops': ['Tomatoes', 'Paddy', 'Cotton'],
          'rating': 4.9,
          'verified': true,
          'assuredTrader': true,
          'licenseNumber': 'TG-2023-001',
          'experience': '25 years',
          'totalPurchases': '₹50Cr+',
          'paymentTerms': 'Immediate',
          'qualityStandards': ['ISO 9001', 'FSSAI Certified'],
        },
        {
          'id': '2',
          'name': 'Green Valley Exports',
          'location': 'Warangal Market',
          'phone': '+91-9876540002',
          'crops': ['Turmeric', 'Chilli', 'Cotton'],
          'rating': 4.7,
          'verified': true,
          'assuredTrader': true,
          'licenseNumber': 'TG-2023-002',
          'experience': '18 years',
          'totalPurchases': '₹35Cr+',
          'paymentTerms': 'Within 24 hours',
          'qualityStandards': ['Export Quality', 'Organic Certified'],
        },
        {
          'id': '3',
          'name': 'Nizamabad Grain Merchants',
          'location': 'Nizamabad APMC',
          'phone': '+91-9876540003',
          'crops': ['Paddy', 'Maize', 'Cotton'],
          'rating': 4.8,
          'verified': true,
          'assuredTrader': false,
          'licenseNumber': 'TG-2023-003',
          'experience': '20 years',
          'totalPurchases': '₹28Cr+',
          'paymentTerms': 'Within 48 hours',
          'qualityStandards': ['APMC Approved'],
        },
        {
          'id': '4',
          'name': 'South India Commodities',
          'location': 'Karimnagar Market',
          'phone': '+91-9876540004',
          'crops': ['Tomatoes', 'Chilli', 'Turmeric'],
          'rating': 4.6,
          'verified': true,
          'assuredTrader': true,
          'licenseNumber': 'TG-2023-004',
          'experience': '15 years',
          'totalPurchases': '₹40Cr+',
          'paymentTerms': 'Same day',
          'qualityStandards': ['Fair Trade', 'Quality Assured'],
        },
      ];

      // Updated Market Prices with trader information
      _marketPrices = [
        {
          'crop': 'Tomatoes',
          'basePrice': 2850,
          'unit': '/quintal',
          'change': '+2.5%',
          'trending': true,
          'lastUpdated': DateTime.now(),
          'traders': [
            {'name': 'Telangana Agri Traders', 'price': 2900, 'assured': true},
            {'name': 'South India Commodities', 'price': 2850, 'assured': true},
            {'name': 'Local Trader A', 'price': 2800, 'assured': false},
          ],
        },
        {
          'crop': 'Paddy',
          'basePrice': 2820,
          'unit': '/quintal',
          'change': '+1.2%',
          'trending': true,
          'lastUpdated': DateTime.now(),
          'traders': [
            {'name': 'Nizamabad Grain Merchants', 'price': 2850, 'assured': false},
            {'name': 'Telangana Agri Traders', 'price': 2820, 'assured': true},
            {'name': 'Local Trader B', 'price': 2780, 'assured': false},
          ],
        },
        {
          'crop': 'Cotton',
          'basePrice': 6200,
          'unit': '/quintal',
          'change': '+1.8%',
          'trending': true,
          'lastUpdated': DateTime.now(),
          'traders': [
            {'name': 'Green Valley Exports', 'price': 6300, 'assured': true},
            {'name': 'Nizamabad Grain Merchants', 'price': 6200, 'assured': false},
            {'name': 'Telangana Agri Traders', 'price': 6180, 'assured': true},
          ],
        },
        {
          'crop': 'Turmeric',
          'basePrice': 8500,
          'unit': '/quintal',
          'change': '+3.1%',
          'trending': true,
          'lastUpdated': DateTime.now(),
          'traders': [
            {'name': 'Green Valley Exports', 'price': 8650, 'assured': true},
            {'name': 'South India Commodities', 'price': 8500, 'assured': true},
            {'name': 'Local Trader C', 'price': 8400, 'assured': false},
          ],
        },
        {
          'crop': 'Chilli',
          'basePrice': 12400,
          'unit': '/quintal',
          'change': '+5.5%',
          'trending': true,
          'lastUpdated': DateTime.now(),
          'traders': [
            {'name': 'South India Commodities', 'price': 12600, 'assured': true},
            {'name': 'Green Valley Exports', 'price': 12400, 'assured': true},
            {'name': 'Local Trader D', 'price': 12200, 'assured': false},
          ],
        },
      ];

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'కృషి మార్కెట్ (Farmer Marketplace)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4CAF50),
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
          onRefresh: _loadMarketplaceData,
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Column(
                  children: [
                    _buildTabSelector(),
                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _buildTabContent(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 2),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          VoiceAssistantService.startListening(context);
        },
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.mic, color: Colors.white),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton('farmers', 'టాప్ రైతులు', Icons.people),
          ),
          Expanded(
            child: _buildTabButton('traders', 'వ్యాపారులు', Icons.storefront),
          ),
          Expanded(
            child: _buildTabButton('prices', 'మార్కెట్ ధరలు', Icons.trending_up),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String tab, String label, IconData icon) {
    final isSelected = _selectedTab == tab;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = tab;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4CAF50) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 'farmers':
        return _buildFarmersTab();
      case 'traders':
        return _buildTradersTab();
      case 'prices':
        return _buildPricesTab();
      default:
        return _buildFarmersTab();
    }
  }

  Widget _buildFarmersTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _topFarmers.length,
      itemBuilder: (context, index) {
        final farmer = _topFarmers[index];
        return _buildFarmerCard(farmer);
      },
    );
  }

  Widget _buildFarmerCard(Map<String, dynamic> farmer) {
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
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFF4CAF50),
                child: Text(
                  farmer['name'].split(' ').map((e) => e[0]).join(''),
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
                    Row(
                      children: [
                        Text(
                          farmer['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        if (farmer['verified']) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 18,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${farmer['village']}, ${farmer['district']}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.orange,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          farmer['rating'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          farmer['experience'],
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.agriculture,
                  color: const Color(0xFF4CAF50),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'విత్తనం (Crop): ${farmer['crop']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getHealthColor(farmer['cropHealth']).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${farmer['cropHealth']}% ఆరోగ్యం',
                    style: TextStyle(
                      color: _getHealthColor(farmer['cropHealth']),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'భూమి (Land)',
                  farmer['landArea'],
                  Icons.landscape,
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  'అమ్మకాలు (Sales)',
                  farmer['totalSales'],
                  Icons.currency_rupee,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: farmer['specialization'].map<Widget>((spec) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  spec,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _callFarmer(farmer['phone']),
                  icon: const Icon(Icons.phone),
                  label: const Text('కాల్ చేయండి'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4CAF50),
                    side: const BorderSide(color: Color(0xFF4CAF50)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _viewFarmerProfile(farmer),
                  icon: const Icon(Icons.person),
                  label: const Text('ప్రొఫైల్'),
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
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Column(
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
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E7D32),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getHealthColor(int health) {
    if (health >= 90) return Colors.green;
    if (health >= 70) return Colors.orange;
    return Colors.red;
  }

  Widget _buildTradersTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _verifiedTraders.length,
      itemBuilder: (context, index) {
        final trader = _verifiedTraders[index];
        return _buildTraderCard(trader);
      },
    );
  }

  Widget _buildTraderCard(Map<String, dynamic> trader) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: trader['assuredTrader'] 
            ? Border.all(color: Colors.amber, width: 2)
            : null,
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
                  color: trader['assuredTrader'] 
                      ? Colors.amber.withOpacity(0.1)
                      : const Color(0xFF2196F3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  trader['assuredTrader'] ? Icons.verified : Icons.storefront,
                  color: trader['assuredTrader'] ? Colors.amber : const Color(0xFF2196F3),
                  size: 24,
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
                            trader['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                        ),
                        if (trader['assuredTrader'])
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'ASSURED',
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trader['location'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.orange,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          trader['rating'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          trader['experience'],
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
          Text(
            'విత్తనాలు (Crops):',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: trader['crops'].map<Widget>((crop) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  crop,
                  style: const TextStyle(
                    color: Color(0xFF4CAF50),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTraderInfo(
                  'చెల్లింపు (Payment)',
                  trader['paymentTerms'],
                  Icons.payment,
                ),
              ),
              Expanded(
                child: _buildTraderInfo(
                  'కొనుగోలు (Purchases)',
                  trader['totalPurchases'],
                  Icons.trending_up,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'గుణమట్టం (Quality Standards):',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D32),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: trader['qualityStandards'].map<Widget>((standard) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  standard,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _callTrader(trader['phone']),
                  icon: const Icon(Icons.phone),
                  label: const Text('కాల్ చేయండి'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2196F3),
                    side: const BorderSide(color: Color(0xFF2196F3)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _contactTrader(trader),
                  icon: const Icon(Icons.message),
                  label: const Text('సంప్రదింపు'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: trader['assuredTrader'] 
                        ? Colors.amber 
                        : const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTraderInfo(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Column(
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
      ],
    );
  }

  Widget _buildPricesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _marketPrices.length,
      itemBuilder: (context, index) {
        final priceData = _marketPrices[index];
        return _buildPriceCard(priceData);
      },
    );
  }

  Widget _buildPriceCard(Map<String, dynamic> priceData) {
    final traders = priceData['traders'] as List<Map<String, dynamic>>;
    final assuredTraders = traders.where((t) => t['assured'] == true).toList();
    final bestTrader = assuredTraders.isNotEmpty 
        ? assuredTraders.reduce((Map<String, dynamic> a, Map<String, dynamic> b) => 
            (a['price'] as num) > (b['price'] as num) ? a : b)
        : traders.first;

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
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.agriculture,
                  color: Color(0xFF4CAF50),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      priceData['crop'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '₹${priceData['basePrice']}${priceData['unit']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: priceData['trending'] 
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            priceData['change'],
                            style: TextStyle(
                              color: priceData['trending'] ? Colors.green : Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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
          Text(
            'వ్యాపారుల ధరలు (Trader Prices):',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D32),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: traders.map((trader) {
              final isBest = trader == bestTrader;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isBest 
                      ? Colors.amber.withOpacity(0.1)
                      : trader['assured'] 
                          ? Colors.green.withOpacity(0.05)
                          : Colors.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: isBest 
                      ? Border.all(color: Colors.amber, width: 2)
                      : trader['assured']
                          ? Border.all(color: Colors.green.withOpacity(0.3))
                          : null,
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
                                trader['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2E7D32),
                                  fontSize: 13,
                                ),
                              ),
                              if (trader['assured']) ...[
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.verified,
                                  color: Colors.green,
                                  size: 14,
                                ),
                              ],
                              if (isBest) ...[
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 14,
                                ),
                              ],
                            ],
                          ),
                          if (isBest)
                            const Text(
                              'అత్యుత్తమ హామీ వ్యాపారి',
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      '₹${trader['price']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isBest ? Colors.amber : const Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Text(
            'చివరిసారి నవీకరించబడింది: ${_formatTime(priceData['lastUpdated'])}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => _startCropDeal(priceData['crop']),
            icon: const Icon(Icons.handshake),
            label: const Text('ఒప్పందం ప్రారంభించండి'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 45),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final difference = DateTime.now().difference(time);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} నిమిషాల క్రితం';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} గంటల క్రితం';
    } else {
      return '${difference.inDays} రోజుల క్రితం';
    }
  }

  void _callFarmer(String phone) {
    // Implement phone calling functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('రైతుకు కాల్ చేస్తున్నాము: $phone'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }

  void _viewFarmerProfile(Map<String, dynamic> farmer) {
    Navigator.pushNamed(context, '/farmer-profile', arguments: farmer);
  }

  void _callTrader(String phone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('వ్యాపారికి కాల్ చేస్తున్నాము: $phone'),
        backgroundColor: const Color(0xFF2196F3),
      ),
    );
  }

  void _contactTrader(Map<String, dynamic> trader) {
    Navigator.pushNamed(context, '/trader-contact', arguments: trader);
  }

  void _startCropDeal(String crop) {
    Navigator.pushNamed(context, '/crop-deal', arguments: crop);
  }
}
