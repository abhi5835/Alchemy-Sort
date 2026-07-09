import 'package:drift/drift.dart';
import '../tables/player_progress_table.dart';
import '../app_database.dart';
import 'dart:math';

part 'player_progress_dao.g.dart';

@DriftAccessor(tables: [PlayerProgress])
class PlayerProgressDao extends DatabaseAccessor<AppDatabase>
    with _$PlayerProgressDaoMixin {
  PlayerProgressDao(AppDatabase db) : super(db);

  Future<void> ensurePlayerExists() async {
    final count = await select(playerProgress).get();
    if (count.isEmpty) {
      await into(playerProgress).insert(PlayerProgressCompanion.insert());
    }
  }

  Future<PlayerProgressData> getProgress() async {
    await ensurePlayerExists();
    return await (select(playerProgress)..limit(1)).getSingle();
  }

  Stream<PlayerProgressData> watchProgress() {
    return (select(playerProgress)..limit(1)).watchSingle();
  }

  Future<void> updateUnlockedLevel(int levelIndex) async {
    final current = await getProgress();
    final newLevel = max(current.highestUnlockedLevelIndex, levelIndex);
    await update(playerProgress).replace(
      current.copyWith(
        highestUnlockedLevelIndex: newLevel,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> updateScore(int score) async {
    final current = await getProgress();
    await update(
      playerProgress,
    ).replace(current.copyWith(totalScore: score, updatedAt: DateTime.now()));
  }

  Future<void> updateXp(int xp) async {
    final current = await getProgress();
    await update(playerProgress).replace(
      current.copyWith(totalAlchemistXp: xp, updatedAt: DateTime.now()),
    );
  }
}
