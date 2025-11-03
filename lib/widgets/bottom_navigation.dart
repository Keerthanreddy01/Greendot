import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../localization/app_localizations.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;

  const BottomNavigation({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, localizations.home, 0, context),
              _buildNavItem(Icons.camera_alt_rounded, localizations.diseaseDetection, 1, context),
              _buildNavItem(Icons.storefront_rounded, localizations.marketPrices, 2, context),
              _buildNavItem(Icons.account_balance_rounded, localizations.governmentSchemes, 3, context),
              _buildNavItem(Icons.person_rounded, localizations.profile, 4, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, BuildContext context) {
    final isSelected = currentIndex == index;
    
    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          _onItemTapped(context, index);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF4CAF50) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
                size: 20,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? const Color(0xFF4CAF50) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        if (currentIndex != 0) Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        break;
      case 1:
        Navigator.pushNamed(context, '/ai-disease-detection');
        break;
      case 2:
        Navigator.pushNamed(context, '/market-prices');
        break;
      case 3:
        Navigator.pushNamed(context, '/government-schemes');
        break;
      case 4:
        if (currentIndex != 4) Navigator.pushNamed(context, '/profile');
        break;
    }
  }
}