import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:alchemy_sort/data/local/database/app_database.dart';
import 'package:alchemy_sort/data/local/migrations/legacy_preferences_migration.dart';

void main() {
  late AppDatabase database;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    database = AppDatabase.forTesting(
      DatabaseConnection(NativeDatabase.memory()),
    );
  });

  tearDown(() async {
    await database.close();
  });

  group('LegacyPreferencesMigration Tests', () {
    test('1. Fresh install creates default Drift state', () async {
      SharedPreferences.setMockInitialValues({});
      await LegacyPreferencesMigration.runMigration(database);

      final progress = await database.playerProgressDao.getProgress();
      expect(progress.highestUnlockedLevelIndex, 0);
      expect(progress.totalScore, 0);

      final count = await database.potionCollectionDao.getDiscoveredCount();
      expect(count, 0);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('legacy_drift_migration_version'), 1);
    });

    test(
      '2-5. Legacy Level 5 progress, score, and potions migrate correctly',
      () async {
        final legacyPotions = jsonEncode(['ember_essence', 'frost_elixir']);
        SharedPreferences.setMockInitialValues({
          'unlocked_level': 5,
          'score': 2000,
          'discovered_potions': legacyPotions,
        });

        await LegacyPreferencesMigration.runMigration(database);

        final progress = await database.playerProgressDao.getProgress();
        expect(progress.highestUnlockedLevelIndex, 5);
        expect(progress.totalScore, 2000);

        final potions = await database.potionCollectionDao.getAll();
        expect(potions.length, 2);
        final potionIds = potions.map((p) => p.potionId).toSet();
        expect(potionIds.contains('ember_essence'), true);
        expect(potionIds.contains('frost_elixir'), true);
      },
    );

    test(
      '6-9. Existing higher Drift progression is not overwritten by lower legacy progression',
      () async {
        // Setup higher drift state
        await database.playerProgressDao.updateUnlockedLevel(10);
        await database.playerProgressDao.updateScore(5000);
        await database.potionCollectionDao.discoverPotion(
          potionId: 'verdant_brew',
          discoveredLevelNumber: 8,
        );

        // Setup lower legacy state
        final legacyPotions = jsonEncode(['ember_essence']);
        SharedPreferences.setMockInitialValues({
          'unlocked_level': 2,
          'score': 500,
          'discovered_potions': legacyPotions,
          'legacy_drift_migration_version': 0, // Force run
        });

        await LegacyPreferencesMigration.runMigration(database);

        final progress = await database.playerProgressDao.getProgress();
        expect(progress.highestUnlockedLevelIndex, 10); // Remains 10
        expect(progress.totalScore, 5000); // Remains 5000

        // Potions are unioned
        final potions = await database.potionCollectionDao.getAll();
        expect(potions.length, 2);
      },
    );

    test('11-14. Migration is idempotent and does not double values', () async {
      final legacyPotions = jsonEncode(['ember_essence']);
      SharedPreferences.setMockInitialValues({
        'unlocked_level': 5,
        'score': 1000,
        'discovered_potions': legacyPotions,
        'legacy_drift_migration_version': 0, // Force run
      });

      await LegacyPreferencesMigration.runMigration(database);

      // Force it to run again by resetting the flag
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('legacy_drift_migration_version', 0);

      await LegacyPreferencesMigration.runMigration(database);

      final progress = await database.playerProgressDao.getProgress();
      expect(progress.highestUnlockedLevelIndex, 5);
      expect(progress.totalScore, 1000); // Does not become 2000

      final potions = await database.potionCollectionDao.getAll();
      expect(potions.length, 1); // Does not double
    });
  });
}
