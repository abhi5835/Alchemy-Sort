import '../../game/models/potion_definition.dart';
import '../local/database/app_database.dart';
import 'dart:math';

class CompletionPersistenceResult {
  final bool potionNewlyDiscovered;

  const CompletionPersistenceResult({required this.potionNewlyDiscovered});
}

class LevelCompletionRepository {
  final AppDatabase database;

  LevelCompletionRepository(this.database);

  Future<CompletionPersistenceResult> commitCompletion({
    required int completedLevelIndex,
    required int scoreAfterCompletion,
    required int xpAfterCompletion,
    PotionDefinition? discoveredPotion,
  }) async {
    bool potionNewlyDiscovered = false;

    await database.transaction(() async {
      final progressDao = database.playerProgressDao;
      final current = await progressDao.getProgress();

      final newUnlockedLevel = max(
        current.highestUnlockedLevelIndex,
        completedLevelIndex + 1,
      );

      // Update progress atomically
      await database
          .update(database.playerProgress)
          .replace(
            current.copyWith(
              highestUnlockedLevelIndex: newUnlockedLevel,
              totalScore: scoreAfterCompletion,
              totalAlchemistXp: xpAfterCompletion,
              updatedAt: DateTime.now(),
            ),
          );

      // Insert potion discovery if applicable
      if (discoveredPotion != null) {
        final collectionDao = database.potionCollectionDao;
        potionNewlyDiscovered = await collectionDao.discoverPotion(
          potionId: discoveredPotion.id,
          discoveredLevelNumber: completedLevelIndex + 1,
        );
      }
    });

    return CompletionPersistenceResult(
      potionNewlyDiscovered: potionNewlyDiscovered,
    );
  }
}
