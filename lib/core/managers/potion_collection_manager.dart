import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_manager.dart';
import '../../game/potions/potion_repository.dart';
import '../../game/models/potion_definition.dart';
import '../../data/local/database/app_database.dart';

class PotionCollectionManager {
  static final PotionCollectionManager _instance =
      PotionCollectionManager._internal();

  factory PotionCollectionManager() {
    return _instance;
  }

  PotionCollectionManager._internal();

  AppDatabase? _db;

  final ValueNotifier<Set<String>> _discoveredPotionIds = ValueNotifier({});

  Future<void> init(AppDatabase db) async {
    _db = db;

    // Load persisted state from Drift
    final potions = await _db!.potionCollectionDao.getAll();
    _discoveredPotionIds.value = potions.map((p) => p.potionId).toSet();

    // Existing Player Reconciliation (still useful for older hard-coded progressions that were missed)
    final int highestCompletedLevel = GameManager().highestCompletedLevelNumber;

    bool changed = false;
    final Set<String> updatedSet = Set.from(_discoveredPotionIds.value);

    for (final potion in PotionRepository.allPotions) {
      if (potion.requiredLevel <= highestCompletedLevel) {
        if (!updatedSet.contains(potion.id)) {
          updatedSet.add(potion.id);
          await _db!.potionCollectionDao.discoverPotion(
            potionId: potion.id,
            discoveredLevelNumber: highestCompletedLevel,
          );
          changed = true;
        }
      }
    }

    if (changed) {
      _discoveredPotionIds.value = updatedSet;
    }
  }

  bool isDiscovered(String potionId) {
    return _discoveredPotionIds.value.contains(potionId);
  }

  Future<bool> discoverPotion(String potionId) async {
    if (isDiscovered(potionId)) {
      return false; // Idempotent: already discovered
    }

    final updatedSet = Set<String>.from(_discoveredPotionIds.value);
    updatedSet.add(potionId);
    _discoveredPotionIds.value = updatedSet;

    await _db?.potionCollectionDao.discoverPotion(
      potionId: potionId,
      discoveredLevelNumber: GameManager().highestCompletedLevelNumber,
    );
    return true; // Newly discovered
  }

  int get discoveredCount => _discoveredPotionIds.value.length;

  double get collectionProgress {
    final int total = PotionRepository.totalPotionCount;
    if (total == 0) return 0.0;
    return discoveredCount / total;
  }

  List<PotionDefinition> get discoveredPotions {
    final List<PotionDefinition> list = [];
    for (final id in _discoveredPotionIds.value) {
      final potion = PotionRepository.getById(id);
      if (potion != null) {
        list.add(potion);
      }
    }
    return list;
  }

  // Reactive listener getter
  ValueNotifier<Set<String>> get discoveredPotionIds => _discoveredPotionIds;
}
