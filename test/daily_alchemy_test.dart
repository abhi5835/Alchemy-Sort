import 'package:flutter_test/flutter_test.dart';
import 'package:alchemy_sort/game/daily/daily_date_key.dart';
import 'package:alchemy_sort/game/daily/daily_challenge_generator.dart';
import 'package:alchemy_sort/game/daily/daily_reward_policy.dart';
import 'package:alchemy_sort/game/daily/daily_streak_policy.dart';
import 'package:alchemy_sort/data/local/database/app_database.dart';
import 'package:alchemy_sort/data/local/database/tables/daily_alchemy_records_table.dart';

void main() {
  group('Daily Date Key Tests', () {
    test('1. Same local day produces same date key', () {
      final date1 = DateTime(2026, 7, 9, 10, 0);
      final date2 = DateTime(2026, 7, 9, 23, 59);
      expect(getDailyDateKey(date1), getDailyDateKey(date2));
    });

    test('2. Different day produces different key', () {
      final date1 = DateTime(2026, 7, 9);
      final date2 = DateTime(2026, 7, 10);
      expect(getDailyDateKey(date1), isNot(equals(getDailyDateKey(date2))));
    });

    test('3. Date key is zero padded', () {
      final date = DateTime(2026, 7, 9);
      expect(getDailyDateKey(date), '2026-07-09');
    });

    test('3a. UTC date is converted to local calendar day', () {
      // 2026-07-09 23:00 UTC might be 2026-07-10 04:30 in India
      final utcDate = DateTime.utc(2026, 7, 9, 23, 0);
      final localEquiv = utcDate.toLocal();
      // The key must match the local calendar day, NOT the UTC calendar day
      expect(getDailyDateKey(utcDate), getDailyDateKey(localEquiv));
    });

    test('3b. Near-midnight local time produces same key', () {
      final date1 = DateTime(2026, 7, 9, 0, 5); // 12:05 AM
      final date2 = DateTime(2026, 7, 9, 23, 55); // 11:55 PM
      expect(getDailyDateKey(date1), getDailyDateKey(date2));
      expect(getDailyDateKey(date1), '2026-07-09');
    });
  });

  group('Daily Challenge Generator Tests', () {
    test('4. Same date produces same seed', () {
      final c1 = DailyChallengeGenerator.generate(DateTime(2026, 7, 9, 10, 0));
      final c2 = DailyChallengeGenerator.generate(DateTime(2026, 7, 9, 20, 0));
      expect(c1.seed, c2.seed);
    });

    test('5. Same date produces same source level', () {
      final c1 = DailyChallengeGenerator.generate(DateTime(2026, 7, 9));
      final c2 = DailyChallengeGenerator.generate(DateTime(2026, 7, 9));
      expect(c1.sourceLevelIndex, c2.sourceLevelIndex);
    });

    test('6. Different dates can produce deterministic results', () {
      final c1 = DailyChallengeGenerator.generate(DateTime(2026, 7, 9));
      final c2 = DailyChallengeGenerator.generate(DateTime(2026, 7, 10));
      expect(c1.seed, isNot(equals(c2.seed)));
      // Note: sourceLevelIndex MIGHT randomly be the same, so we don't strictly test that it differs.
    });

    test('7. Source level stays inside safe pool', () {
      for (int i = 0; i < 100; i++) {
        final c = DailyChallengeGenerator.generate(DateTime(2026, 1, 1).add(Duration(days: i)));
        expect(c.sourceLevelIndex >= DailyChallengeGenerator.minSourceLevelIndex, isTrue);
        expect(c.sourceLevelIndex <= DailyChallengeGenerator.maxSourceLevelIndex, isTrue);
      }
    });
  });

  group('Daily Reward Policy Tests', () {
    test('24. Base reward is 150 XP', () {
      final r = DailyRewardPolicy.calculateReward(stars: 0, newStreak: 1);
      expect(r.baseXp, 150);
      expect(r.starBonusXp, 0);
      expect(r.streakBonusXp, 0);
      expect(r.totalXp, 150);
    });

    test('25. Two-star bonus is correct', () {
      final r = DailyRewardPolicy.calculateReward(stars: 2, newStreak: 1);
      expect(r.starBonusXp, 25);
    });

    test('26. Three-star bonus is correct', () {
      final r = DailyRewardPolicy.calculateReward(stars: 3, newStreak: 1);
      expect(r.starBonusXp, 50);
    });

    test('27. Seven-day milestone gives weekly bonus', () {
      final r = DailyRewardPolicy.calculateReward(stars: 3, newStreak: 7);
      expect(r.streakBonusXp, 100);
    });

    test('28. Fourteen-day milestone gives weekly bonus', () {
      final r = DailyRewardPolicy.calculateReward(stars: 3, newStreak: 14);
      expect(r.streakBonusXp, 100);
    });

    test('29. Thirty-day milestone gives monthly bonus', () {
      final r = DailyRewardPolicy.calculateReward(stars: 3, newStreak: 30);
      expect(r.streakBonusXp, 500);
    });

    test('31. Non-milestone gives no streak bonus', () {
      final r = DailyRewardPolicy.calculateReward(stars: 3, newStreak: 8);
      expect(r.streakBonusXp, 0);
    });
  });

  group('Daily Streak Policy Tests', () {
    DailyAlchemyRecordData mockCompletedRecord(DateTime date) {
      return DailyAlchemyRecordData(
        dateKey: getDailyDateKey(date),
        sourceLevelIndex: 10,
        status: DailyChallengeStatus.completed,
        attemptCount: 1,
        rewardClaimed: true,
        xpReward: 200,
        createdAt: date,
        updatedAt: date,
      );
    }

    test('16. No completions gives streak 0', () {
      final streaks = DailyStreakPolicy.calculateStreaks([], DateTime.now());
      expect(streaks.currentStreak, 0);
      expect(streaks.longestStreak, 0);
    });

    test('17. Today completed gives streak 1', () {
      final today = DateTime.now();
      final streaks = DailyStreakPolicy.calculateStreaks([mockCompletedRecord(today)], today);
      expect(streaks.currentStreak, 1);
      expect(streaks.longestStreak, 1);
    });

    test('18. Yesterday completed and today incomplete gives active streak 1', () {
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));
      final streaks = DailyStreakPolicy.calculateStreaks([mockCompletedRecord(yesterday)], today);
      expect(streaks.currentStreak, 1);
      expect(streaks.longestStreak, 1);
    });

    test('19. Two consecutive completed days gives streak 2', () {
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));
      final streaks = DailyStreakPolicy.calculateStreaks([mockCompletedRecord(today), mockCompletedRecord(yesterday)], today);
      expect(streaks.currentStreak, 2);
      expect(streaks.longestStreak, 2);
    });

    test('20. Missed day breaks streak', () {
      final today = DateTime.now();
      // Completed 3 days ago, and 4 days ago
      final day3 = today.subtract(const Duration(days: 3));
      final day4 = today.subtract(const Duration(days: 4));
      
      final streaks = DailyStreakPolicy.calculateStreaks([mockCompletedRecord(day3), mockCompletedRecord(day4)], today);
      expect(streaks.currentStreak, 0); // Broken because yesterday was missed
      expect(streaks.longestStreak, 2); // But longest streak is 2
    });

    test('21. Month boundary remains consecutive', () {
      final today = DateTime(2026, 8, 1); // Aug 1
      final yesterday = DateTime(2026, 7, 31); // Jul 31
      
      final streaks = DailyStreakPolicy.calculateStreaks([mockCompletedRecord(today), mockCompletedRecord(yesterday)], today);
      expect(streaks.currentStreak, 2);
    });
  });
}
