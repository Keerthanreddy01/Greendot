import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';
import '../services/voice_assistant_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<Offset> _slideAnimation;

  double _progress = 0.0;
  bool _navigated = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startProgress();
    _bootstrapAndNavigate();
  }

  void _initializeAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _textController.forward();
    });
  }

  Future<void> _bootstrapAndNavigate() async {
    // Show splash immediately; start services in background without blocking
    // Fire-and-forget (don't delay splash)
    // ignore: unawaited_futures
    NotificationService().init();
    // ignore: unawaited_futures
    VoiceAssistantService.initialize();

    // Load preference to decide where to go
    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenLanguageSelection =
        prefs.getBool('language_selected') ?? false;

    // Give users a moment to see the splash while progress fills
    await Future.delayed(const Duration(milliseconds: 1600));

    if (!_disposed && !_navigated && mounted) {
      _navigated = true;
      if (hasSeenLanguageSelection) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacementNamed('/language');
      }
    }
  }

  void _startProgress() {
    // Simple timed progress to 100% over ~1.6s
    const total = 32;
    const tick = Duration(milliseconds: 50);
    for (int i = 1; i <= total; i++) {
      Future.delayed(tick * i, () {
        if (!_disposed && mounted) {
          setState(() {
            _progress = i / total;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4CAF50),
              Color(0xFF2E7D32),
              Color(0xFF1B5E20),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Main content
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo Animation (lightweight)
                      AnimatedBuilder(
                        animation: _logoAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _logoAnimation.value,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.eco,
                                size: 60,
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 30),

                      // App Title Animation (lightweight)
                      AnimatedBuilder(
                        animation: _textAnimation,
                        builder: (context, child) {
                          return SlideTransition(
                            position: _slideAnimation,
                            child: Opacity(
                              opacity: _textAnimation.value,
                              child: Column(
                                children: [
                                  const Text(
                                    'Green Farm',
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Smart Farming Solutions',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Demo badge (static)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Text(
                                      'DEMO MODE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40),

                      // Simple loading bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 48.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: _progress,
                            minHeight: 6,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom section (static)
              AnimatedBuilder(
                animation: _textAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textAnimation.value,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          // Features preview (static icons)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              _Feature(icon: Icons.camera_alt, label: 'Plant Scanner'),
                              _Feature(icon: Icons.wb_sunny, label: 'Weather'),
                              _Feature(icon: Icons.schedule, label: 'Reminders'),
                              _Feature(icon: Icons.lightbulb, label: 'Tips'),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Version and copyright
                          Text(
                            'Version 1.0.0 - Demo',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '© 2024 Green Farm Technologies',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class _Feature extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Feature({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}