import 'package:drift/drift.dart';

class PlayerProgress extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get highestUnlockedLevelIndex =>
      integer().withDefault(const Constant(0))();
  IntColumn get totalScore => integer().withDefault(const Constant(0))();
  IntColumn get totalAlchemistXp => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
