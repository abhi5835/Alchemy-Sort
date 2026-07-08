import 'package:flutter/material.dart';
import 'package:flame/effects.dart';
import 'package:flame/components.dart';
import '../../core/constants/app_constants.dart';
import '../components/tube/tube_component.dart';
import '../components/tube/tube_logic.dart';
import '../levels/level_loader.dart';
// import '../levels/level_model.dart'; // Unused
import '../levels/level_repository.dart';
import '../../core/managers/game_manager.dart';
import '../systems/pour_system.dart';
import '../systems/win_check_system.dart';
import '../alchemy_game.dart';

class GameWorld extends World with HasGameReference<AlchemyGame> {
  late final PourSystem _pourSystem;
  final List<TubeComponent> _tubes = [];

  // Undo Stack: Stores a closure or simple state object to reverse actions
  final List<Function> _undoStack = [];

  // Called by PourSystem when a move is completed
  void recordMove(
    TubeComponent source,
    TubeComponent target,
    Color color,
    int amount,
  ) {
    _undoStack.add(() {
      // Reverse operation: Move color back from target to source
      for (int i = 0; i < amount; i++) {
        // Remove from target
        // Check isEmpty just in case, though logically it should be there
        if (!target.logic.isEmpty) {
          target.removeLiquid();
        }
        // Add to source
        // Check capacity just in case
        if (!source.logic.isFull) {
          // Use forceAddLiquid because we might be restoring a mixed state
          // that doesn't satisfy standard "match top color" rules.
          source.forceAddLiquid(color);
        }
      }
    });

    // Check if the target tube is now completed (full of same color)
    if (target.logic.isSolved && !target.logic.isEmpty) {
      GameManager().addScore(50);
    }
  }

  // Limits
  final undoRemaining = ValueNotifier<int>(3);
  final hintRemaining = ValueNotifier<int>(3);

  void undoMove() {
    if (_pourSystem.isPouring) return;
    if (undoRemaining.value <= 0) {
      debugPrint("No undos remaining!");
      return;
    }

    if (_undoStack.isNotEmpty) {
      final undoAction = _undoStack.removeLast();
      undoAction();
      undoRemaining.value--;
      GameManager().addScore(-10); // Penalty for undo
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
  Future<void> onLoad() async {
    super.onLoad();

    // Initialize systems
    _pourSystem = PourSystem(
      onWinCheck: _checkWin,
      onMoveCompleted: (s, t, c, a) => recordMove(s, t, c, a),
    );

    // Load a dummy level for now
    await _loadLevel();
  }

  Future<void> resetLevel() async {
    // Reset undo history etc?
    loadNextLevel(); // Reloads current level effectively
  }

  Future<void> loadNextLevel() async {
    addTubeRemaining.value = 3; // Reset added tubes count on level load
    // Clean up old components first
    removeAll(_tubes);
    _tubes.clear();

    await _loadLevel();
  }

  Future<void> _loadLevel() async {
    final level = LevelRepository.getLevel(
      GameManager().currentLevelIndex.value,
    );

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

  void _checkWin() {
    if (WinCheckSystem.checkWin(_tubes)) {
      debugPrint("WINNER!");
      GameManager().addScore(100);
      // Show win dialog overlay
      game.overlays.add('WinDialog');
    }
  }
}
