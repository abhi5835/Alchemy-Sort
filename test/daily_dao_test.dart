import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:alchemy_sort/data/local/database/app_database.dart';
import 'package:alchemy_sort/data/local/database/tables/daily_alchemy_records_table.dart';
import 'package:alchemy_sort/game/daily/daily_challenge_generator.dart';

void main() {
  group('DailyAlchemyDao Tests', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
    });

    tearDown(() async {
      await db.close();
    });

    test(
      '9 & 10. Record is created once and duplicate ensure does not duplicate record',
      () async {
        final challenge = DailyChallenge(
          dateKey: '2026-07-09',
          seed: 12345,
          sourceLevelIndex: 10,
        );

        await db.dailyAlchemyDao.ensureRecord(challenge: challenge);
        await db.dailyAlchemyDao.ensureRecord(
          challenge: challenge,
        ); // duplicate

        final records = await db.select(db.dailyAlchemyRecords).get();
        expect(records.length, 1);
        expect(records.first.dateKey, '2026-07-09');
        expect(records.first.status, DailyChallengeStatus.notStarted);
      },
    );

    test('11. Attempt count increments', () async {
      final challenge = DailyChallenge(
        dateKey: '2026-07-09',
        seed: 12345,
        sourceLevelIndex: 10,
      );
      await db.dailyAlchemyDao.ensureRecord(challenge: challenge);

      await db.dailyAlchemyDao.startAttempt('2026-07-09');
      await db.dailyAlchemyDao.startAttempt('2026-07-09');

      final record = await db.dailyAlchemyDao.getByDateKey('2026-07-09');
      expect(record!.attemptCount, 2);
      expect(record.status, DailyChallengeStatus.inProgress);
    });

    test('12. Completion persists', () async {
      final challenge = DailyChallenge(
        dateKey: '2026-07-09',
        seed: 12345,
        sourceLevelIndex: 10,
      );
      await db.dailyAlchemyDao.ensureRecord(challenge: challenge);

      await db.dailyAlchemyDao.commitCompletion(
        dateKey: '2026-07-09',
        moveCount: 50,
        durationMs: 30000,
        stars: 3,
        xpReward: 200,
      );

      final record = await db.dailyAlchemyDao.getByDateKey('2026-07-09');
      expect(record!.status, DailyChallengeStatus.completed);
      expect(record.bestMoveCount, 50);
      expect(record.bestDurationMs, 30000);
      expect(record.bestStars, 3);
      expect(record.xpReward, 200);
    });

    test('13 & 14. Reward claimed persists and idempotent', () async {
      final challenge = DailyChallenge(
        dateKey: '2026-07-09',
        seed: 12345,
        sourceLevelIndex: 10,
      );
      await db.dailyAlchemyDao.ensureRecord(challenge: challenge);

      bool firstClaim = await db.dailyAlchemyDao.claimReward('2026-07-09');
      expect(firstClaim, isTrue);

      bool secondClaim = await db.dailyAlchemyDao.claimReward('2026-07-09');
      expect(secondClaim, isFalse);

      final record = await db.dailyAlchemyDao.getByDateKey('2026-07-09');
      expect(record!.rewardClaimed, isTrue);
    });
  });
}
