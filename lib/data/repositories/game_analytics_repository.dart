import '../../game/analytics/game_analytics_event.dart';
import '../local/database/app_database.dart';

class LevelAnalyticsSummary {
  final int levelNumber;
  final int starts;
  final int completions;
  final int exits;
  final int restarts;
  final int averageDurationMs;
  final int averageMoveCount;
  final int averageUndoCount;

  LevelAnalyticsSummary({
    required this.levelNumber,
    required this.starts,
    required this.completions,
    required this.exits,
    required this.restarts,
    required this.averageDurationMs,
    required this.averageMoveCount,
    required this.averageUndoCount,
  });
}

class GameAnalyticsRepository {
  final AppDatabase database;

  GameAnalyticsRepository(this.database);

  Future<int> getTotalLevelStarts() async {
    return database.gameAnalyticsDao.countEventsByType(
      GameAnalyticsEventType.levelStarted,
    );
  }

  Future<int> getTotalLevelCompletions() async {
    return database.gameAnalyticsDao.countEventsByType(
      GameAnalyticsEventType.levelCompleted,
    );
  }

  Future<double> getCompletionRate() async {
    final starts = await getTotalLevelStarts();
    if (starts == 0) return 0.0;
    final completions = await getTotalLevelCompletions();
    return completions / starts;
  }

  Future<LevelAnalyticsSummary> getLevelSummary(int levelNumber) async {
    final events = await database.gameAnalyticsDao.getEventsForLevel(
      levelNumber,
    );

    int starts = 0;
    int completions = 0;
    int exits = 0;
    int restarts = 0;

    int totalDurationMs = 0;
    int totalMoveCount = 0;
    int totalUndoCount = 0;

    for (final event in events) {
      if (event.eventType == GameAnalyticsEventType.levelStarted.index) {
        starts++;
      } else if (event.eventType ==
          GameAnalyticsEventType.levelCompleted.index) {
        completions++;
        totalDurationMs += event.durationMs ?? 0;
        totalMoveCount += event.moveCount ?? 0;
        totalUndoCount += event.undoCount ?? 0;
      } else if (event.eventType == GameAnalyticsEventType.levelExited.index) {
        exits++;
      } else if (event.eventType ==
          GameAnalyticsEventType.levelRestarted.index) {
        restarts++;
      }
    }

    return LevelAnalyticsSummary(
      levelNumber: levelNumber,
      starts: starts,
      completions: completions,
      exits: exits,
      restarts: restarts,
      averageDurationMs: completions > 0
          ? (totalDurationMs / completions).round()
          : 0,
      averageMoveCount: completions > 0
          ? (totalMoveCount / completions).round()
          : 0,
      averageUndoCount: completions > 0
          ? (totalUndoCount / completions).round()
          : 0,
    );
  }

  Future<int> getCompletionContinuedCount() async {
    return database.gameAnalyticsDao.countEventsByType(
      GameAnalyticsEventType.completionContinued,
    );
  }

  Future<int> getCompletionMapSelectedCount() async {
    return database.gameAnalyticsDao.countEventsByType(
      GameAnalyticsEventType.completionMapSelected,
    );
  }
}
