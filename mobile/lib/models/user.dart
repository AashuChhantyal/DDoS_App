class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final int streakDays;
  final int conceptsMastered;
  final double accuracy;
  final DateTime? lastCompletedAt;
  final int dailyGoal;
  final int dailyProgress;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.streakDays,
    required this.conceptsMastered,
    required this.accuracy,
    this.lastCompletedAt,
    this.dailyGoal = 1,
    this.dailyProgress = 0,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    int? streakDays,
    int? conceptsMastered,
    double? accuracy,
    DateTime? lastCompletedAt,
    int? dailyGoal,
    int? dailyProgress,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      streakDays: streakDays ?? this.streakDays,
      conceptsMastered: conceptsMastered ?? this.conceptsMastered,
      accuracy: accuracy ?? this.accuracy,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      dailyProgress: dailyProgress ?? this.dailyProgress,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      streakDays: _parseInt(json['streakDays'] ?? json['streak_days']),
      conceptsMastered: _parseInt(
        json['conceptsMastered'] ?? json['concepts_mastered'],
      ),
      accuracy: _parseDouble(json['accuracy']),
      lastCompletedAt: json['lastCompletedAt'] != null
          ? DateTime.tryParse(json['lastCompletedAt'].toString())
          : null,
      dailyGoal: _parseInt(json['dailyGoal'] ?? 1),
      dailyProgress: _parseInt(json['dailyProgress'] ?? 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'streakDays': streakDays,
      'conceptsMastered': conceptsMastered,
      'accuracy': accuracy,
      'lastCompletedAt': lastCompletedAt?.toIso8601String(),
      'dailyGoal': dailyGoal,
      'dailyProgress': dailyProgress,
    };
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
