import 'potion_definition.dart';
import 'level_session_stats.dart';

class LevelCompletionResult {
  final int completedLevelIndex;
  final int completedLevelNumber;
  final int finalScore;
  final int stars;
  final LevelSessionStats sessionStats;
  final PotionDefinition? newlyDiscoveredPotion;
  final bool nextLevelAvailable;

  const LevelCompletionResult({
    required this.completedLevelIndex,
    required this.completedLevelNumber,
    required this.finalScore,
    required this.stars,
    required this.sessionStats,
    this.newlyDiscoveredPotion,
    required this.nextLevelAvailable,
  });
}
