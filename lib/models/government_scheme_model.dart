class GovernmentScheme {
  final String id;
  final String name;
  final String schemeName; // Alias
  final String schemeNameLocal;
  final String description;
  final String descriptionLocal;
  final String category;
  final String state;
  final List<String> eligibility;
  final List<String> benefits;
  final double benefitAmount;
  final String howToApply;
  final List<String> documents;
  final String applyUrl;
  final DateTime deadline;
  final String imageUrl;
  final bool isActive;
  final String iconName;

  GovernmentScheme({
    required this.id,
    required this.name,
    required this.schemeNameLocal,
    required this.description,
    required this.descriptionLocal,
    required this.category,
    required this.state,
    required this.eligibility,
    required this.benefits,
    required this.benefitAmount,
    required this.howToApply,
    required this.documents,
    required this.applyUrl,
    required this.deadline,
    required this.imageUrl,
    required this.isActive,
    required this.iconName,
  }) : schemeName = name;

  factory GovernmentScheme.fromJson(Map<String, dynamic> json) {
    return GovernmentScheme(
      id: json['id'] ?? '',
      name: json['name'] ?? json['schemeName'] ?? '',
      schemeNameLocal: json['schemeNameLocal'] ?? '',
      description: json['description'] ?? '',
      descriptionLocal: json['descriptionLocal'] ?? '',
      category: json['category'] ?? '',
      state: json['state'] ?? 'All India',
      eligibility: List<String>.from(json['eligibility'] ?? []),
      benefits: List<String>.from(json['benefits'] ?? []),
      benefitAmount: (json['benefitAmount'] ?? 0).toDouble(),
      howToApply: json['howToApply'] ?? '',
      documents: List<String>.from(json['documents'] ?? []),
      applyUrl: json['applyUrl'] ?? '',
      deadline: json['deadline'] != null 
          ? DateTime.parse(json['deadline'])
          : DateTime.now().add(const Duration(days: 30)),
      imageUrl: json['imageUrl'] ?? '',
      isActive: json['isActive'] ?? true,
      iconName: json['iconName'] ?? '📋',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'schemeNameLocal': schemeNameLocal,
      'description': description,
      'descriptionLocal': descriptionLocal,
      'category': category,
      'state': state,
      'eligibility': eligibility,
      'benefits': benefits,
      'benefitAmount': benefitAmount,
      'howToApply': howToApply,
      'documents': documents,
      'applyUrl': applyUrl,
      'deadline': deadline.toIso8601String(),
      'imageUrl': imageUrl,
      'isActive': isActive,
      'iconName': iconName,
    };
  }
}

class SchemeNotification {
  final String id;
  final String schemeId;
  final String title;
  final String message;
  final DateTime notificationDate;
  final bool isRead;
  final String type; // new, reminder, approved, rejected

  SchemeNotification({
    required this.id,
    required this.schemeId,
    required this.title,
    required this.message,
    required this.notificationDate,
    required this.isRead,
    required this.type,
  });

  factory SchemeNotification.fromJson(Map<String, dynamic> json) {
    return SchemeNotification(
      id: json['id'] ?? '',
      schemeId: json['schemeId'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      notificationDate: json['notificationDate'] != null
          ? DateTime.parse(json['notificationDate'])
          : DateTime.now(),
      isRead: json['isRead'] ?? false,
      type: json['type'] ?? 'new',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'schemeId': schemeId,
      'title': title,
      'message': message,
      'notificationDate': notificationDate.toIso8601String(),
      'isRead': isRead,
      'type': type,
    };
  }
}
