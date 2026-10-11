import 'package:flutter_test/flutter_test.dart';

class StreakCalculator {
  static const Duration minDelay = Duration(seconds: 5);

  bool canMarkComplete(DateTime? lastCompletedAt, DateTime now) {
    if (lastCompletedAt == null) return true;
    return now.difference(lastCompletedAt) >= minDelay;
  }

  int calculateStreak({
    required int currentStreak,
    required DateTime? lastCompletedAt,
    required DateTime now,
  }) {
    if (lastCompletedAt == null) return 1;

    final lastCompletedDate = DateTime(
      lastCompletedAt.year,
      lastCompletedAt.month,
      lastCompletedAt.day,
    );
    final currentDate = DateTime(now.year, now.month, now.day);
    final daysDifference = currentDate.difference(lastCompletedDate).inDays;

    if (daysDifference == 0) {
      return currentStreak; // Already completed today
    } else if (daysDifference == 1) {
      return currentStreak + 1; // Consecutive day streak
    } else {
      return 1; // Missed a day or more; reset streak
    }
  }
}

void main() {
  group('Streak & Timer Logic Tests', () {
    late StreakCalculator calculator;

    setUp(() {
      calculator = StreakCalculator();
    });

    test('Allows completion if no previous completion exists', () {
      final now = DateTime.now();
      expect(calculator.canMarkComplete(null, now), isTrue);
    });

    test('Blocks completion if 5-second delay has not passed', () {
      final lastCompleted = DateTime(2026, 8, 22, 10, 0, 0);
      final attemptAt = DateTime(2026, 8, 22, 10, 0, 3); // 3 seconds later

      expect(calculator.canMarkComplete(lastCompleted, attemptAt), isFalse);
    });

    test('Allows completion after 5-second delay timer expires', () {
      final lastCompleted = DateTime(2026, 8, 22, 10, 0, 0);
      final attemptAt = DateTime(2026, 8, 22, 10, 0, 6); // 6 seconds later

      expect(calculator.canMarkComplete(lastCompleted, attemptAt), isTrue);
    });

    test('Increments streak on consecutive calendar day', () {
      final lastCompleted = DateTime(2026, 8, 21, 14, 0);
      final now = DateTime(2026, 8, 22, 15, 0);

      final streak = calculator.calculateStreak(
        currentStreak: 3,
        lastCompletedAt: lastCompleted,
        now: now,
      );

      expect(streak, equals(4));
    });

    test('Resets streak to 1 if more than a day is missed', () {
      final lastCompleted = DateTime(2026, 8, 19, 10, 0);
      final now = DateTime(2026, 8, 22, 10, 0); // 3 days later

      final streak = calculator.calculateStreak(
        currentStreak: 5,
        lastCompletedAt: lastCompleted,
        now: now,
      );

      expect(streak, equals(1));
    });
  });
}
