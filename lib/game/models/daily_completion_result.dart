import '../../game/daily/daily_reward_policy.dart';

class DailyCompletionResult {
  final String dateKey;
  final int stars;
  final int moveCount;
  final int durationMs;
  final int highestCombo;
  final int previousStreak;
  final int currentStreak;
  final int longestStreak;
  final DailyRewardResult reward;
  final bool firstCompletion;
  final bool rewardGranted;

  const DailyCompletionResult({
    required this.dateKey,
    required this.stars,
    required this.moveCount,
    required this.durationMs,
    required this.highestCombo,
    required this.previousStreak,
    required this.currentStreak,
    required this.longestStreak,
    required this.reward,
    required this.firstCompletion,
    required this.rewardGranted,
  });
}
