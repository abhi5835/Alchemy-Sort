import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:alchemy_sort/data/local/database/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(
      DatabaseConnection(NativeDatabase.memory()),
    );
  });

  tearDown(() async {
    await database.close();
  });

  group('PlayerProgressDao Tests', () {
    test('1. Default player row is created with correct defaults', () async {
      await database.playerProgressDao.ensurePlayerExists();
      final progress = await database.playerProgressDao.getProgress();

      expect(progress.highestUnlockedLevelIndex, 0);
      expect(progress.totalScore, 0);
      expect(progress.totalAlchemistXp, 0);
    });

    test('5. Updating unlocked level persists', () async {
      await database.playerProgressDao.updateUnlockedLevel(5);
      final progress = await database.playerProgressDao.getProgress();
      expect(progress.highestUnlockedLevelIndex, 5);
    });

    test('6. Unlocked level cannot move backwards', () async {
      await database.playerProgressDao.updateUnlockedLevel(5);
      await database.playerProgressDao.updateUnlockedLevel(2);
      final progress = await database.playerProgressDao.getProgress();
      expect(progress.highestUnlockedLevelIndex, 5); // Remains 5
    });

    test('7. Score persists', () async {
      await database.playerProgressDao.updateScore(1500);
      final progress = await database.playerProgressDao.getProgress();
      expect(progress.totalScore, 1500);
    });

    test('8. XP persists', () async {
      await database.playerProgressDao.updateXp(300);
      final progress = await database.playerProgressDao.getProgress();
      expect(progress.totalAlchemistXp, 300);
    });
  });

  group('PotionCollectionDao Tests', () {
    test('9. Potion discovery inserts successfully', () async {
      final inserted = await database.potionCollectionDao.discoverPotion(
        potionId: 'ember_essence',
        discoveredLevelNumber: 3,
      );
      expect(inserted, true);

      final count = await database.potionCollectionDao.getDiscoveredCount();
      expect(count, 1);
    });

    test('10. Duplicate potion discovery is idempotent', () async {
      await database.potionCollectionDao.discoverPotion(
        potionId: 'ember_essence',
        discoveredLevelNumber: 3,
      );

      final insertedAgain = await database.potionCollectionDao.discoverPotion(
        potionId: 'ember_essence',
        discoveredLevelNumber: 3,
      );
      expect(insertedAgain, false); // Already exists

      final count = await database.potionCollectionDao.getDiscoveredCount();
      expect(count, 1); // Still 1
    });

    test('14. Database reload returns potion discoveries', () async {
      await database.potionCollectionDao.discoverPotion(
        potionId: 'frost_elixir',
        discoveredLevelNumber: 5,
      );

      final potions = await database.potionCollectionDao.getAll();
      expect(potions.length, 1);
      expect(potions.first.potionId, 'frost_elixir');
    });
  });
}
