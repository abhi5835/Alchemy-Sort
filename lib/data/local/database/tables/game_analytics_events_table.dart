import 'package:drift/drift.dart';

@TableIndex(name: 'idx_analytics_event_type', columns: {#eventType})
@TableIndex(name: 'idx_analytics_level_number', columns: {#levelNumber})
@TableIndex(name: 'idx_analytics_session_id', columns: {#sessionId})
class GameAnalyticsEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionId => text()();
  IntColumn get eventType => integer()();
  IntColumn get levelIndex => integer()();
  IntColumn get levelNumber => integer()();
  DateTimeColumn get eventTimestamp => dateTime()();

  // Metrics (nullable based on event type)
  IntColumn get moveCount => integer().nullable()();
  IntColumn get undoCount => integer().nullable()();
  IntColumn get restartCount => integer().nullable()();
  IntColumn get durationMs => integer().nullable()();
  IntColumn get stars => integer().nullable()();
  IntColumn get highestCombo => integer().nullable()();
  TextColumn get potionId => text().nullable()();
  TextColumn get metadataJson => text().nullable()();
}
