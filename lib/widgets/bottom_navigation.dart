import 'package:flutter/material.dart';
import '../services/voice_assistant_service.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;

  const BottomNavigation({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF4CAF50),
        unselectedItemColor: Colors.grey[600],
        selectedFontSize: 12,
        unselectedFontSize: 10,
        elevation: 0,
        onTap: (index) => _onItemTapped(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'హోమ్',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'స్కాన్',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront),
            label: 'మార్కెట్',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'కొనుగోలు',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'ప్రొఫైల్',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        if (currentIndex != 0) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
        break;
      case 1:
        if (currentIndex != 1) {
          Navigator.pushNamed(context, '/camera');
        }
        break;
      case 2:
        if (currentIndex != 2) {
          Navigator.pushNamed(context, '/marketplace');
        }
        break;
      case 3:
        if (currentIndex != 3) {
          Navigator.pushNamed(context, '/consumer-marketplace');
        }
        break;
      case 4:
        if (currentIndex != 4) {
          Navigator.pushNamed(context, '/profile');
        }
        break;
    }
  }
}
