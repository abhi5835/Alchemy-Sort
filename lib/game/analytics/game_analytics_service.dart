import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../data/local/database/app_database.dart';
import 'game_analytics_event.dart';
import 'level_attempt_tracker.dart';

class GameAnalyticsService {
  static final GameAnalyticsService _instance =
      GameAnalyticsService._internal();

  factory GameAnalyticsService() {
    return _instance;
  }

  GameAnalyticsService._internal();

  AppDatabase? _db;

  void init(AppDatabase database) {
    _db = database;
  }

  Future<void> runDataRetentionCleanup() async {
    if (_db == null) return;
    try {
      final cutoff = DateTime.now().subtract(const Duration(days: 90));
      await _db!.gameAnalyticsDao.deleteEventsOlderThan(cutoff);
    } catch (e) {
      debugPrint('Analytics cleanup failed: $e');
    }
  }

  String generateSessionId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
  }

  Future<void> trackLevelStarted(LevelAttemptTracker tracker) async {
    if (_db == null) return;
    try {
      await _db!.gameAnalyticsDao.insertEvent(
        sessionId: tracker.sessionId,
        eventType: GameAnalyticsEventType.levelStarted,
        levelIndex: tracker.levelIndex,
        levelNumber: tracker.levelNumber,
        restartCount: tracker.restartCount,
      );
    } catch (e) {
      debugPrint('trackLevelStarted failed: $e');
    }
  }

  Future<void> trackUndoUsed(LevelAttemptTracker tracker) async {
    if (_db == null) return;
    try {
      await _db!.gameAnalyticsDao.insertEvent(
        sessionId: tracker.sessionId,
        eventType: GameAnalyticsEventType.undoUsed,
        levelIndex: tracker.levelIndex,
        levelNumber: tracker.levelNumber,
      );
    } catch (e) {
      debugPrint('trackUndoUsed failed: $e');
    }
  }

  Future<void> trackLevelRestarted(LevelAttemptTracker tracker) async {
    if (_db == null) return;
    try {
      await _db!.gameAnalyticsDao.insertEvent(
        sessionId: tracker.sessionId,
        eventType: GameAnalyticsEventType.levelRestarted,
        levelIndex: tracker.levelIndex,
        levelNumber: tracker.levelNumber,
        moveCount: tracker.moveCount,
        undoCount: tracker.undoCount,
        durationMs: tracker.elapsedDuration.inMilliseconds,
      );
    } catch (e) {
      debugPrint('trackLevelRestarted failed: $e');
    }
  }

  Future<void> trackLevelCompleted(
    LevelAttemptTracker tracker, {
    required int stars,
    required int highestCombo,
  }) async {
    if (_db == null) return;
    try {
      await _db!.gameAnalyticsDao.insertEvent(
        sessionId: tracker.sessionId,
        eventType: GameAnalyticsEventType.levelCompleted,
        levelIndex: tracker.levelIndex,
        levelNumber: tracker.levelNumber,
        moveCount: tracker.moveCount,
        undoCount: tracker.undoCount,
        durationMs: tracker.elapsedDuration.inMilliseconds,
        stars: stars,
        highestCombo: highestCombo,
      );
    } catch (e) {
      debugPrint('trackLevelCompleted failed: $e');
    }
  }

  Future<void> trackLevelExited(LevelAttemptTracker tracker) async {
    if (_db == null) return;
    try {
      await _db!.gameAnalyticsDao.insertEvent(
        sessionId: tracker.sessionId,
        eventType: GameAnalyticsEventType.levelExited,
        levelIndex: tracker.levelIndex,
        levelNumber: tracker.levelNumber,
        moveCount: tracker.moveCount,
        undoCount: tracker.undoCount,
        durationMs: tracker.elapsedDuration.inMilliseconds,
      );
    } catch (e) {
      debugPrint('trackLevelExited failed: $e');
    }
  }

  Future<void> trackDailyChallengeStarted(LevelAttemptTracker tracker) async {
    if (_db == null) return;
    try {
      await _db!.gameAnalyticsDao.insertEvent(
        sessionId: tracker.sessionId,
        eventType: GameAnalyticsEventType.dailyChallengeStarted,
        levelIndex: tracker.levelIndex,
        levelNumber: tracker.levelNumber,
        restartCount: tracker.restartCount,
      );
    } catch (e) {
      debugPrint('trackDailyChallengeStarted failed: $e');
    }
  }

  Future<void> trackDailyChallengeCompleted(
    LevelAttemptTracker tracker, {
    required int stars,
    required int highestCombo,
    required bool isPractice,
  }) async {
    if (_db == null) return;
    try {
      await _db!.gameAnalyticsDao.insertEvent(
        sessionId: tracker.sessionId,
        eventType: isPractice 
            ? GameAnalyticsEventType.dailyChallengePracticeCompleted 
            : GameAnalyticsEventType.dailyChallengeCompleted,
        levelIndex: tracker.levelIndex,
        levelNumber: tracker.levelNumber,
        moveCount: tracker.moveCount,
        undoCount: tracker.undoCount,
        durationMs: tracker.elapsedDuration.inMilliseconds,
        stars: stars,
        highestCombo: highestCombo,
      );
    } catch (e) {
      debugPrint('trackDailyChallengeCompleted failed: $e');
    }
  }

  Future<void> trackDailyChallengeExited(LevelAttemptTracker tracker) async {
    if (_db == null) return;
    try {
      await _db!.gameAnalyticsDao.insertEvent(
        sessionId: tracker.sessionId,
        eventType: GameAnalyticsEventType.dailyChallengeExited,
        levelIndex: tracker.levelIndex,
        levelNumber: tracker.levelNumber,
        moveCount: tracker.moveCount,
        undoCount: tracker.undoCount,
        durationMs: tracker.elapsedDuration.inMilliseconds,
      );
    } catch (e) {
      debugPrint('trackDailyChallengeExited failed: $e');
    }
  }

  Future<void> trackPotionDiscovered(
    String sessionId,
    int levelIndex,
    String potionId,
  ) async {
    if (_db == null) return;
    try {
      await _db!.gameAnalyticsDao.insertEvent(
        sessionId: sessionId,
        eventType: GameAnalyticsEventType.potionDiscovered,
        levelIndex: levelIndex,
        levelNumber: levelIndex + 1,
        potionId: potionId,
      );
    } catch (e) {
      debugPrint('trackPotionDiscovered failed: $e');
    }
  }

  Future<void> trackCompletionContinued(
    String sessionId,
    int levelIndex,
  ) async {
    if (_db == null) return;
    try {
      await _db!.gameAnalyticsDao.insertEvent(
        sessionId: sessionId,
        eventType: GameAnalyticsEventType.completionContinued,
        levelIndex: levelIndex,
        levelNumber: levelIndex + 1,
      );
    } catch (e) {
      debugPrint('trackCompletionContinued failed: $e');
    }
  }

  Future<void> trackCompletionMapSelected(
    String sessionId,
    int levelIndex,
  ) async {
    if (_db == null) return;
    try {
      await _db!.gameAnalyticsDao.insertEvent(
        sessionId: sessionId,
        eventType: GameAnalyticsEventType.completionMapSelected,
        levelIndex: levelIndex,
        levelNumber: levelIndex + 1,
      );
    } catch (e) {
      debugPrint('trackCompletionMapSelected failed: $e');
    }
  }
}
