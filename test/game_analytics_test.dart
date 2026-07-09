import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:alchemy_sort/data/local/database/app_database.dart';
import 'package:alchemy_sort/game/analytics/game_analytics_event.dart';
import 'package:alchemy_sort/game/analytics/level_attempt_tracker.dart';
import 'package:alchemy_sort/game/analytics/game_analytics_service.dart';
import 'package:alchemy_sort/data/repositories/game_analytics_repository.dart';

void main() {
  late AppDatabase db;
  late GameAnalyticsService service;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() async {
    db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
    service = GameAnalyticsService();
    service.init(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Analytics Event Storage Tests', () {
    test('TEST 5: levelStarted event inserts properly', () async {
      final tracker = LevelAttemptTracker(
        sessionId: 'test-session-1',
        levelIndex: 0,
        restartCount: 0,
      );
      await service.trackLevelStarted(tracker);

      final events = await db.gameAnalyticsDao.getEvents();
      expect(events.length, 1);
      expect(events.first.eventType, GameAnalyticsEventType.levelStarted.index);
      expect(events.first.sessionId, 'test-session-1');
    });

    test(
      'TEST 6 & 7: levelCompleted event stores aggregate metrics with nullables',
      () async {
        final tracker = LevelAttemptTracker(
          sessionId: 'test-session-2',
          levelIndex: 1,
          restartCount: 0,
        );
        tracker.recordMove();
        tracker.recordMove();
        tracker.recordUndo();

        await service.trackLevelCompleted(tracker, stars: 3, highestCombo: 5);

        final events = await db.gameAnalyticsDao.getEvents();
        expect(events.length, 1);

        final event = events.first;
        expect(event.eventType, GameAnalyticsEventType.levelCompleted.index);
        expect(event.moveCount, 2);
        expect(event.undoCount, 1);
        expect(event.stars, 3);
        expect(event.highestCombo, 5);
        expect(event.durationMs, isNot(equals(null)));
        expect(
          event.potionId,
          equals(null),
        ); // nullable field properly remains null
      },
    );

    test(
      'TEST 8 & 9: Events can be queried by level and counted by type',
      () async {
        final tracker1 = LevelAttemptTracker(
          sessionId: 's1',
          levelIndex: 0,
          restartCount: 0,
        );
        final tracker2 = LevelAttemptTracker(
          sessionId: 's2',
          levelIndex: 0,
          restartCount: 1,
        );
        final tracker3 = LevelAttemptTracker(
          sessionId: 's3',
          levelIndex: 1,
          restartCount: 0,
        );

        await service.trackLevelStarted(tracker1);
        await service.trackLevelCompleted(tracker1, stars: 2, highestCombo: 2);
        await service.trackLevelStarted(tracker2);
        await service.trackLevelExited(tracker2);
        await service.trackLevelStarted(tracker3);

        final repo = GameAnalyticsRepository(db);

        // Query by level
        final level1Summary = await repo.getLevelSummary(
          1,
        ); // levelNumber = index + 1
        expect(level1Summary.starts, 2);
        expect(level1Summary.completions, 1);
        expect(level1Summary.exits, 1);
        expect(
          level1Summary.restarts,
          0,
        ); // No restart event was fired, only instantiated trackers

        final level2Summary = await repo.getLevelSummary(2);
        expect(level2Summary.starts, 1);

        // Count by type
        final totalStarts = await repo.getTotalLevelStarts();
        expect(totalStarts, 3);

        final completions = await repo.getTotalLevelCompletions();
        expect(completions, 1);
      },
    );

    test('TEST 10: Old events can be deleted by cutoff', () async {
      await db.gameAnalyticsDao.insertEvent(
        sessionId: 'old-session',
        eventType: GameAnalyticsEventType.levelStarted,
        levelIndex: 0,
        levelNumber: 1,
      );

      // Hack the timestamp to be 100 days old
      final oldTime = DateTime.now().subtract(const Duration(days: 100));
      await (db.update(db.gameAnalyticsEvents)
            ..where((t) => t.sessionId.equals('old-session')))
          .write(GameAnalyticsEventsCompanion(eventTimestamp: Value(oldTime)));

      await db.gameAnalyticsDao.insertEvent(
        sessionId: 'new-session',
        eventType: GameAnalyticsEventType.levelStarted,
        levelIndex: 0,
        levelNumber: 1,
      );

      var events = await db.gameAnalyticsDao.getEvents();
      expect(events.length, 2);

      await service.runDataRetentionCleanup();

      events = await db.gameAnalyticsDao.getEvents();
      expect(events.length, 1);
      expect(events.first.sessionId, 'new-session');
    });
  });

  group('LevelAttemptTracker Tests', () {
    test('TEST 11: New tracker starts with zero moves', () {
      final tracker = LevelAttemptTracker(
        sessionId: 'test',
        levelIndex: 0,
        restartCount: 0,
      );
      expect(tracker.moveCount, 0);
      expect(tracker.undoCount, 0);
      expect(tracker.restartCount, 0);
    });

    test('TEST 12 & 13: Increment moveCount and undoCount', () {
      final tracker = LevelAttemptTracker(
        sessionId: 'test',
        levelIndex: 0,
        restartCount: 0,
      );
      tracker.recordMove();
      tracker.recordMove();
      tracker.recordUndo();

      expect(tracker.moveCount, 2);
      expect(tracker.undoCount, 1);
    });

    test('TEST 14: Elapsed duration is non-negative', () async {
      final tracker = LevelAttemptTracker(
        sessionId: 'test',
        levelIndex: 0,
        restartCount: 0,
      );
      await Future.delayed(const Duration(milliseconds: 10));
      expect(tracker.elapsedDuration.inMilliseconds, greaterThanOrEqualTo(10));
    });

    test('TEST 15: New attempt receives a new session ID', () {
      final id1 = service.generateSessionId();
      final id2 = service.generateSessionId();
      expect(id1, isNot(equals(id2)));
    });
  });

  group('GameAnalyticsRepository Summary Queries Tests', () {
    test('TEST 26: Completion rate calculates correctly', () async {
      final repo = GameAnalyticsRepository(db);

      // 0%
      expect(await repo.getCompletionRate(), 0.0);

      final tracker1 = LevelAttemptTracker(
        sessionId: 's1',
        levelIndex: 0,
        restartCount: 0,
      );
      await service.trackLevelStarted(tracker1);
      await service.trackLevelExited(tracker1);

      // 0% still
      expect(await repo.getCompletionRate(), 0.0);

      final tracker2 = LevelAttemptTracker(
        sessionId: 's2',
        levelIndex: 0,
        restartCount: 0,
      );
      await service.trackLevelStarted(tracker2);
      await service.trackLevelCompleted(tracker2, stars: 3, highestCombo: 0);

      // 1 completion / 2 starts = 50%
      expect(await repo.getCompletionRate(), 0.5);
    });

    test(
      'TEST 27 & 28: Average move count and undo count calculate correctly',
      () async {
        final repo = GameAnalyticsRepository(db);

        final tracker1 = LevelAttemptTracker(
          sessionId: 's1',
          levelIndex: 0,
          restartCount: 0,
        );
        tracker1.recordMove(); // 1 move, 0 undos
        await service.trackLevelCompleted(tracker1, stars: 3, highestCombo: 0);

        final tracker2 = LevelAttemptTracker(
          sessionId: 's2',
          levelIndex: 0,
          restartCount: 0,
        );
        tracker2.recordMove();
        tracker2.recordMove();
        tracker2.recordMove();
        tracker2.recordUndo();
        tracker2.recordUndo(); // 3 moves, 2 undos
        await service.trackLevelCompleted(tracker2, stars: 3, highestCombo: 0);

        final summary = await repo.getLevelSummary(1);

        // Average move = (1 + 3) / 2 = 2
        // Average undo = (0 + 2) / 2 = 1
        expect(summary.averageMoveCount, 2);
        expect(summary.averageUndoCount, 1);
      },
    );

    test('TEST 31 & 32: Continue and Map selection count is correct', () async {
      final repo = GameAnalyticsRepository(db);

      await service.trackCompletionContinued('s1', 0);
      await service.trackCompletionContinued('s2', 1);
      await service.trackCompletionMapSelected('s3', 2);

      expect(await repo.getCompletionContinuedCount(), 2);
      expect(await repo.getCompletionMapSelectedCount(), 1);
    });
  });
}
