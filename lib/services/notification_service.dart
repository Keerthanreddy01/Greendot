import 'package:flutter/material.dart';

// Simplified notification service for Android without external dependencies
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    // Simple initialization without external packages
    print('NotificationService initialized');
    _isInitialized = true;
  }

  // Show a simple snackbar notification instead of system notification
  void showInAppNotification(BuildContext context, {
    required String title,
    required String body,
    String? payload,
  }) {
    if (!_isInitialized) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(body),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  // Mock methods for farming notifications
  Future<void> scheduleWateringReminder({
    required int id,
    required String plantName,
    required DateTime scheduledTime,
  }) async {
    print('Watering reminder scheduled for $plantName at $scheduledTime');
    // In a real app, this would schedule actual notifications
  }

  Future<void> scheduleFertilizerReminder({
    required int id,
    required String cropName,
    required DateTime scheduledTime,
  }) async {
    print('Fertilizer reminder scheduled for $cropName at $scheduledTime');
    // In a real app, this would schedule actual notifications
  }

  Future<void> schedulePesticideReminder({
    required int id,
    required String cropName,
    required DateTime scheduledTime,
  }) async {
    print('Pesticide reminder scheduled for $cropName at $scheduledTime');
    // In a real app, this would schedule actual notifications
  }

  Future<void> scheduleHarvestReminder({
    required int id,
    required String cropName,
    required DateTime scheduledTime,
  }) async {
    print('Harvest reminder scheduled for $cropName at $scheduledTime');
    // In a real app, this would schedule actual notifications
  }

  Future<void> showWeatherAlert({
    required String weatherCondition,
    required String alertMessage,
  }) async {
    print('Weather Alert: $weatherCondition - $alertMessage');
    // In a real app, this would show actual notifications
  }

  // Cancel notification
  Future<void> cancelNotification(int id) async {
    print('Notification $id cancelled');
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    print('All notifications cancelled');
  }

  // Get pending notifications
  Future<List<Map<String, dynamic>>> getPendingNotifications() async {
    // Return empty list for now
    return [];
  }
}

// Simple enums for notification types
enum NotificationChannel {
  general,
  watering,
  fertilizer,
  pesticide,
  harvest,
  weather,
}

enum Day {
  monday(1),
  tuesday(2),
  wednesday(3),
  thursday(4),
  friday(5),
  saturday(6),
  sunday(7);

  const Day(this.value);
  final int value;
}

class Time {
  final int hour;
  final int minute;
  final int second;

  const Time(this.hour, [this.minute = 0, this.second = 0]);
}