import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../components/tube/tube_component.dart';
import '../components/liquid/stream_component.dart';
import '../../core/managers/audio_manager.dart';

class PourSystem {
  TubeComponent? _selectedTube;
  Vector2? _originalPosition; // Prevents coordinate drift after multiple moves

  final Function() onWinCheck;
  final Function(
    TubeComponent source,
    TubeComponent target,
    Color color,
    int amount,
  )?
  onMoveCompleted;

  bool _isPouring = false;
  bool get isPouring => _isPouring;

  PourSystem({required this.onWinCheck, this.onMoveCompleted});

  /// Handles logic when a tube is tapped
  void handleTap(TubeComponent tube) {
    if (_isPouring) return;

    if (_selectedTube == null) {
      // Select source: capture its resting position before lifting
      if (!tube.logic.isEmpty) {
        _selectedTube = tube;
        _originalPosition = tube.position.clone();

        tube.isSelected = true;
        AudioManager().playSelectVial();
        // Selection feedback: lift the tube
        tube.position.y -= 30;
      }
    } else {
      if (_selectedTube == tube) {
        _deselect();
      } else {
        // Attempt to pour into the target
        _startPourSequence(_selectedTube!, tube);
      }
    }
  }

  /// Resets selection and restores the tube to its exact starting spot
  void _deselect() {
    if (_selectedTube != null && _originalPosition != null) {
      _selectedTube!.isSelected = false;
      _selectedTube!.position = _originalPosition!;
      _selectedTube = null;
      _originalPosition = null;
    }
  }

  /// Orchestrates the visual and logical transfer of liquid
  Future<void> _startPourSequence(
    TubeComponent source,
    TubeComponent target,
  ) async {
    final color = source.logic.topColor;
    if (color == null) return _deselect();

    if (!target.logic.canAccept(color)) return _deselect();

    int amountToMove = _calculateAmount(source, target, color);
    if (amountToMove == 0) return _deselect();

    _isPouring = true;
    AudioManager().playPour();

    // 1. POSITION SOURCE FOR POURING
    // Determines if target is left or right to set the tilt direction
    final bool isTargetToRight = target.position.x > source.position.x;

    // Offset the source to sit diagonally above the target mouth
    final Vector2 pourPosition =
        target.position +
        Vector2(
          isTargetToRight ? -source.size.x * 0.6 : source.size.x * 0.6,
          -source.size.y * 0.5,
        );

    // Smooth move to the pour position
    source.add(
      MoveEffect.to(
        pourPosition,
        EffectController(duration: 0.4, curve: Curves.easeOutCubic),
      ),
    );

    // 2. TILT EFFECT
    // Tilt angle (0.75 rad) matches the screenshot reference
    source.add(
      RotateEffect.to(
        isTargetToRight ? 0.75 : -0.75,
        EffectController(duration: 0.4, curve: Curves.easeOutCubic),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 400));

    // 3. CREATE STREAM
    // Connects the source mouth to the target vial interior
    final stream = StreamComponent(
      streamColor: color,
      targetHeight: (target.position.y - source.position.y) + 15,
      position: source.mouthPosition,
    );
    source.parent?.add(stream);
    stream.animateGrowth(0.15);

    // 4. TRANSFER LOOP
    for (int i = 0; i < amountToMove; i++) {
      target.addTemporaryLiquid(color, 0.0);
      await _animateLiquidTransfer(source, target, color);

      // Commit logical state
      source.removeLiquid();
      target.addLiquid(color);
    }

    // 5. CLEANUP & RETURN
    stream.animateShrink(0.15);
    source.add(RotateEffect.to(0, EffectController(duration: 0.3)));

    if (_originalPosition != null) {
      source.add(
        MoveEffect.to(
          _originalPosition!,
          EffectController(duration: 0.4, curve: Curves.easeInCubic),
        ),
      );
    }

    await Future.delayed(const Duration(milliseconds: 400));

    // Required for recording move in undo stack
    onMoveCompleted?.call(source, target, color, amountToMove);

    _isPouring = false;
    _deselect();
    onWinCheck();
  }

  /// Calculates how many matching segments can fit into the target
  int _calculateAmount(
    TubeComponent source,
    TubeComponent target,
    Color color,
  ) {
    final sourceLiquids = source.logic.liquids;
    final targetFill = target.logic.currentFill;
    final targetCapacity = target.logic.capacity;

    int amountInSource = 0;
    int availableInTarget = targetCapacity - targetFill;

    for (int i = sourceLiquids.length - 1; i >= 0; i--) {
      if (sourceLiquids[i] == color) {
        amountInSource++;
      } else {
        break;
      }
    }

    return amountInSource > availableInTarget
        ? availableInTarget
        : amountInSource;
  }

  /// Interpolates the liquid heights for the pouring animation
  Future<void> _animateLiquidTransfer(
    TubeComponent source,
    TubeComponent target,
    Color color,
  ) async {
    const int steps = 10;
    const double stepDuration = 0.03;

    for (int i = 1; i <= steps; i++) {
      double progress = i / steps;
      source.updateTopLiquidHeight(1.0 - progress);
      target.updateTopLiquidHeight(progress);

      // Visual splash effect
      if (i > 2 && i < 8) {
        target.spawnBubbles(color, 1);
      }

      await Future.delayed(
        Duration(milliseconds: (stepDuration * 1000).toInt()),
      );
    }
  }
}
