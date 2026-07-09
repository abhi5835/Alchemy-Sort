import 'package:drift/drift.dart';

enum DailyChallengeStatus {
  notStarted,
  inProgress,
  completed,
}

@DataClassName('DailyAlchemyRecordData')
class DailyAlchemyRecords extends Table {
  TextColumn get dateKey => text()();
  IntColumn get sourceLevelIndex => integer()();
  
  // Use text for status to be immune to enum reordering
  TextColumn get status => text().map(const EnumNameConverter(DailyChallengeStatus.values))();
  
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
  
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get bestMoveCount => integer().nullable()();
  IntColumn get bestDurationMs => integer().nullable()();
  IntColumn get bestStars => integer().nullable()();
  
  BoolColumn get rewardClaimed => boolean().withDefault(const Constant(false))();
  IntColumn get xpReward => integer().withDefault(const Constant(0))();
  
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {dateKey};
}
