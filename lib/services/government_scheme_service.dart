import '../models/government_scheme_model.dart';

class GovernmentSchemeService {
  // Demo government schemes
  static List<GovernmentScheme> getDemoSchemes() {
    final now = DateTime.now();
    
    return [
      GovernmentScheme(
        id: 'pm_kisan',
        name: 'PM-KISAN',
        schemeNameLocal: 'प्रधानमंत्री किसान सम्मान निधि',
        description: 'Direct income support of ₹6000 per year',
        descriptionLocal: 'प्रति वर्ष ₹6000 की प्रत्यक्ष आय सहायता',
        category: 'pension',
        state: 'All India',
        eligibility: ['All farmer families with cultivable land'],
        benefits: ['₹6000 per year in 3 installments'],
        benefitAmount: 6000,
        howToApply: 'Visit nearest CSC or apply online',
        applyUrl: 'https://pmkisan.gov.in',
        deadline: DateTime(now.year, 12, 31),
        imageUrl: '',
        isActive: true,
        iconName: '💰',
        documents: ['Aadhaar', 'Land Records', 'Bank Account'],
      ),
      GovernmentScheme(
        id: 'pmfby',
        name: 'Crop Insurance',
        schemeNameLocal: 'फसल बीमा योजना',
        description: 'Comprehensive crop insurance',
        descriptionLocal: 'व्यापक फसल बीमा',
        category: 'insurance',
        state: 'All India',
        eligibility: ['All farmers growing notified crops'],
        benefits: ['Up to ₹2 lakh coverage'],
        benefitAmount: 200000,
        howToApply: 'Register within 7 days of sowing',
        applyUrl: 'https://pmfby.gov.in',
        deadline: DateTime(now.year, now.month + 1, 15),
        imageUrl: '',
        isActive: true,
        iconName: '🛡️',
        documents: ['Aadhaar', 'Land Records'],
      ),
      GovernmentScheme(
        id: 'rythu_bharosa',
        name: 'Rythu Bharosa',
        schemeNameLocal: 'రైతు భరోసా',
        description: '₹5000 per acre per season',
        descriptionLocal: 'ప్రతి సీజన్కు ఎకరాకు ₹5000',
        category: 'pension',
        state: 'Telangana',
        eligibility: ['Farmers in Telangana with land records'],
        benefits: ['₹5000 per acre'],
        benefitAmount: 5000,
        howToApply: 'Auto credit to registered farmers',
        applyUrl: '',
        deadline: DateTime(now.year, 12, 31),
        imageUrl: '',
        isActive: true,
        iconName: '🌾',
        documents: ['Land Records', 'Bank Account'],
      ),
    ];
  }

  // Demo notifications
  static List<SchemeNotification> getDemoNotifications() {
    final now = DateTime.now();
    
    return [
      SchemeNotification(
        id: 'notif_1',
        schemeId: 'pm_kisan',
        title: 'PM-KISAN Payment Received',
        message: '₹2000 credited to your account for Kharif 2025',
        notificationDate: now.subtract(const Duration(hours: 2)),
        isRead: false,
        type: 'approved',
      ),
      SchemeNotification(
        id: 'notif_2',
        schemeId: 'pmfby',
        title: 'Crop Insurance Reminder',
        message: 'Last 3 days to register for Rabi crop insurance',
        notificationDate: now.subtract(const Duration(days: 1)),
        isRead: false,
        type: 'reminder',
      ),
      SchemeNotification(
        id: 'notif_3',
        schemeId: 'rythu_bharosa',
        title: 'Rythu Bharosa Payment',
        message: '₹5000 per acre will be credited by 15th Nov',
        notificationDate: now.subtract(const Duration(days: 3)),
        isRead: false,
        type: 'approved',
      ),
    ];
  }

  static List<GovernmentScheme> getActiveSchemes() {
    return getDemoSchemes().where((scheme) => scheme.isActive).toList();
  }

  static List<SchemeNotification> getUnreadNotifications() {
    return getDemoNotifications().where((notif) => !notif.isRead).toList();
  }

  static int getUnreadCount() {
    return getUnreadNotifications().length;
  }
}
