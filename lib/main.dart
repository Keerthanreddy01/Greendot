import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'localization/app_localizations_delegate.dart';
import 'screens/splash_screen.dart';
import 'screens/language_selection_screen.dart';
import 'screens/home_screen.dart';
import 'screens/camera_scanner_screen.dart';
import 'screens/pro_tips_screen.dart';
import 'screens/scan_result_screen.dart';
import 'screens/farmer_marketplace_screen.dart';
import 'screens/consumer_marketplace_screen.dart';
// import 'screens/crop_deal_screen.dart' as crop_deal;
// import 'screens/schedule_screen.dart';
// import 'screens/profile_screen.dart';
// import 'screens/irrigation_screen.dart';
// import 'screens/pest_control_screen.dart';
// import 'screens/reports_screen.dart';
// import 'screens/market_prices_screen.dart';
import 'services/voice_assistant_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const GreenFarmApp());
}

class GreenFarmApp extends StatefulWidget {
  const GreenFarmApp({Key? key}) : super(key: key);

  @override
  State<GreenFarmApp> createState() => _GreenFarmAppState();
}

class _GreenFarmAppState extends State<GreenFarmApp> {
  Locale _currentLocale = const Locale('en', 'US');

  void setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    await prefs.setString('country_code', locale.countryCode ?? '');
    await prefs.setBool('language_selected', true);

    // Update the current locale and rebuild the app
    setState(() {
      _currentLocale = locale;
    });

    // Language selection saved for future use
    if (kDebugMode) {
      print('Language selected: ${locale.languageCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('language_code') ?? 'en';
      final countryCode = prefs.getString('country_code') ?? 'US';

      setState(() {
        _currentLocale = Locale(languageCode, countryCode);
      });
    } catch (e) {
      // If loading fails, keep default English
      if (kDebugMode) {
        print('Error loading saved language: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Green Farm Assistant - కిసాన్',
      debugShowCheckedModeBanner: false,

      // Localization
      locale: _currentLocale,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('hi', 'IN'),
        Locale('te', 'IN'),
        Locale('ta', 'IN'),
        Locale('kn', 'IN'),
        Locale('ml', 'IN'),
        Locale('mr', 'IN'),
        Locale('gu', 'IN'),
        Locale('bn', 'IN'),
        Locale('pa', 'IN'),
        Locale('or', 'IN'),
        Locale('as', 'IN'),
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF4CAF50),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
          displayMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E7D32),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Color(0xFF424242),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Color(0xFF616161),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            foregroundColor: Colors.white,
            elevation: 2,
            shadowColor: Colors.black26,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
      ),
      routes: {
        '/': (context) => const SplashScreen(),
        '/language': (context) => LanguageSelectionScreen(
          onLanguageSelected: setLocale,
        ),
        '/home': (context) => const HomeScreen(),
        '/camera': (context) => const CameraScannerScreen(),
        '/tips': (context) => const ProTipsScreen(),
        '/scan-result': (context) => const ScanResultScreen(),
        // '/schedule': (context) => const ScheduleScreen(),
        // '/profile': (context) => const ProfileScreen(),
        // '/irrigation': (context) => const IrrigationScreen(),
        // '/pest-control': (context) => const PestControlScreen(),
        // '/reports': (context) => const ReportsScreen(),
        // '/market-prices': (context) => const MarketPricesScreen(),
        // New marketplace routes
        '/marketplace': (context) => const FarmerMarketplaceScreen(),
        '/consumer-marketplace': (context) => const ConsumerMarketplaceScreen(),
        // '/crop-deal': (context) {
        //   final crop = ModalRoute.of(context)?.settings.arguments as String? ?? 'tomatoes';
        //   return crop_deal.CropDealScreen(crop: crop);
        // },
      },
      initialRoute: '/',
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      },
    );
  }
}

// Placeholder screens for routes that don't exist yet
class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              VoiceAssistantService.startListening(context);
            },
            icon: const Icon(Icons.mic, color: Colors.white),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.schedule,
              size: 64,
              color: Color(0xFF4CAF50),
            ),
            SizedBox(height: 16),
            Text(
              'Schedule Screen',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Coming soon!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          VoiceAssistantService.startListening(context);
        },
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.mic, color: Colors.white),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              VoiceAssistantService.startListening(context);
            },
            icon: const Icon(Icons.mic, color: Colors.white),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 64,
              color: Color(0xFF4CAF50),
            ),
            SizedBox(height: 16),
            Text(
              'Profile Screen',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Coming soon!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          VoiceAssistantService.startListening(context);
        },
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.mic, color: Colors.white),
      ),
    );
  }
}

class IrrigationScreen extends StatelessWidget {
  const IrrigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Irrigation Control'),
        backgroundColor: const Color(0xFF00BCD4),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              VoiceAssistantService.startListening(context);
            },
            icon: const Icon(Icons.mic, color: Colors.white),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.water_drop,
              size: 64,
              color: Color(0xFF00BCD4),
            ),
            SizedBox(height: 16),
            Text(
              'Smart Irrigation',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Coming soon!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          VoiceAssistantService.startListening(context);
        },
        backgroundColor: const Color(0xFF00BCD4),
        child: const Icon(Icons.mic, color: Colors.white),
      ),
    );
  }
}

class PestControlScreen extends StatelessWidget {
  const PestControlScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pest Control'),
        backgroundColor: const Color(0xFFF44336),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              VoiceAssistantService.startListening(context);
            },
            icon: const Icon(Icons.mic, color: Colors.white),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bug_report,
              size: 64,
              color: Color(0xFFF44336),
            ),
            SizedBox(height: 16),
            Text(
              'Pest Management',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Coming soon!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          VoiceAssistantService.startListening(context);
        },
        backgroundColor: const Color(0xFFF44336),
        child: const Icon(Icons.mic, color: Colors.white),
      ),
    );
  }
}

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Reports'),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              VoiceAssistantService.startListening(context);
            },
            icon: const Icon(Icons.mic, color: Colors.white),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assessment,
              size: 64,
              color: Color(0xFF9C27B0),
            ),
            SizedBox(height: 16),
            Text(
              'Analytics & Reports',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Coming soon!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          VoiceAssistantService.startListening(context);
        },
        backgroundColor: const Color(0xFF9C27B0),
        child: const Icon(Icons.mic, color: Colors.white),
      ),
    );
  }
}

class MarketPricesScreen extends StatelessWidget {
  const MarketPricesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Prices'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              VoiceAssistantService.startListening(context);
            },
            icon: const Icon(Icons.mic, color: Colors.white),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.storefront,
              size: 64,
              color: Colors.orange,
            ),
            SizedBox(height: 16),
            Text(
              'Market Prices - Telangana',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Detailed market analysis coming soon!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          VoiceAssistantService.startListening(context);
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.mic, color: Colors.white),
      ),
    );
  }
}