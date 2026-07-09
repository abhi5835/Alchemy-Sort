import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:alchemy_sort/data/local/database/app_database.dart';
import 'package:alchemy_sort/core/managers/potion_collection_manager.dart';
import 'package:alchemy_sort/game/potions/potion_repository.dart';
import 'package:alchemy_sort/game/levels/level_repository.dart';
import 'package:alchemy_sort/core/managers/game_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('PotionRepository Tests', () {
    test('TEST: Potion IDs are unique', () {
      final ids = PotionRepository.allPotions.map((p) => p.id).toSet();
      expect(ids.length, PotionRepository.totalPotionCount);
    });

    test('TEST: No potion requiredLevel exceeds LevelRepository.maxLevels', () {
      for (final potion in PotionRepository.allPotions) {
        expect(potion.requiredLevel <= LevelRepository.maxLevels, isTrue);
        expect(potion.requiredLevel > 0, isTrue); // must be valid level
      }
    });

    test('TEST: getById returns the correct potion', () {
      final potion = PotionRepository.getById('ember_essence');
      expect(potion, isNotNull);
      expect(potion!.name, 'Ember Essence');
    });

    test('TEST: Unknown ID is safely handled', () {
      final potion = PotionRepository.getById('non_existent');
      expect(potion, isNull);
    });

    test('TEST: getPotionUnlockedAtLevel returns the correct potion', () {
      final potion = PotionRepository.getPotionUnlockedAtLevel(3);
      expect(potion, isNotNull);
      expect(potion!.id, 'ember_essence');
    });

    test('TEST: Non-discovery level returns no potion', () {
      final potion = PotionRepository.getPotionUnlockedAtLevel(4);
      expect(potion, isNull);
    });
  });

  group('PotionCollectionManager Tests', () {
    late AppDatabase db;

    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    setUp(() async {
      db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
      SharedPreferences.setMockInitialValues({});
      await GameManager().init(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('TEST: Initial empty state progress is 0', () async {
      final manager = PotionCollectionManager();
      await manager.init(db);

      expect(manager.discoveredCount, 0);
      expect(manager.collectionProgress, 0.0);
    });

    test(
      'TEST: discoverPotion returns true for first discovery and false for duplicate',
      () async {
        final manager = PotionCollectionManager();
        await manager.init(db);

        bool first = await manager.discoverPotion('ember_essence');
        expect(first, isTrue);
        expect(manager.isDiscovered('ember_essence'), isTrue);
        expect(manager.discoveredCount, 1);

        bool second = await manager.discoverPotion('ember_essence');
        expect(second, isFalse);
        expect(
          manager.discoveredCount,
          1,
        ); // duplicate discovery does not increase count
      },
    );

    test(
      'TEST: Existing-player reconciliation discovers eligible potions',
      () async {
        await db.playerProgressDao.updateUnlockedLevel(
          5,
        ); // Completed indices 0-4 (Levels 1-5)
        SharedPreferences.setMockInitialValues({});
        await GameManager().init(db); // reload game manager

        final manager = PotionCollectionManager();
        await manager.init(db);

        // Should unlock Ember Essence (level 3) and Frost Elixir (level 5)
        expect(manager.isDiscovered('ember_essence'), isTrue);
        expect(manager.isDiscovered('frost_elixir'), isTrue);
        expect(
          manager.isDiscovered('verdant_brew'),
          isFalse,
        ); // requiredLevel 8
        expect(manager.discoveredCount, 2);
      },
    );

    test(
      'TEST: Reconciliation does not unlock potion for unlocked-but-uncompleted level',
      () async {
        // If unlocked_level is 2, it means index 2 (Level 3) is unlocked but not completed.
        // So highestCompletedLevel is 2. (Wait, GameManager logic: index 2 means levels 1 and 2 are completed. Level 3 is unlocked).
        await db.playerProgressDao.updateUnlockedLevel(2);
        SharedPreferences.setMockInitialValues({});
        await GameManager().init(db);

        final manager = PotionCollectionManager();
        await manager.init(db);

        // Ember Essence requires Level 3 completion. highestCompletedLevel = 2. Should be false.
        expect(manager.isDiscovered('ember_essence'), isFalse);
      },
    );

    test('TEST: Reconciliation is idempotent', () async {
      await db.playerProgressDao.updateUnlockedLevel(5);
      SharedPreferences.setMockInitialValues({});
      await GameManager().init(db);

      final manager = PotionCollectionManager();
      await manager.init(db);
      expect(manager.discoveredCount, 2);

      // Init again
      await manager.init(db);
      expect(manager.discoveredCount, 2);
    });
  });
}
