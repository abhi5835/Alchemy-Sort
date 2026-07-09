import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/game_analytics_events_table.dart';
import '../../../../game/analytics/game_analytics_event.dart';

part 'game_analytics_dao.g.dart';

@DriftAccessor(tables: [GameAnalyticsEvents])
class GameAnalyticsDao extends DatabaseAccessor<AppDatabase>
    with _$GameAnalyticsDaoMixin {
  GameAnalyticsDao(super.db);

  Future<void> insertEvent({
    required String sessionId,
    required GameAnalyticsEventType eventType,
    required int levelIndex,
    required int levelNumber,
    int? moveCount,
    int? undoCount,
    int? restartCount,
    int? durationMs,
    int? stars,
    int? highestCombo,
    String? potionId,
    String? metadataJson,
  }) async {
    await into(gameAnalyticsEvents).insert(
      GameAnalyticsEventsCompanion.insert(
        sessionId: sessionId,
        eventType: eventType.index,
        levelIndex: levelIndex,
        levelNumber: levelNumber,
        eventTimestamp: DateTime.now(),
        moveCount: Value(moveCount),
        undoCount: Value(undoCount),
        restartCount: Value(restartCount),
        durationMs: Value(durationMs),
        stars: Value(stars),
        highestCombo: Value(highestCombo),
        potionId: Value(potionId),
        metadataJson: Value(metadataJson),
      ),
    );
  }

  Future<List<GameAnalyticsEvent>> getEvents() async {
    return select(gameAnalyticsEvents).get();
  }

  Future<List<GameAnalyticsEvent>> getEventsForLevel(int levelNumber) async {
    return (select(
      gameAnalyticsEvents,
    )..where((t) => t.levelNumber.equals(levelNumber))).get();
  }

  Future<int> countEventsByType(GameAnalyticsEventType type) async {
    final countExp = gameAnalyticsEvents.id.count();
    final query = selectOnly(gameAnalyticsEvents)
      ..addColumns([countExp])
      ..where(gameAnalyticsEvents.eventType.equals(type.index));
    return await query.map((row) => row.read(countExp)).getSingle() ?? 0;
  }

  Future<void> deleteEventsOlderThan(DateTime cutoff) async {
    await (delete(
      gameAnalyticsEvents,
    )..where((t) => t.eventTimestamp.isSmallerThanValue(cutoff))).go();
  }
}
