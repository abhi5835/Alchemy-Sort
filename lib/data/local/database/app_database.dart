import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/player_progress_table.dart';
import 'tables/discovered_potions_table.dart';
import 'tables/game_analytics_events_table.dart';
import 'tables/daily_alchemy_records_table.dart';
import 'daos/player_progress_dao.dart';
import 'daos/potion_collection_dao.dart';
import 'daos/game_analytics_dao.dart';
import 'daos/daily_alchemy_dao.dart';

part 'app_database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'alchemy_sort.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(
  tables: [
    PlayerProgress,
    DiscoveredPotions,
    GameAnalyticsEvents,
    DailyAlchemyRecords,
  ],
  daos: [
    PlayerProgressDao,
    PotionCollectionDao,
    GameAnalyticsDao,
    DailyAlchemyDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(DatabaseConnection connection) : super(connection);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(gameAnalyticsEvents);
      }
      if (from < 3) {
        await m.createTable(dailyAlchemyRecords);
      }
    },
  );
}
