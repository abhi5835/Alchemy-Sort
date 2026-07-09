import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/daily_alchemy_records_table.dart';
import '../../../../game/daily/daily_challenge_generator.dart';

part 'daily_alchemy_dao.g.dart';

@DriftAccessor(tables: [DailyAlchemyRecords])
class DailyAlchemyDao extends DatabaseAccessor<AppDatabase>
    with _$DailyAlchemyDaoMixin {
  DailyAlchemyDao(super.db);

  Future<DailyAlchemyRecordData?> getByDateKey(String dateKey) async {
    return (select(
      dailyAlchemyRecords,
    )..where((t) => t.dateKey.equals(dateKey))).getSingleOrNull();
  }

  Stream<DailyAlchemyRecordData?> watchByDateKey(String dateKey) {
    return (select(
      dailyAlchemyRecords,
    )..where((t) => t.dateKey.equals(dateKey))).watchSingleOrNull();
  }

  Future<List<DailyAlchemyRecordData>> getCompletedRecords() async {
    return (select(dailyAlchemyRecords)
          ..where((t) => t.status.equals(DailyChallengeStatus.completed.name))
          ..orderBy([
            (t) => OrderingTerm(expression: t.dateKey, mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<void> ensureRecord({required DailyChallenge challenge}) async {
    final now = DateTime.now();
    await into(dailyAlchemyRecords).insertOnConflictUpdate(
      DailyAlchemyRecordsCompanion.insert(
        dateKey: challenge.dateKey,
        sourceLevelIndex: challenge.sourceLevelIndex,
        status: DailyChallengeStatus.notStarted,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<void> startAttempt(String dateKey) async {
    final record = await getByDateKey(dateKey);
    if (record == null) return;

    final newStatus = record.status == DailyChallengeStatus.notStarted
        ? DailyChallengeStatus.inProgress
        : record.status;

    await (update(
      dailyAlchemyRecords,
    )..where((t) => t.dateKey.equals(dateKey))).write(
      DailyAlchemyRecordsCompanion(
        status: Value(newStatus),
        attemptCount: Value(record.attemptCount + 1),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> commitCompletion({
    required String dateKey,
    required int moveCount,
    required int durationMs,
    required int stars,
    required int xpReward,
  }) async {
    final record = await getByDateKey(dateKey);
    if (record == null) return;

    final isFirstCompletion = record.status != DailyChallengeStatus.completed;
    final now = DateTime.now();

    final newMoveCount =
        (record.bestMoveCount == null || moveCount < record.bestMoveCount!)
        ? moveCount
        : record.bestMoveCount;
    final newDuration =
        (record.bestDurationMs == null || durationMs < record.bestDurationMs!)
        ? durationMs
        : record.bestDurationMs;
    final newStars = (record.bestStars == null || stars > record.bestStars!)
        ? stars
        : record.bestStars;

    await (update(
      dailyAlchemyRecords,
    )..where((t) => t.dateKey.equals(dateKey))).write(
      DailyAlchemyRecordsCompanion(
        status: const Value(DailyChallengeStatus.completed),
        bestMoveCount: Value(newMoveCount),
        bestDurationMs: Value(newDuration),
        bestStars: Value(newStars),
        xpReward: Value(isFirstCompletion ? xpReward : record.xpReward),
        completedAt: Value(record.completedAt ?? now),
        updatedAt: Value(now),
      ),
    );
  }

  Future<bool> claimReward(String dateKey) async {
    final record = await getByDateKey(dateKey);
    if (record == null || record.rewardClaimed) return false;

    final updatedRows =
        await (update(dailyAlchemyRecords)
              ..where((t) => t.dateKey.equals(dateKey))
              ..where((t) => t.rewardClaimed.equals(false)))
            .write(
              DailyAlchemyRecordsCompanion(
                rewardClaimed: const Value(true),
                updatedAt: Value(DateTime.now()),
              ),
            );

    return updatedRows > 0;
  }
}
