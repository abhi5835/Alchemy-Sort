import 'package:drift/drift.dart';

class DiscoveredPotions extends Table {
  TextColumn get potionId => text()();
  DateTimeColumn get discoveredAt =>
      dateTime().withDefault(currentDateAndTime)();
  IntColumn get discoveredLevelNumber => integer()();

  @override
  Set<Column> get primaryKey => {potionId};
}
