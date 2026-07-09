import '../../data/local/database/app_database.dart';
import 'daily_date_key.dart';

class DailyStreakPolicy {
  /// Calculates the current and longest streak purely from the completed DailyAlchemyRecords.
  ///
  /// The [completedRecords] must be sorted in descending order (newest first).
  /// Missed days break the streak.
  static ({int currentStreak, int longestStreak}) calculateStreaks(
    List<DailyAlchemyRecordData> completedRecords,
    DateTime today,
  ) {
    if (completedRecords.isEmpty) {
      return (currentStreak: 0, longestStreak: 0);
    }

    final todayKey = getDailyDateKey(today);
    final yesterdayKey = getDailyDateKey(
      today.subtract(const Duration(days: 1)),
    );

    // Sort descending by dateKey (which naturally sorts chronologically)
    final sorted = List<DailyAlchemyRecordData>.from(completedRecords)
      ..sort((a, b) => b.dateKey.compareTo(a.dateKey));

    int currentStreak = 0;
    int longestStreak = 0;
    int tempStreak = 0;
    DateTime? previousDate;

    // Process from newest to oldest
    for (int i = 0; i < sorted.length; i++) {
      final record = sorted[i];
      final recordDate = DateTime.parse(record.dateKey);

      if (i == 0) {
        tempStreak = 1;

        // If the newest record is neither today nor yesterday, the current streak is broken
        if (record.dateKey == todayKey || record.dateKey == yesterdayKey) {
          currentStreak = 1;
        }
      } else {
        // Ensure they are exactly 1 local day apart
        final expectedPreviousDate = previousDate!.subtract(
          const Duration(days: 1),
        );

        if (record.dateKey == getDailyDateKey(expectedPreviousDate)) {
          tempStreak++;

          // Only increment current streak if the chain hasn't broken from today/yesterday
          if (currentStreak > 0 && currentStreak == i) {
            currentStreak++;
          }
        } else {
          // Chain broken
          tempStreak = 1;
        }
      }

      if (tempStreak > longestStreak) {
        longestStreak = tempStreak;
      }

      previousDate = recordDate;
    }

    return (currentStreak: currentStreak, longestStreak: longestStreak);
  }
}
