class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? photoUrl;
  final String? farmLocation;
  final double? farmSize; // in acres
  final List<String> crops;
  final String language;
  final DateTime createdAt;
  final DateTime lastSync;
  final Map<String, dynamic> preferences;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.photoUrl,
    this.farmLocation,
    this.farmSize,
    this.crops = const [],
    required this.language,
    required this.createdAt,
    required this.lastSync,
    this.preferences = const {},
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      photoUrl: json['photoUrl'] as String?,
      farmLocation: json['farmLocation'] as String?,
      farmSize: json['farmSize'] != null ? (json['farmSize'] as num).toDouble() : null,
      crops: json['crops'] != null ? List<String>.from(json['crops'] as List) : [],
      language: json['language'] as String? ?? 'en',
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastSync: DateTime.parse(json['lastSync'] as String),
      preferences: json['preferences'] != null 
          ? Map<String, dynamic>.from(json['preferences'] as Map) 
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'farmLocation': farmLocation,
      'farmSize': farmSize,
      'crops': crops,
      'language': language,
      'createdAt': createdAt.toIso8601String(),
      'lastSync': lastSync.toIso8601String(),
      'preferences': preferences,
    };
  }

  UserProfile copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? photoUrl,
    String? farmLocation,
    double? farmSize,
    List<String>? crops,
    String? language,
    DateTime? lastSync,
    Map<String, dynamic>? preferences,
  }) {
    return UserProfile(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      farmLocation: farmLocation ?? this.farmLocation,
      farmSize: farmSize ?? this.farmSize,
      crops: crops ?? this.crops,
      language: language ?? this.language,
      createdAt: createdAt,
      lastSync: lastSync ?? this.lastSync,
      preferences: preferences ?? this.preferences,
    );
  }
}
