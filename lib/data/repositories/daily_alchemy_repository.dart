import '../../game/daily/daily_challenge_generator.dart';
import '../../game/daily/daily_date_key.dart';
import '../../game/daily/daily_reward_policy.dart';
import '../../game/daily/daily_streak_policy.dart';
import '../../game/models/daily_completion_result.dart';
import '../local/database/app_database.dart';
import '../local/database/tables/daily_alchemy_records_table.dart';

class DailyAlchemyRepository {
  final AppDatabase _db;

  DailyAlchemyRepository(this._db);

  /// Resolves today's challenge deterministically and ensures it exists in the database.
  Future<DailyChallenge> resolveTodayChallenge() async {
    final today = DateTime.now();
    final challenge = DailyChallengeGenerator.generate(today);
    await _db.dailyAlchemyDao.ensureRecord(challenge: challenge);
    return challenge;
  }

  /// Exposes the daily challenge status stream for UI updates.
  Stream<DailyAlchemyRecordData?> watchDailyRecord(String dateKey) {
    return _db.dailyAlchemyDao.watchByDateKey(dateKey);
  }

  /// Begins a new attempt for the daily challenge.
  Future<void> startAttempt(String dateKey) async {
    await _db.dailyAlchemyDao.startAttempt(dateKey);
  }

  /// Atomically commits a daily completion and grants the XP reward if eligible.
  Future<DailyCompletionResult> commitDailyCompletion({
    required String dateKey,
    required int moveCount,
    required int durationMs,
    required int stars,
    required int highestCombo,
    required bool isPractice,
  }) async {
    return await _db.transaction(() async {
      // 1. Fetch current status
      final record = await _db.dailyAlchemyDao.getByDateKey(dateKey);
      if (record == null)
        throw Exception('Daily record not found for $dateKey');

      final firstCompletion = record.status != DailyChallengeStatus.completed;

      // Practice logic
      if (isPractice || !firstCompletion) {
        // Just update stats without granting rewards
        await _db.dailyAlchemyDao.commitCompletion(
          dateKey: dateKey,
          moveCount: moveCount,
          durationMs: durationMs,
          stars: stars,
          xpReward: record.xpReward,
        );

        // Fetch streak just for display
        final completedRecords = await _db.dailyAlchemyDao
            .getCompletedRecords();
        final streaks = DailyStreakPolicy.calculateStreaks(
          completedRecords,
          DateTime.now(),
        );

        return DailyCompletionResult(
          dateKey: dateKey,
          stars: stars,
          moveCount: moveCount,
          durationMs: durationMs,
          highestCombo: highestCombo,
          previousStreak: streaks.currentStreak, // no change
          currentStreak: streaks.currentStreak,
          longestStreak: streaks.longestStreak,
          reward: const DailyRewardResult(
            baseXp: 0,
            starBonusXp: 0,
            streakBonusXp: 0,
          ), // 0 XP for practice
          firstCompletion: false,
          rewardGranted: false,
        );
      }

      // 2. Fetch completed records to calculate previous streak
      final completedRecords = await _db.dailyAlchemyDao.getCompletedRecords();
      final streaksBefore = DailyStreakPolicy.calculateStreaks(
        completedRecords,
        DateTime.now(),
      );

      // Simulate appending today's completion for the new streak
      final newStreak = streaksBefore.currentStreak + 1;
      final newLongestStreak = newStreak > streaksBefore.longestStreak
          ? newStreak
          : streaksBefore.longestStreak;

      // 3. Calculate reward
      final reward = DailyRewardPolicy.calculateReward(
        stars: stars,
        newStreak: newStreak,
      );

      // 4. Commit Completion
      await _db.dailyAlchemyDao.commitCompletion(
        dateKey: dateKey,
        moveCount: moveCount,
        durationMs: durationMs,
        stars: stars,
        xpReward: reward.totalXp,
      );

      // 5. Grant XP
      bool rewardGranted = false;
      if (!record.rewardClaimed) {
        final claimed = await _db.dailyAlchemyDao.claimReward(dateKey);
        if (claimed) {
          final progress = await _db.playerProgressDao.getProgress();
          final newXp = progress.totalAlchemistXp + reward.totalXp;
          await _db.playerProgressDao.updateXp(newXp);
          rewardGranted = true;
        }
      }

      return DailyCompletionResult(
        dateKey: dateKey,
        stars: stars,
        moveCount: moveCount,
        durationMs: durationMs,
        highestCombo: highestCombo,
        previousStreak: streaksBefore.currentStreak,
        currentStreak: newStreak,
        longestStreak: newLongestStreak,
        reward: reward,
        firstCompletion: true,
        rewardGranted: rewardGranted,
      );
    });
  }
}
