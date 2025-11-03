import 'package:flutter/material.dart';

abstract class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // App General
  String get appTitle;
  String get welcome;
  String get getStarted;
  String get next;
  String get back;
  String get cancel;
  String get confirm;
  String get save;
  String get loading;
  String get error;
  String get success;
  String get retry;

  // Language Selection
  String get chooseLanguage;
  String get languageSelectionSubtitle;
  String get continueToApp;
  String get languageChangeNote;

  // Home Screen
  String get goodMorning;
  String get goodAfternoon;
  String get goodEvening;
  String get todayWeather;
  String get scanPlant;
  String get quickTips;
  String get scheduleReminder;
  String get healthReport;
  String get myGarden;
  String get notifications;

  // Camera Scanner
  String get scanPlantDisease;
  String get holdSteady;
  String get scanningPlant;
  String get takePicture;
  String get retakePicture;
  String get analyzing;
  String get scanComplete;

  // Pro Tips
  String get proTips;
  String get todayTips;
  String get seasonalAdvice;
  String get cropCare;
  String get pestControl;
  String get soilHealth;
  String get irrigation;
  String get fertilizer;

  // Notifications
  String get reminderTitle;
  String get wateringReminder;
  String get fertilizeReminder;
  String get pesticideReminder;
  String get harvestReminder;
  String get weatherAlert;

  // Scan Results
  String get scanResults;
  String get diseaseDetected;
  String get healthyPlant;
  String get recommendations;
  String get severity;
  String get treatment;
  String get prevention;
  String get confidence;

  // Weather
  String get temperature;
  String get humidity;
  String get rainfall;
  String get windSpeed;
  String get uvIndex;
  String get sunrise;
  String get sunset;

  // Treatment
  String get treatmentRequired;
  String get immediateAction;
  String get weeklyMaintenance;
  String get monthlyTasks;
  String get organicTreatment;
  String get chemicalTreatment;

  // Schedule
  String get mySchedule;
  String get addTask;
  String get editTask;
  String get deleteTask;
  String get markComplete;
  String get pending;
  String get completed;
  String get overdue;

  // Settings
  String get settings;
  String get language;
  String get about;
  String get privacy;
  String get terms;
  String get support;
  String get rateApp;
  String get version;

  // Quick Actions
  String get quickActions;
  String get weatherToday;
  String get plantScanner;
  String get marketplace;
  String get voiceAssistant;

  // Bottom Navigation
  String get home;
  String get schedule;
  String get profile;
  String get more;
  String get diseaseDetection;
  String get marketPrices;
  String get governmentSchemes;

  // Tasks
  String get todayTasks;
  String get tasks;
  String get viewAll;
  String get noTasks;

  // Weather Status
  String get sunny;
  String get cloudy;
  String get rainy;
  String get stormy;
}
