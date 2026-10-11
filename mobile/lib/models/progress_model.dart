class ProgressData {
  final int streakDays;
  final List<bool> weeklyStreak; // 7 booleans [Mon-Sun]
  final int currentLevel;
  final int monthlyXp;
  final int targetXp;
  final int conceptsMastered;
  final double quizAccuracy;
  final double totalReadHours;
  final int globalRank;
  final List<double> weeklyActivity; // 7 height factors (0.0 to 1.0)
  final List<BadgeItem> badges;

  ProgressData({
    required this.streakDays,
    required this.weeklyStreak,
    required this.currentLevel,
    required this.monthlyXp,
    required this.targetXp,
    required this.conceptsMastered,
    required this.quizAccuracy,
    required this.totalReadHours,
    required this.globalRank,
    required this.weeklyActivity,
    required this.badges,
  });

  factory ProgressData.fromJson(Map<String, dynamic> json) {
    return ProgressData(
      streakDays: json['streak_days'] ?? 0,
      weeklyStreak: List<bool>.from(
        json['weekly_streak'] ?? List.filled(7, false),
      ),
      currentLevel: json['current_level'] ?? 1,
      monthlyXp: json['monthly_xp'] ?? 0,
      targetXp: json['target_xp'] ?? 2000,
      conceptsMastered: json['concepts_mastered'] ?? 0,
      quizAccuracy: (json['quiz_accuracy'] ?? 0.0).toDouble(),
      totalReadHours: (json['total_read_hours'] ?? 0.0).toDouble(),
      globalRank: json['global_rank'] ?? 0,
      weeklyActivity:
          (json['weekly_activity'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          List.filled(7, 0.0),
      badges:
          (json['badges'] as List<dynamic>?)
              ?.map((b) => BadgeItem.fromJson(b))
              .toList() ??
          [],
    );
  }
}

class BadgeItem {
  final String label;
  final String icon;

  BadgeItem({required this.label, required this.icon});

  factory BadgeItem.fromJson(Map<String, dynamic> json) {
    return BadgeItem(label: json['label'] ?? '', icon: json['icon'] ?? '🏆');
  }
}
