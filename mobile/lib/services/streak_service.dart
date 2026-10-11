import 'package:shared_preferences/shared_preferences.dart';

// cSpell:ignore prefs
class StreakService {
  static const String _keyStreak = 'user_streak_count';
  static const String _keyLastCompletedDate = 'last_completed_date';
  static const String _keyTodayProgress = 'today_progress_count';

  static String _dateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayStr = _dateKey(today);
    final lastCompletedDate = prefs.getString(_keyLastCompletedDate);

    if (lastCompletedDate != todayStr) {
      return 0;
    }

    return prefs.getInt(_keyStreak) ?? 0;
  }

  static Future<int> getTodayProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month}-${now.day}";
    final lastDateStr = prefs.getString(_keyLastCompletedDate);

    // Reset progress to 0 if a new day has started
    if (lastDateStr != todayStr) {
      return 0;
    }
    return prefs.getInt(_keyTodayProgress) ?? 0;
  }

  static Future<void> completeTodayDose() async {
    final prefs = await SharedPreferences.getInstance();

    final today = _dateOnly(DateTime.now());
    final todayStr = _dateKey(today);

    final lastDateStr = prefs.getString(_keyLastCompletedDate);

    // Already completed today's dose.
    // Do not increase the streak again.
    if (lastDateStr == todayStr) {
      return;
    }

    int currentStreak = prefs.getInt(_keyStreak) ?? 0;

    if (lastDateStr == null) {
      // First ever completion.
      currentStreak = 1;
    } else {
      final lastDate = DateTime.parse(lastDateStr);

      final difference = today.difference(_dateOnly(lastDate)).inDays;

      if (difference == 1) {
        // Completed yesterday → continue streak.
        currentStreak += 1;
      } else {
        // Missed one or more days → restart.
        currentStreak = 1;
      }
    }
    await prefs.setInt(_keyStreak, currentStreak);

    await prefs.setString(_keyLastCompletedDate, todayStr);

    await prefs.setInt(_keyTodayProgress, 1);
  }
}
