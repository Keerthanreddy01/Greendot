import 'package:flutter/services.dart';

class SmsService {
  static const MethodChannel _channel = MethodChannel('sms_service');

  /// Send SMS notification for deal confirmation
  static Future<bool> sendDealConfirmationSMS(
    String phoneNumber,
    String farmerName,
    String crop,
    double amount,
  ) async {
    try {
      final message = '''
హాయ్ $farmerName గారు,

మీ $crop ఒప్పందం విజయవంతంగా నిర్ధారించబడింది!

ఒప్పందం వివరాలు:
• పంట: $crop
• మొత్తం: ₹${amount.toStringAsFixed(2)}
• స్థితి: నిర్ధారించబడింది

డాక్యుమెంటేషన్ టీమ్ వివరాలు:
• టీమ్ లీడర్: రాజేష్ శర్మ
• ఫోన్: +91-9876543210
• ఈమెయిల్: team@greenfarm.com

మా టీమ్ 24 గంటల్లో మీతో సంప్రదిస్తుంది.

ధన్యవాదాలు,
GreenFarm టీమ్
''';

      // In a real app, you would integrate with SMS gateway service
      // For now, we'll simulate the SMS sending
      print('SMS sent to $phoneNumber: $message');
      
      return true;
    } catch (e) {
      print('Error sending SMS: $e');
      return false;
    }
  }

  /// Send SMS notification for team assignment
  static Future<bool> sendTeamAssignmentSMS(
    String phoneNumber,
    String farmerName,
    String teamLeaderName,
    String teamLeaderPhone,
    String estimatedVisitTime,
  ) async {
    try {
      final message = '''
హాయ్ $farmerName గారు,

మీ ఒప్పందం కోసం డాక్యుమెంటేషన్ టీమ్ కేటాయించబడింది:

టీమ్ వివరాలు:
• టీమ్ లీడర్: $teamLeaderName
• ఫోన్: $teamLeaderPhone
• సందర్శన సమయం: $estimatedVisitTime

దయచేసి అవసరమైన డాక్యుమెంట్లను సిద్ధం చేసుకోండి:
• ఆధార్ కార్డ్
• పట్టా పేపర్లు
• బ్యాంక్ వివరాలు
• పంట ఆరోగ్య సర్టిఫికేట్

ధన్యవాదాలు,
GreenFarm టీమ్
''';

      print('Team assignment SMS sent to $phoneNumber: $message');
      return true;
    } catch (e) {
      print('Error sending team assignment SMS: $e');
      return false;
    }
  }

  /// Send price alert SMS to farmers
  static Future<bool> sendPriceAlertSMS(
    String phoneNumber,
    String farmerName,
    String crop,
    double newPrice,
    double oldPrice,
  ) async {
    try {
      final priceChange = newPrice - oldPrice;
      final changeText = priceChange > 0 ? '+${priceChange.toStringAsFixed(2)}' : priceChange.toStringAsFixed(2);
      final changeEmoji = priceChange > 0 ? '📈' : '📉';

      final message = '''
హాయ్ $farmerName గారు,

$crop ధర నవీకరణ $changeEmoji

కొత్త ధర: ₹${newPrice.toStringAsFixed(2)}/quintal
మార్పు: ₹$changeText

ఇప్పుడే మీ పంటను అమ్మడానికి GreenFarm యాప్‌ను ఓపెన్ చేయండి!

ధన్యవాదాలు,
GreenFarm టీమ్
''';

      print('Price alert SMS sent to $phoneNumber: $message');
      return true;
    } catch (e) {
      print('Error sending price alert SMS: $e');
      return false;
    }
  }

  /// Send weather alert SMS to farmers
  static Future<bool> sendWeatherAlertSMS(
    String phoneNumber,
    String farmerName,
    String weatherAlert,
    String recommendation,
  ) async {
    try {
      final message = '''
హాయ్ $farmerName గారు,

వాతావరణ హెచ్చరిక ⚠️

$weatherAlert

సిఫార్సు:
$recommendation

మీ పంటలను భద్రపరుచుకోండి.

ధన్యవాదాలు,
GreenFarm టీమ్
''';

      print('Weather alert SMS sent to $phoneNumber: $message');
      return true;
    } catch (e) {
      print('Error sending weather alert SMS: $e');
      return false;
    }
  }

  /// Send harvest reminder SMS to farmers
  static Future<bool> sendHarvestReminderSMS(
    String phoneNumber,
    String farmerName,
    String crop,
    String harvestDate,
  ) async {
    try {
      final message = '''
హాయ్ $farmerName గారు,

కోత రిమైండర్ 🌾

మీ $crop $harvestDate నాడు కోతకు సిద్ధం అవుతుంది.

తయారీలు:
• కోత పరికరాలు సిద్ధం చేసుకోండి
• రవాణా వ్యవస్థను అమర్చుకోండి
• మార్కెట్ ధరలను తనిఖీ చేయండి

ధన్యవాదాలు,
GreenFarm టీమ్
''';

      print('Harvest reminder SMS sent to $phoneNumber: $message');
      return true;
    } catch (e) {
      print('Error sending harvest reminder SMS: $e');
      return false;
    }
  }

  /// Send task reminder SMS to farmers
  static Future<bool> sendTaskReminderSMS(
    String phoneNumber,
    String farmerName,
    String taskTitle,
    String taskTime,
  ) async {
    try {
      final message = '''
హాయ్ $farmerName గారు,

కార్య రిమైండర్ ⏰

$taskTitle
సమయం: $taskTime

మీ పని జాబితా చూడడానికి GreenFarm యాప్‌ను ఓపెన్ చేయండి.

ధన్యవాదాలు,
GreenFarm టీమ్
''';

      print('Task reminder SMS sent to $phoneNumber: $message');
      return true;
    } catch (e) {
      print('Error sending task reminder SMS: $e');
      return false;
    }
  }

  /// Send pest alert SMS to farmers
  static Future<bool> sendPestAlertSMS(
    String phoneNumber,
    String farmerName,
    String pestType,
    String affectedCrop,
    String treatment,
  ) async {
    try {
      final message = '''
హాయ్ $farmerName గారు,

కీటకాల హెచ్చరిక 🐛

మీ $affectedCrop లో $pestType గుర్తించబడింది.

చికిత్స:
$treatment

వెంటనే చర్య తీసుకోండి.

ధన్యవాదాలు,
GreenFarm టీమ్
''';

      print('Pest alert SMS sent to $phoneNumber: $message');
      return true;
    } catch (e) {
      print('Error sending pest alert SMS: $e');
      return false;
    }
  }
}