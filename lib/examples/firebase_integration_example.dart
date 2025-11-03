// Example: How to integrate Firebase into your existing HomeScreen

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';

class FirebaseIntegrationExample extends StatefulWidget {
  const FirebaseIntegrationExample({Key? key}) : super(key: key);

  @override
  State<FirebaseIntegrationExample> createState() => _FirebaseIntegrationExampleState();
}

class _FirebaseIntegrationExampleState extends State<FirebaseIntegrationExample> {
  final FirebaseService _firebaseService = FirebaseService();
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// Load user data from Firestore
  Future<void> _loadUserData() async {
    try {
      final userId = _firebaseService.currentUser?.uid;
      if (userId != null) {
        final data = await _firebaseService.getUserData(userId);
        setState(() {
          _userData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to load user data: $e');
    }
  }

  /// Handle sign out
  Future<void> _handleSignOut() async {
    try {
      await _firebaseService.signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      _showError('Sign out failed: $e');
    }
  }

  /// Show error message
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Integration Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleSignOut,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Info Card
                  _buildUserInfoCard(),
                  const SizedBox(height: 20),

                  // Example: Listen to auth state changes
                  _buildAuthStateListener(),
                  const SizedBox(height: 20),

                  // Example: Real-time user data
                  _buildRealtimeUserData(),
                  const SizedBox(height: 20),

                  // Example: Update profile button
                  _buildUpdateProfileButton(),
                ],
              ),
            ),
    );
  }

  /// User info card
  Widget _buildUserInfoCard() {
    final user = _firebaseService.currentUser;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current User Info',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text('UID: ${user?.uid ?? "Not available"}'),
            Text('Email: ${user?.email ?? "Not available"}'),
            Text('Display Name: ${user?.displayName ?? "Not set"}'),
            Text('Email Verified: ${user?.emailVerified ?? false}'),
          ],
        ),
      ),
    );
  }

  /// Example: StreamBuilder for auth state changes
  Widget _buildAuthStateListener() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Auth State Listener',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder<User?>(
              stream: _firebaseService.authStateChanges,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('User is logged in: ${snapshot.data?.email}');
                }
                return const Text('User is not logged in');
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Example: Real-time Firestore data listener
  Widget _buildRealtimeUserData() {
    final userId = _firebaseService.currentUser?.uid;
    
    if (userId == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No user logged in'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Real-time User Data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder(
              stream: _firebaseService.getUserDataStream(userId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Text('No user data found');
                }

                final data = snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${data['name'] ?? "Not set"}'),
                    Text('Phone: ${data['phoneNumber'] ?? "Not set"}'),
                    Text('Location: ${data['location'] ?? "Not set"}'),
                    Text('Farm Size: ${data['farmSize'] ?? "Not set"}'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Example: Update profile button
  Widget _buildUpdateProfileButton() {
    return ElevatedButton.icon(
      onPressed: _showUpdateProfileDialog,
      icon: const Icon(Icons.edit),
      label: const Text('Update Profile'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }

  /// Show dialog to update profile
  Future<void> _showUpdateProfileDialog() async {
    final phoneController = TextEditingController();
    final locationController = TextEditingController();
    final farmSizeController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '+91 9876543210',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  hintText: 'Punjab, India',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: farmSizeController,
                decoration: const InputDecoration(
                  labelText: 'Farm Size',
                  hintText: '10 acres',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final userId = _firebaseService.currentUser?.uid;
              if (userId != null) {
                try {
                  await _firebaseService.updateUserData(userId, {
                    'phoneNumber': phoneController.text.trim(),
                    'location': locationController.text.trim(),
                    'farmSize': farmSizeController.text.trim(),
                  });
                  
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    _loadUserData(); // Reload data
                  }
                } catch (e) {
                  _showError('Update failed: $e');
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}

/// ========================================
/// EXAMPLE: How to add Firebase to HomeScreen
/// ========================================

/// Add this to your existing HomeScreen:
/*

import '../services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  // ... existing code
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }
  
  Future<void> _loadUserProfile() async {
    final userId = _firebaseService.currentUser?.uid;
    if (userId != null) {
      try {
        final userData = await _firebaseService.getUserData(userId);
        // Use the userData to display user info
        print('User: ${userData?['name']}');
      } catch (e) {
        print('Error loading profile: $e');
      }
    }
  }
  
  Future<void> _handleSignOut() async {
    try {
      await _firebaseService.signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      print('Sign out error: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ... existing code
        actions: [
          // Add logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleSignOut,
          ),
        ],
      ),
      // ... rest of your existing code
    );
  }
}

*/

/// ========================================
/// EXAMPLE: Image Upload in Camera Screen
/// ========================================

/*

// In your CameraScannerScreen or any screen where you capture images:

import 'dart:io';
import '../services/firebase_service.dart';

Future<void> uploadPlantImage(File imageFile) async {
  final FirebaseService firebaseService = FirebaseService();
  
  try {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    
    // Upload image
    final String downloadUrl = await firebaseService.uploadImage(
      file: imageFile,
      path: 'plant_images',
    );
    
    // Hide loading indicator
    Navigator.pop(context);
    
    // Save the download URL to Firestore
    final userId = firebaseService.currentUser?.uid;
    if (userId != null) {
      await firebaseService.addDocument('scans', {
        'userId': userId,
        'imageUrl': downloadUrl,
        'timestamp': DateTime.now(),
        'disease': 'Detected Disease Name',
        'confidence': 0.95,
      });
    }
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image uploaded successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    // Hide loading if shown
    Navigator.pop(context);
    
    // Show error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Upload failed: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

*/

/// ========================================
/// EXAMPLE: Get User's Scan History
/// ========================================

/*

Future<List<Map<String, dynamic>>> getUserScanHistory() async {
  final FirebaseService firebaseService = FirebaseService();
  final userId = firebaseService.currentUser?.uid;
  
  if (userId == null) return [];
  
  try {
    final querySnapshot = await firebaseService.getDocuments(
      'scans',
      queryBuilder: (query) => query
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .limit(20),
    );
    
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  } catch (e) {
    print('Error fetching scan history: $e');
    return [];
  }
}

// Use in a FutureBuilder:
FutureBuilder<List<Map<String, dynamic>>>(
  future: getUserScanHistory(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }
    
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    
    final scans = snapshot.data ?? [];
    
    return ListView.builder(
      itemCount: scans.length,
      itemBuilder: (context, index) {
        final scan = scans[index];
        return ListTile(
          leading: Image.network(scan['imageUrl']),
          title: Text(scan['disease']),
          subtitle: Text('Confidence: ${(scan['confidence'] * 100).toStringAsFixed(1)}%'),
          trailing: Text(scan['timestamp'].toDate().toString()),
        );
      },
    );
  },
)

*/
