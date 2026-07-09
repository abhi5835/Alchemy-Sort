import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/effects.dart';
import 'package:flame/components.dart';
import '../../core/constants/app_constants.dart';
import '../components/tube/tube_component.dart';
import '../components/tube/tube_logic.dart';
import '../levels/level_loader.dart';
import '../levels/level_repository.dart';
import '../../core/managers/game_manager.dart';
import '../systems/pour_system.dart';
import '../systems/win_check_system.dart';
import '../alchemy_game.dart';
import '../../core/managers/audio_manager.dart';
import '../models/move_record.dart';
import '../models/level_session_stats.dart';
import '../models/level_completion_result.dart';
import '../../core/managers/potion_collection_manager.dart';
import '../potions/potion_repository.dart';
import '../../data/repositories/level_completion_repository.dart';
import '../logic/combo_manager.dart';
import '../components/effects/combo_text_effect.dart';
import '../components/effects/level_complete_celebration.dart';
import '../analytics/game_analytics_service.dart';
import '../analytics/level_attempt_tracker.dart';
import '../alchemy_game_mode.dart';
import '../daily/daily_challenge_generator.dart';
import '../models/daily_completion_result.dart';
import '../../data/repositories/daily_alchemy_repository.dart';
import '../../data/local/database/tables/daily_alchemy_records_table.dart';

class GameWorld extends World with HasGameReference<AlchemyGame> {
  final GameMode gameMode;
  final DailyChallenge? dailyChallenge;

  GameWorld({this.gameMode = GameMode.normal, this.dailyChallenge});

  late final PourSystem _pourSystem;
  final List<TubeComponent> _tubes = [];
  bool _isLevelComplete = false;
  LevelCompletionResult? completionResult;
  DailyCompletionResult? dailyCompletionResult;

  final List<MoveRecord> _moveHistory = [];
  final LevelSessionStats _sessionStats = LevelSessionStats();

  // Public getter for UI
  LevelSessionStats get sessionStats => _sessionStats;

  final ComboManager _comboManager = ComboManager();
  late final Timer _comboTimer;
  ComboTextEffect? _activeComboText;

  LevelAttemptTracker? _attemptTracker;
  String? get currentSessionId => _attemptTracker?.sessionId;

  void onLevelExited() {
    if (!_isLevelComplete && _attemptTracker != null) {
      if (gameMode == GameMode.normal) {
        GameAnalyticsService().trackLevelExited(_attemptTracker!);
      } else if (gameMode == GameMode.dailyAlchemy) {
        GameAnalyticsService().trackDailyChallengeExited(_attemptTracker!);
      }
    }
  }

  void pauseTracker() {
    _attemptTracker?.pause();
  }

  void resumeTracker() {
    _attemptTracker?.resume();
  }

  void recordMove(
    TubeComponent source,
    TubeComponent target,
    List<Color> sourceLiquidsBefore,
    List<Color> targetLiquidsBefore,
  ) {
    int sourceIndex = _tubes.indexOf(source);
    int targetIndex = _tubes.indexOf(target);
    int scoreBefore = GameManager().score.value;

    final record = MoveRecord(
      sourceTubeIndex: sourceIndex,
      targetTubeIndex: targetIndex,
      sourceLiquidsBefore: sourceLiquidsBefore,
      targetLiquidsBefore: targetLiquidsBefore,
      scoreBefore: scoreBefore,
      solvedPotionCountBefore: _sessionStats.solvedPotionCount,
      comboBonusEarnedBefore: _sessionStats.comboBonusEarned,
      highestComboBefore: _sessionStats.highestCombo,
    );

    _moveHistory.add(record);

    // Combo system
    _comboManager.registerMove();
    _comboTimer.start(); // restarts or starts timer for 3s

    int comboBonus = _comboManager.calculateBonus();
    if (comboBonus > 0) {
      GameManager().addScore(comboBonus);
    }

    if (_comboManager.combo >= 2) {
      if (_activeComboText?.parent != null) {
        _activeComboText!.removeFromParent();
      }
      _activeComboText = ComboTextEffect(combo: _comboManager.combo);
      _activeComboText!.position = Vector2.zero();
      add(_activeComboText!);
    }

    // Check if the target tube is now completed (full of same color)
    if (target.logic.isSolved && !target.logic.isEmpty) {
      GameManager().addScore(50);
      _sessionStats.solvedPotionCount++;
    }

    // Update highest combo
    _sessionStats.updateHighestCombo(_comboManager.combo);

    _attemptTracker?.recordMove();
  }

  // Limits
  final undoRemaining = ValueNotifier<int>(3);
  final hintRemaining = ValueNotifier<int>(3);

  void undoMove() {
    if (_pourSystem.isPouring) return;
    if (_isLevelComplete) return; // Prevent undo if level is already completed
    if (undoRemaining.value <= 0) {
      debugPrint("No undos remaining!");
      return;
    }

    if (_moveHistory.isNotEmpty) {
      final record = _moveHistory.removeLast();

      // Restore states exactly
      _tubes[record.sourceTubeIndex].restoreState(record.sourceLiquidsBefore);
      _tubes[record.targetTubeIndex].restoreState(record.targetLiquidsBefore);

      undoRemaining.value--;

      // Score rollback (with 10-point undo penalty)
      int newScore = record.scoreBefore - 10;
      if (newScore < 0) newScore = 0;

      int diff = newScore - GameManager().score.value;
      GameManager().addScore(diff);

      // Restore stats
      _sessionStats.solvedPotionCount = record.solvedPotionCountBefore;
      _sessionStats.comboBonusEarned = record.comboBonusEarnedBefore;
      _sessionStats.highestCombo = record.highestComboBefore;
      _sessionStats.undoUsedCount++;

      // Reset combo
      _comboManager.reset();
      _comboTimer.stop();
      if (_activeComboText?.parent != null) {
        _activeComboText!.removeFromParent();
        _activeComboText = null;
      }

      // Ensure all tubes are deselected after an undo
      for (final tube in _tubes) {
        tube.isSelected = false;
      }

      _attemptTracker?.recordUndo();
      if (_attemptTracker != null) {
        GameAnalyticsService().trackUndoUsed(_attemptTracker!);
      }
    }
  }

  void showHint() {
    if (hintRemaining.value <= 0) {
      debugPrint("No hints remaining!");
      return;
    }

    // Check all combinations for a valid move
    for (final source in _tubes) {
      if (source.logic.isEmpty) continue;

      final color = source.logic.topColor;
      if (color == null) continue;

      for (final target in _tubes) {
        if (source == target) continue;

        if (target.logic.canAccept(color)) {
          // Found a valid move!
          hintRemaining.value--; // Deduct hint only on success

          debugPrint(
            "Hint: Move from tube at ${source.position} to ${target.position}",
          );

          // Visual Feedback: Jump
          source.add(
            SequenceEffect([
              MoveEffect.by(
                Vector2(0, -20),
                EffectController(duration: 0.2, alternate: true),
              ),
            ]),
          );
          target.add(
            SequenceEffect([
              MoveEffect.by(
                Vector2(0, -20),
                EffectController(
                  duration: 0.2,
                  alternate: true,
                  startDelay: 0.2,
                ),
              ),
            ]),
          );
          return; // Show one hint at a time
        }
      }
    }
    debugPrint("No moves available!");
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _layoutTubes();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_comboTimer.isRunning()) {
      _comboTimer.update(dt);
    }
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Initialize systems
    _comboTimer = Timer(3.0, onTick: _comboManager.reset);

    _pourSystem = PourSystem(
      onWinCheck: _checkWin,
      onMoveCompleted: (s, t, sBefore, tBefore) =>
          recordMove(s, t, sBefore, tBefore),
    );

    // Load a dummy level for now
    await _loadLevel();
  }

  Future<void> resetLevel() async {
    // Track restart
    int restarts = 0;
    if (_attemptTracker != null) {
      restarts = _attemptTracker!.restartCount + 1;
      GameAnalyticsService().trackLevelRestarted(_attemptTracker!);
    }
    await loadNextLevel(
      restartCount: restarts,
    ); // Reloads current level effectively
  }

  Future<void> loadNextLevel({int restartCount = 0}) async {
    addTubeRemaining.value = 3; // Reset added tubes count on level load
    _isLevelComplete = false;
    completionResult = null;
    _moveHistory.clear();
    _sessionStats.reset();
    _comboManager.reset();
    _comboTimer.stop();
    if (_activeComboText?.parent != null) {
      _activeComboText!.removeFromParent();
      _activeComboText = null;
    }
    // Clean up old components first
    removeAll(_tubes);
    _tubes.clear();

    await _loadLevel();
    startTrackingAttempt(restartCount);
  }

  Future<void> _loadLevel() async {
    final level = gameMode == GameMode.dailyAlchemy
        ? LevelRepository.getLevel(dailyChallenge!.sourceLevelIndex)
        : LevelRepository.getLevel(GameManager().currentLevelIndex.value);

    // If no level found (end of game), maybe loop or show end screen?
    // For now, reload last level or Level 1.
    final effectiveLevel = level;

    final components = LevelLoader.loadLevel(effectiveLevel);
    _tubes.clear();
    _tubes.addAll(components);

    // Layout
    _layoutTubes();
    for (final tube in _tubes) {
      if (tube.parent == null) add(tube);
    }

    // Start tracking level if this isn't a restart mid-load
    // We get restartCount from the caller or default to 0
  }

  void startTrackingAttempt(int restartCount) {
    _attemptTracker = LevelAttemptTracker(
      sessionId: GameAnalyticsService().generateSessionId(),
      levelIndex: gameMode == GameMode.dailyAlchemy
          ? dailyChallenge!.sourceLevelIndex
          : GameManager().currentLevelIndex.value,
      restartCount: restartCount,
    );
    if (gameMode == GameMode.normal) {
      GameAnalyticsService().trackLevelStarted(_attemptTracker!);
    } else {
      // Differentiate practice mode if it's already completed today
      // For now we'll rely on the repository's logic, but analytics can just say started.
      GameAnalyticsService().trackDailyChallengeStarted(_attemptTracker!);
    }
  }

  void onTap(TubeComponent tube) {
    _pourSystem.handleTap(tube);
  }

  final addTubeRemaining = ValueNotifier<int>(3);

  Future<void> addTube() async {
    if (addTubeRemaining.value <= 0) {
      // detailed visual feedback or sound could be added here
      debugPrint("Cannot add more tubes!");
      return;
    }

    addTubeRemaining.value--;

    // Create a new empty tube
    final logic = TubeLogic(
      capacity: AppConstants.tubeCapacity,
    ); // Default empty
    final tube = TubeComponent(logic: logic);

    _tubes.add(tube);
    _layoutTubes();
    add(tube);
  }

  void _layoutTubes() {
    if (_tubes.isEmpty) return;

    final double screenWidth = game.size.x;

    // Safety padding
    final double sidePadding = 40.0;
    final double availableWidth = screenWidth - sidePadding;

    // Decide if we need 1 row or 2 rows
    // If we have many tubes, force 2 rows earlier to avoid tiny tubes
    int rows = _tubes.length > 5 ? 2 : 1;
    int tubesPerRow = (_tubes.length / rows).ceil();

    // Calculate required width for one row at scale 1.0
    double singleTubeWidth = AppConstants.tubeWidth + AppConstants.tubeSpacing;
    double totalRowWidth = tubesPerRow * singleTubeWidth;

    // Calculate scale to fit
    double scale = 1.0;
    if (totalRowWidth > availableWidth) {
      scale = availableWidth / totalRowWidth;
    }

    // Clamp scale to reasonable limits
    scale = scale.clamp(0.6, 1.0);

    for (int i = 0; i < _tubes.length; i++) {
      int row = i ~/ tubesPerRow;
      int col = i % tubesPerRow;

      // Recalculate positions based on SCALED width
      double scaledTubeWidth = AppConstants.tubeWidth * scale;
      double scaledSpacing = AppConstants.tubeSpacing * scale;
      double scaledTotalWidth = tubesPerRow * (scaledTubeWidth + scaledSpacing);

      // Center the row
      double rowStartX =
          -scaledTotalWidth / 2 + (scaledTubeWidth + scaledSpacing) / 2;
      double xPos = rowStartX + col * (scaledTubeWidth + scaledSpacing);

      // Vertical positioning
      double totalHeight =
          rows * (AppConstants.tubeHeight * scale) + (rows - 1) * 40;
      double startY = -totalHeight / 2 + (AppConstants.tubeHeight * scale) / 2;

      double yPos = startY + row * ((AppConstants.tubeHeight * scale) + 40);

      // TubeComponent anchor is TopLeft.
      // We want xPos, yPos to correspond to the tube's visible CENTER.
      // So we must subtract half the SCALED size from the desired center.
      _tubes[i].position = Vector2(
        xPos - (AppConstants.tubeWidth * scale) / 2,
        yPos - (AppConstants.tubeHeight * scale) / 2,
      );

      _tubes[i].scale = Vector2.all(scale);
    }
  }

  Future<void> _checkWin() async {
    if (_isLevelComplete) return;

    if (WinCheckSystem.checkWin(_tubes)) {
      _isLevelComplete = true;
      debugPrint("WINNER!");

      if (gameMode == GameMode.normal) {
        completionResult = await commitLevelCompletion();
      } else {
        dailyCompletionResult = await commitDailyAlchemyCompletion();
      }

      AudioManager().playLevelComplete();

      // Allow final potion effect to play before celebration
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!_isLevelComplete) return;

        final celebration = LevelCompleteCelebration();
        add(celebration);

        // Wait briefly for celebration burst before showing dialog
        Future.delayed(const Duration(milliseconds: 400), () {
          if (!_isLevelComplete) return;
          game.overlays.add('WinDialog');
        });
      });
    }
  }

  Future<LevelCompletionResult> commitLevelCompletion() async {
    final gameManager = GameManager();
    final currentIndex = gameManager.currentLevelIndex.value;
    final currentNumber = currentIndex + 1;

    // Add score only for first time win
    final scoreToAdd = currentIndex >= gameManager.keyUnlockedLevelIndex.value
        ? 100
        : 0;
    final scoreAfterCompletion = gameManager.score.value + scoreToAdd;
    final xpAfterCompletion = 0; // Reserved for Alchemist XP

    // Check potion discovery
    final potion = PotionRepository.getPotionUnlockedAtLevel(currentNumber);

    // Perform atomic persistence transaction
    final repo = LevelCompletionRepository(gameManager.database);
    final persistenceResult = await repo.commitCompletion(
      completedLevelIndex: currentIndex,
      scoreAfterCompletion: scoreAfterCompletion,
      xpAfterCompletion: xpAfterCompletion,
      discoveredPotion: potion,
    );

    // Sync UI/Reactive state
    gameManager.score.value = scoreAfterCompletion;
    gameManager.keyUnlockedLevelIndex.value = max(
      gameManager.keyUnlockedLevelIndex.value,
      currentIndex + 1,
    );

    if (persistenceResult.potionNewlyDiscovered && potion != null) {
      final potionManager = PotionCollectionManager();
      final updatedSet = Set<String>.from(
        potionManager.discoveredPotionIds.value,
      );
      updatedSet.add(potion.id);
      potionManager.discoveredPotionIds.value = updatedSet;
    }

    // Capture stats
    final stats = _sessionStats;
    final stars = stats.calculateStars();
    final nextAvailable = currentIndex < LevelRepository.maxLevels - 1;

    if (_attemptTracker != null) {
      GameAnalyticsService().trackLevelCompleted(
        _attemptTracker!,
        stars: stars,
        highestCombo: stats.highestCombo,
      );

      if (persistenceResult.potionNewlyDiscovered && potion != null) {
        GameAnalyticsService().trackPotionDiscovered(
          _attemptTracker!.sessionId,
          currentIndex,
          potion.id,
        );
      }
    }

    return LevelCompletionResult(
      completedLevelIndex: currentIndex,
      completedLevelNumber: currentNumber,
      finalScore: scoreAfterCompletion,
      stars: stars,
      sessionStats: stats,
      newlyDiscoveredPotion: persistenceResult.potionNewlyDiscovered
          ? potion
          : null,
      nextLevelAvailable: nextAvailable,
    );
  }

  Future<DailyCompletionResult> commitDailyAlchemyCompletion() async {
    final stats = _sessionStats;
    final stars = stats.calculateStars();

    final repo = DailyAlchemyRepository(GameManager().database);

    // Check if it's a practice attempt
    final record = await GameManager().database.dailyAlchemyDao.getByDateKey(
      dailyChallenge!.dateKey,
    );
    final isPractice = record?.status == DailyChallengeStatus.completed;

    final result = await repo.commitDailyCompletion(
      dateKey: dailyChallenge!.dateKey,
      moveCount: _attemptTracker?.moveCount ?? 0,
      durationMs: _attemptTracker?.elapsedDuration.inMilliseconds ?? 0,
      stars: stars,
      highestCombo: stats.highestCombo,
      isPractice: isPractice,
    );

    if (_attemptTracker != null) {
      GameAnalyticsService().trackDailyChallengeCompleted(
        _attemptTracker!,
        stars: stars,
        highestCombo: stats.highestCombo,
        isPractice: isPractice,
      );
    }

    return result;
  }
}
