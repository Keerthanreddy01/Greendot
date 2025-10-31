import '../models/government_scheme_model.dart';

class GovernmentSchemeService {
  // Demo government schemes
  static List<GovernmentScheme> getDemoSchemes() {
    final now = DateTime.now();
    
    return [
      GovernmentScheme(
        id: 'pm_kisan',
        name: 'PM-KISAN',
        schemeNameLocal: 'प्रधानमंत्री किसान सम्मान निधि / పిఎమ్ కిసాన్',
        description: 'Direct income support of ₹6000 per year in 3 equal installments of ₹2000 each',
        descriptionLocal: 'प्रति वर्ष ₹6000 की प्रत्यक्ष आय सहायता (3 किस्तों में) / సంవత్సరానికి ₹6000 ప్రత్యక్ష ఆదాయ మద్దతు',
        category: 'pension',
        state: 'All India',
        eligibility: [
          'All farmer families with cultivable land',
          'Land ownership records required',
          'Bank account mandatory'
        ],
        benefits: [
          '₹6000 per year in 3 installments',
          'Direct bank transfer',
          'No middlemen involved'
        ],
        benefitAmount: 6000,
        howToApply: 'Visit nearest Common Service Centre (CSC) or apply online at pmkisan.gov.in',
        applyUrl: 'https://pmkisan.gov.in',
        deadline: DateTime(now.year, 12, 31),
        imageUrl: '',
        isActive: true,
        iconName: '💰',
        documents: ['Aadhaar Card', 'Land Records', 'Bank Account Details', 'Mobile Number'],
      ),
      GovernmentScheme(
        id: 'pmfby',
        name: 'PMFBY - Crop Insurance',
        schemeNameLocal: 'फसल बीमा योजना / పంట బీమా',
        description: 'Comprehensive crop insurance coverage up to ₹2 lakh for notified crops',
        descriptionLocal: 'सूचीबद्ध फसलों के लिए ₹2 लाख तक का व्यापक फसल बीमा / ప్రకటించిన పంటలకు ₹2 లక్షల వరకు సమగ్ర పంట బీమా',
        category: 'insurance',
        state: 'All India',
        eligibility: [
          'All farmers growing notified crops',
          'Must register within 7 days of sowing',
          'Land records required'
        ],
        benefits: [
          'Up to ₹2 lakh coverage per crop',
          'Protection against natural calamities',
          'Affordable premium rates'
        ],
        benefitAmount: 200000,
        howToApply: 'Register within 7 days of sowing at nearest bank or online at pmfby.gov.in',
        applyUrl: 'https://pmfby.gov.in',
        deadline: DateTime(now.year, now.month + 1, 15),
        imageUrl: '',
        isActive: true,
        iconName: '🛡️',
        documents: ['Aadhaar Card', 'Land Records', 'Sowing Certificate', 'Bank Account'],
      ),
      GovernmentScheme(
        id: 'rythu_bharosa',
        name: 'Rythu Bharosa',
        schemeNameLocal: 'రైతు భరోసా',
        description: 'Financial assistance of ₹5000 per acre per season for Telangana farmers',
        descriptionLocal: 'తెలంగాణ రైతులకు సీజన్కు ఎకరాకు ₹5000 ఆర్థిక సహాయం',
        category: 'pension',
        state: 'Telangana',
        eligibility: [
          'Farmers in Telangana with valid land records',
          'Must be cultivating crops',
          'Bank account linked to Aadhaar'
        ],
        benefits: [
          '₹5000 per acre per season',
          'Direct credit to bank account',
          'Rabi and Kharif seasons covered'
        ],
        benefitAmount: 5000,
        howToApply: 'Auto credit to registered farmers with land records. No separate application needed.',
        applyUrl: 'https://rythubandhu.telangana.gov.in',
        deadline: DateTime(now.year, 12, 31),
        imageUrl: '',
        isActive: true,
        iconName: '🌾',
        documents: ['Land Records (Pahani)', 'Bank Account Details', 'Aadhaar Card'],
      ),
      GovernmentScheme(
        id: 'kisan_credit_card',
        name: 'Kisan Credit Card',
        schemeNameLocal: 'किसान क्रेडिट कार्ड / రైతు క్రెడిట్ కార్డ్',
        description: 'Credit facility up to ₹3 lakh at 4% interest per annum for farming expenses',
        descriptionLocal: 'कृषि व्यय के लिए 4% ब्याज दर पर ₹3 लाख तक की क्रेडिट सुविधा / వ్యవసాయ ఖర్చులకు సంవత్సరానికి 4% వడ్డీ రేటుతో ₹3 లక్షల వరకు క్రెడిట్ సౌకర్యం',
        category: 'loan',
        state: 'All India',
        eligibility: [
          'Farmers with cultivable land',
          'Tenant farmers eligible',
          'Minimum 1 acre land'
        ],
        benefits: [
          'Credit up to ₹3 lakh',
          '4% interest per annum',
          'Flexible repayment options'
        ],
        benefitAmount: 300000,
        howToApply: 'Apply at nearest bank branch with land records and identity proof',
        applyUrl: 'https://www.nabard.org',
        deadline: DateTime(now.year, 12, 31),
        imageUrl: '',
        isActive: true,
        iconName: '💳',
        documents: ['Land Records', 'Identity Proof', 'Bank Account', 'Aadhaar Card'],
      ),
      GovernmentScheme(
        id: 'msp',
        name: 'Minimum Support Price',
        schemeNameLocal: 'न्यूनतम समर्थन मूल्य / కనిష్ట మద్దతు ధర',
        description: 'Government guaranteed minimum price for 23 notified crops',
        descriptionLocal: '23 सूचीबद्ध फसलों के लिए सरकारी गारंटीकृत न्यूनतम मूल्य / 23 ప్రకటించిన పంటలకు ప్రభుత్వ గ్యారెంటీ ఇచ్చిన కనిష్ట ధర',
        category: 'price_support',
        state: 'All India',
        eligibility: [
          'Farmers growing notified crops',
          'Must sell at designated APMC',
          'Crop must meet quality standards'
        ],
        benefits: [
          'Guaranteed minimum price',
          'Protection against price fall',
          'Timely payment assured'
        ],
        benefitAmount: 0,
        howToApply: 'Sell your produce at nearest APMC market. MSP is automatically applied.',
        applyUrl: 'https://agricoop.gov.in',
        deadline: DateTime(now.year + 1, 12, 31),
        imageUrl: '',
        isActive: true,
        iconName: '📊',
        documents: ['Land Records', 'Crop Details', 'Identity Proof'],
      ),
      GovernmentScheme(
        id: 'seed_subsidy',
        name: 'Seed Subsidy Scheme',
        schemeNameLocal: 'बीज सब्सिडी योजना / విత్తనం సబ్సిడీ',
        description: '50% subsidy on certified seeds for various crops',
        descriptionLocal: 'विभिन्न फसलों के लिए प्रमाणित बीजों पर 50% सब्सिडी / వివిధ పంటలకు ధృవీకరించబడిన విత్తనాలపై 50% సబ్సిడీ',
        category: 'subsidy',
        state: 'All India',
        eligibility: [
          'All registered farmers',
          'Must purchase from authorized dealers',
          'Land records required'
        ],
        benefits: [
          '50% subsidy on seed cost',
          'Quality certified seeds',
          'Available for 20+ crops'
        ],
        benefitAmount: 5000,
        howToApply: 'Purchase seeds from authorized dealers and show your land records',
        applyUrl: '',
        deadline: DateTime(now.year, 12, 31),
        imageUrl: '',
        isActive: true,
        iconName: '🌱',
        documents: ['Land Records', 'Aadhaar Card', 'Bank Account'],
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
        title: 'PM-KISAN Payment Received! 🎉',
        message: '₹2000 credited to your account (XXXX1234) for Kharif 2025 installment',
        notificationDate: now.subtract(const Duration(hours: 2)),
        isRead: false,
        type: 'approved',
      ),
      SchemeNotification(
        id: 'notif_2',
        schemeId: 'pmfby',
        title: 'Crop Insurance Reminder ⏰',
        message: 'Last 3 days to register for Rabi crop insurance. Register now!',
        notificationDate: now.subtract(const Duration(days: 1)),
        isRead: false,
        type: 'reminder',
      ),
      SchemeNotification(
        id: 'notif_3',
        schemeId: 'rythu_bharosa',
        title: 'Rythu Bharosa Payment Confirmed 💰',
        message: '₹5000 per acre will be credited to your account by 15th November 2025',
        notificationDate: now.subtract(const Duration(days: 3)),
        isRead: false,
        type: 'approved',
      ),
      SchemeNotification(
        id: 'notif_4',
        schemeId: 'msp',
        title: 'New MSP Announced 📊',
        message: 'Minimum Support Price for Cotton increased to ₹6100 per quintal',
        notificationDate: now.subtract(const Duration(days: 5)),
        isRead: false,
        type: 'new',
      ),
      SchemeNotification(
        id: 'notif_5',
        schemeId: 'seed_subsidy',
        title: 'Seed Subsidy Available 🌱',
        message: '50% subsidy on certified seeds now available. Visit authorized dealers!',
        notificationDate: now.subtract(const Duration(days: 7)),
        isRead: true,
        type: 'new',
      ),
      SchemeNotification(
        id: 'notif_6',
        schemeId: 'kisan_credit_card',
        title: 'Kisan Credit Card Renewal 🔄',
        message: 'Your KCC expires in 30 days. Renew at nearest bank branch',
        notificationDate: now.subtract(const Duration(days: 10)),
        isRead: true,
        type: 'reminder',
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
