import 'package:flutter/material.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final Function(Locale) onLanguageSelected;

  const LanguageSelectionScreen({
    Key? key,
    required this.onLanguageSelected,
  }) : super(key: key);

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  int? _selectedIndex;
  bool _isNavigating = false;

  final List<Map<String, dynamic>> _languages = [
    {
      'name': 'English',
      'nativeName': 'English',
      'locale': const Locale('en', 'US'),
      'icon': Icons.language,
      'color': const Color(0xFF2196F3),
      'greeting': 'Hello!',
      'description': 'International language',
    },
    {
      'name': 'Telugu',
      'nativeName': 'తెలుగు',
      'locale': const Locale('te', 'IN'),
      'icon': Icons.translate,
      'color': const Color(0xFFFF9800),
      'greeting': 'నమస్కారం!',
      'description': 'మీ స్థానిక భాష',
    },
    {
      'name': 'Hindi',
      'nativeName': 'हिंदी',
      'locale': const Locale('hi', 'IN'),
      'icon': Icons.record_voice_over,
      'color': const Color(0xFFFF5722),
      'greeting': 'नमस्ते!',
      'description': 'राष्ट्रीय भाषा',
    },
    {
      'name': 'Tamil',
      'nativeName': 'தமிழ்',
      'locale': const Locale('ta', 'IN'),
      'icon': Icons.speaker_notes,
      'color': const Color(0xFFE91E63),
      'greeting': 'வணக்கம்!',
      'description': 'தமிழ் மொழி',
    },
    {
      'name': 'Kannada',
      'nativeName': 'ಕನ್ನಡ',
      'locale': const Locale('kn', 'IN'),
      'icon': Icons.chat_bubble_outline,
      'color': const Color(0xFF9C27B0),
      'greeting': 'ನಮಸ್ಕಾರ!',
      'description': 'ಕರ್ನಾಟಕ ಭಾಷೆ',
    },
    {
      'name': 'Malayalam',
      'nativeName': 'മലയാളം',
      'locale': const Locale('ml', 'IN'),
      'icon': Icons.forum,
      'color': const Color(0xFF009688),
      'greeting': 'നമസ്കാരം!',
      'description': 'കേരള ഭാഷ',
    },
    {
      'name': 'Marathi',
      'nativeName': 'मराठी',
      'locale': const Locale('mr', 'IN'),
      'icon': Icons.question_answer,
      'color': const Color(0xFF673AB7),
      'greeting': 'नमस्कार!',
      'description': 'महाराष्ट्र भाषा',
    },
    {
      'name': 'Gujarati',
      'nativeName': 'ગુજરાતી',
      'locale': const Locale('gu', 'IN'),
      'icon': Icons.message,
      'color': const Color(0xFF00BCD4),
      'greeting': 'નમસ્તે!',
      'description': 'ગુજરાત ભાષા',
    },
    {
      'name': 'Bengali',
      'nativeName': 'বাংলা',
      'locale': const Locale('bn', 'IN'),
      'icon': Icons.textsms,
      'color': const Color(0xFF4CAF50),
      'greeting': 'নমস্কার!',
      'description': 'বাংলা ভাষা',
    },
    {
      'name': 'Punjabi',
      'nativeName': 'ਪੰਜਾਬੀ',
      'locale': const Locale('pa', 'IN'),
      'icon': Icons.chat,
      'color': const Color(0xFFCDDC39),
      'greeting': 'ਸਤ ਸ੍ਰੀ ਅਕਾਲ!',
      'description': 'ਪੰਜਾਬ ਦੀ ਭਾਸ਼ਾ',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF4CAF50).withOpacity(0.1),
              const Color(0xFF2E7D32).withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              // Header
                              _buildHeader(),
                              const SizedBox(height: 30),
                              // Language grid
                              _buildLanguageGrid(),
                              const SizedBox(height: 20),
                              // Footer
                              _buildFooter(),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4CAF50).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.language,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Select Your Language',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Choose your preferred language',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLanguageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.05,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _languages.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 400 + (index * 80)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: _buildLanguageCard(_languages[index], index),
            );
          },
        );
      },
    );
  }

  Widget _buildLanguageCard(Map<String, dynamic> language, int index) {
    final isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () => _selectLanguage(language['locale'], index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: isSelected ? language['color'] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? language['color'] 
                : Colors.grey.withOpacity(0.2),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? language['color'].withOpacity(0.4)
                  : Colors.black.withOpacity(0.05),
              blurRadius: isSelected ? 20 : 10,
              offset: Offset(0, isSelected ? 8 : 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Colors.white.withOpacity(0.3)
                      : language['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  language['icon'],
                  size: 26,
                  color: isSelected ? Colors.white : language['color'],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                language['nativeName'],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : const Color(0xFF1B5E20),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                language['greeting'],
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected 
                      ? Colors.white.withOpacity(0.9)
                      : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (isSelected) ...[
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, size: 11, color: Colors.white),
                      SizedBox(width: 2),
                      Text(
                        'Selected',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        if (_selectedIndex != null && !_isNavigating)
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 400),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: ElevatedButton(
                  onPressed: _confirmSelection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                    shadowColor: const Color(0xFF4CAF50).withOpacity(0.5),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        const SizedBox(height: 16),
        Text(
          'You can change this later in settings',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _selectLanguage(Locale locale, int index) {
    if (_isNavigating) return;
    
    setState(() {
      _selectedIndex = index;
    });
    
    // Haptic feedback would go here
    _cardAnimationController.forward().then((_) {
      _cardAnimationController.reverse();
    });
  }

  void _confirmSelection() async {
    if (_selectedIndex == null || _isNavigating) return;
    
    setState(() {
      _isNavigating = true;
    });

    final selectedLanguage = _languages[_selectedIndex!];
    widget.onLanguageSelected(selectedLanguage['locale']);
    
    // Small delay for visual feedback
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }
}