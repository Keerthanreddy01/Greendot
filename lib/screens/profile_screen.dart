import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';
import '../services/voice_assistant_service.dart';
import '../services/firebase_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  String _userName = 'User';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = _firebaseService.currentUser;
    if (user != null) {
      setState(() {
        _userName = user.displayName ?? user.email?.split('@')[0] ?? 'User';
        _userEmail = user.email ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF43A047),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.mic, color: Colors.white),
            onPressed: () => VoiceAssistantService.startListening(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                  child: Column(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.agriculture, size: 45, color: Color(0xFF2E7D32)),
                      ),
                      const SizedBox(height: 12),
                      Text(_userName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(_userEmail, style: const TextStyle(fontSize: 14, color: Colors.white70)),
                      const SizedBox(height: 2),
                      const Text('Greendot Farmer', style: TextStyle(fontSize: 13, color: Colors.white70)),
                    ],
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -25),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(child: _buildStatCard('25.5', 'Acres', Icons.terrain, const Color(0xFF1976D2))),
                    const SizedBox(width: 10),
                    Expanded(child: _buildStatCard('8', 'Crops', Icons.spa, const Color(0xFF388E3C))),
                    const SizedBox(width: 10),
                    Expanded(child: _buildStatCard('15', 'Years', Icons.schedule, const Color(0xFFF57C00))),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text('My Crops', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3))],
                    ),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ..._buildCropTags(),
                        _buildAddButton(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            _buildSettingItem(Icons.notifications, 'Notifications', true),
            _buildSettingItem(Icons.dark_mode, 'Dark Mode', false),
            _buildSettingItem(Icons.language, 'Language', null),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 4),
      floatingActionButton: FloatingActionButton(
        onPressed: () => VoiceAssistantService.startListening(context),
        backgroundColor: const Color(0xFF43A047),
        child: const Icon(Icons.mic, color: Colors.white),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  List<Widget> _buildCropTags() {
    return ['Wheat', 'Rice', 'Cotton', 'Sugarcane'].map((crop) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF66BB6A), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.eco, size: 16, color: Color(0xFF2E7D32)),
            const SizedBox(width: 6),
            Text(crop, style: const TextStyle(color: Color(0xFF1B5E20), fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildAddButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF43A047), Color(0xFF66BB6A)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add, size: 16, color: Colors.white),
          SizedBox(width: 4),
          Text('Add New Crop', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, bool? switchValue) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF2E7D32), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87)),
          ),
          if (switchValue != null)
            Switch.adaptive(
              value: switchValue == true ? notificationsEnabled : darkModeEnabled,
              onChanged: (v) => setState(() => switchValue == true ? notificationsEnabled = v : darkModeEnabled = v),
              activeColor: const Color(0xFF43A047),
            )
          else
            const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
