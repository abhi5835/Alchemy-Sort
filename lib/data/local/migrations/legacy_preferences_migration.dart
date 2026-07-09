import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/app_database.dart';

class LegacyPreferencesMigration {
  static const String _migrationVersionKey = 'legacy_drift_migration_version';

  static Future<void> runMigration(AppDatabase database) async {
    final prefs = await SharedPreferences.getInstance();
    final migrationVersion = prefs.getInt(_migrationVersionKey) ?? 0;

    if (migrationVersion >= 1) {
      // Already migrated
      return;
    }

    debugPrint('Starting legacy SharedPreferences to Drift migration...');

    // 1. Read legacy progression
    final legacyUnlockedLevel = prefs.getInt('unlocked_level') ?? 0;
    final legacyScore = prefs.getInt('score') ?? 0;

    // 2. Read legacy potions
    Set<String> legacyPotions = {};
    final String? potionsJsonStr = prefs.getString('discovered_potions');
    if (potionsJsonStr != null) {
      try {
        final List<dynamic> decoded = jsonDecode(potionsJsonStr);
        legacyPotions = decoded.map((e) => e.toString()).toSet();
      } catch (e) {
        debugPrint('Error decoding legacy potion collection: $e');
      }
    }

    // 3. Open a transaction to migrate data safely
    bool migrationSuccess = false;
    try {
      await database.transaction(() async {
        // Ensure player row exists
        await database.playerProgressDao.ensurePlayerExists();

        // Get current drift progress
        final driftProgress = await database.playerProgressDao.getProgress();

        // Reconcile progress (max)
        final newUnlockedLevel = max(
          driftProgress.highestUnlockedLevelIndex,
          legacyUnlockedLevel,
        );
        final newScore = max(driftProgress.totalScore, legacyScore);
        // Note: Alchemist XP was never in SharedPreferences, so we don't migrate it here.

        // Update drift progress
        await database.playerProgressDao.updateUnlockedLevel(newUnlockedLevel);
        await database.playerProgressDao.updateScore(newScore);

        // Migrate potions (union)
        for (final potionId in legacyPotions) {
          // We don't have the original discoveredLevelNumber, so default to 0 for legacy discoveries.
          await database.potionCollectionDao.discoverPotion(
            potionId: potionId,
            discoveredLevelNumber: 0,
          );
        }
      });
      migrationSuccess = true;
    } catch (e) {
      debugPrint('Legacy migration transaction failed: $e');
    }

    if (migrationSuccess) {
      debugPrint('Legacy migration completed successfully.');
      await prefs.setInt(_migrationVersionKey, 1);
    }
  }
}
