class UserReward {
  final String userId;
  final int totalPoints;
  final int level;
  final String rank; // Beginner, Farmer, Expert, Master
  final List<Achievement> achievements;
  final Map<String, int> activityPoints; // taskCompleted: 50, postCreated: 20, etc.

  UserReward({
    required this.userId,
    required this.totalPoints,
    required this.level,
    required this.rank,
    required this.achievements,
    required this.activityPoints,
  });

  factory UserReward.fromJson(Map<String, dynamic> json) {
    return UserReward(
      userId: json['userId'] as String,
      totalPoints: json['totalPoints'] as int,
      level: json['level'] as int,
      rank: json['rank'] as String,
      achievements: (json['achievements'] as List)
          .map((a) => Achievement.fromJson(a as Map<String, dynamic>))
          .toList(),
      activityPoints: Map<String, int>.from(json['activityPoints'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'totalPoints': totalPoints,
      'level': level,
      'rank': rank,
      'achievements': achievements.map((a) => a.toJson()).toList(),
      'activityPoints': activityPoints,
    };
  }
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int pointsRequired;
  final DateTime? unlockedAt;
  final bool isUnlocked;
  final String category; // Tasks, Community, Learning, Farming

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.pointsRequired,
    this.unlockedAt,
    this.isUnlocked = false,
    required this.category,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      pointsRequired: json['pointsRequired'] as int,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'pointsRequired': pointsRequired,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'isUnlocked': isUnlocked,
      'category': category,
    };
  }
}

class LeaderboardEntry {
  final String userId;
  final String userName;
  final String? avatarUrl;
  final int totalPoints;
  final int rank;
  final String level;
  final String location;

  LeaderboardEntry({
    required this.userId,
    required this.userName,
    this.avatarUrl,
    required this.totalPoints,
    required this.rank,
    required this.level,
    required this.location,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      totalPoints: json['totalPoints'] as int,
      rank: json['rank'] as int,
      level: json['level'] as String,
      location: json['location'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'avatarUrl': avatarUrl,
      'totalPoints': totalPoints,
      'rank': rank,
      'level': level,
      'location': location,
    };
  }
}
