import 'package:flutter/material.dart' show Colors;
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'dart:math';
import 'dart:ui';
import '../../../core/constants/app_constants.dart';
import '../../alchemy_game.dart';
import '../liquid/liquid_layer.dart';
import '../liquid/bubble_particle.dart';
import 'tube_logic.dart';
import 'tube_renderer.dart';

class TubeComponent extends PositionComponent
    with TapCallbacks, HasGameReference<AlchemyGame> {
  final TubeLogic logic;
  late final TubeRenderer _renderer;
  final List<LiquidLayer> _liquidComponents = [];

  TubeComponent({required this.logic, double? overrideHeight})
    : super(priority: 1) {
    // Set priority to handle layering if needed
    final height = overrideHeight ?? AppConstants.tubeHeight;
    size = Vector2(AppConstants.tubeWidth, height);
  }

  bool _isSelected = false;
  bool get isSelected => _isSelected;
  set isSelected(bool value) {
    if (_isSelected != value) {
      _isSelected = value;
      // Force re-render of outline if needed, though usually just setting state is enough
      // if renderer checks it in render() loop.
    }
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _renderer = TubeRenderer();
    _updateLiquids(); // This adds liquids and then the renderer
  }

  /// Returns the world position of the top center of the tube.
  Vector2 get topCenter => position + Vector2(size.x / 2, 0);

  /// Returns the point where liquid should pour from.
  Vector2 get mouthPosition {
    // angle < 0 means tilted right (pouring left) -> Use top-left corner
    // angle > 0 means tilted left (pouring right) -> Use top-right corner
    if (angle < 0) {
      return absolutePositionOf(Vector2(0, 0));
    } else if (angle > 0) {
      return absolutePositionOf(Vector2(size.x, 0));
    } else {
      // Fallback to top center if not tilted
      return absolutePositionOf(Vector2(size.x / 2, 0));
    }
  }

  void setRotation(double angle) {
    this.angle = angle;
  }

  void _updateLiquids() {
    final liquids = logic.liquids;
    final segmentHeight = AppConstants.liquidSegmentHeight;

    // Create new layers if needed
    while (_liquidComponents.length < liquids.length) {
      final isBottomLayer = _liquidComponents.isEmpty;
      // Start with transparent color, will update below
      final layer = LiquidLayer(
        liquidColor: Colors.transparent,
        isBottomLayer: isBottomLayer,
      );
      add(layer);
      _liquidComponents.add(layer);
    }

    // Remove extra layers if any
    while (_liquidComponents.length > liquids.length) {
      final extra = _liquidComponents.removeLast();
      extra.removeFromParent();
    }

    // Update existing layers
    for (int i = 0; i < liquids.length; i++) {
      final layer = _liquidComponents[i];
      layer.liquidColor = liquids[i];
      layer.position = Vector2(0, size.y - (i + 1) * segmentHeight);
      layer.size = Vector2(size.x, segmentHeight);
    }

    // Ensure the tube renderer is on top
    if (_renderer.parent == null) {
      add(_renderer);
    } else {
      _renderer.priority = 2; // Bump priority to render above liquids
    }

    // Check for completion animation (handled by GameWorld now, just update state)
  }

  void addLiquid(Color color) {
    logic.addLiquid(color);
    _updateLiquids();

    // GPU-friendly "Impact" wobble
    add(
      SequenceEffect([
        ScaleEffect.by(
          Vector2(1.05, 0.95),
          EffectController(duration: 0.1, reverseDuration: 0.1),
        ),
        ScaleEffect.by(
          Vector2(0.98, 1.02),
          EffectController(duration: 0.1, reverseDuration: 0.1),
        ),
      ]),
    );

    // Spawn splash bubbles
    spawnBubbles(color, 5);
  }

  void forceAddLiquid(Color color) {
    logic.forceAddLiquid(color);
    _updateLiquids();
  }

  Color removeLiquid() {
    final color = logic.removeLiquid();
    _updateLiquids();
    return color;
  }

  void restoreState(List<Color> newLiquids) {
    logic.restoreState(newLiquids);
    _updateLiquids();
  }

  /// Updates the height of the top liquid layer visually to simulate draining/filling.
  /// [fillPercent] 0.0 to 1.0 representing how full this specific segment is.
  void updateTopLiquidHeight(double fillPercent) {
    if (_liquidComponents.isNotEmpty) {
      final topLiquid = _liquidComponents.last;
      final segmentHeight = AppConstants.liquidSegmentHeight;
      final newHeight = segmentHeight * fillPercent;

      topLiquid.size.y = newHeight;

      // Keep anchored at bottom of the segment slot.
      // Slot bottom Y is: size.y - (index) * segmentHeight
      // Liquid Y should be: SlotBottomY - newHeight
      // wait.
      // _updateLiquids logic:
      // index i.
      // pos.y = size.y - (i + 1) * segmentHeight.
      // This is the top-left of the liquid rect.
      // Since it's a generic PositionComponent, drawing starts at 0,0 (relative to positsion).
      // So pos.y IS the top of the liquid.
      // If we reduce height, we want the BOTTOM of the liquid to stay fixed.
      // Fixed Bottom Y = (size.y - (i + 1) * segmentHeight) + fullHeight
      //                = size.y - i * segmentHeight
      // New Top Y = Fixed Bottom Y - newHeight
      //           = size.y - i * segmentHeight - newHeight.

      // Let's verify with i=0 (bottom liquid).
      // Fixed Bottom Y = size.y - 0 = size.y (Bottom of tube). Correct.
      // New Top Y = size.y - newHeight. Correct.

      final i = _liquidComponents.length - 1; // index of top liquid
      final fixedBottomY = size.y - i * segmentHeight;
      topLiquid.position.y = fixedBottomY - newHeight;
    }
  }

  /// Adds a temporary liquid layer for the target tube animation.
  void addTemporaryLiquid(Color color, double initialHeightPercent) {
    final segmentHeight = AppConstants.liquidSegmentHeight;
    // Index will be the NEXT available slot
    final i = _liquidComponents.length;

    final layer = LiquidLayer(liquidColor: color, isBottomLayer: i == 0);

    // Height setup
    final height = segmentHeight * initialHeightPercent;
    layer.size = Vector2(size.x, height);

    // Position setup (Same logic as above: anchor bottom)
    final fixedBottomY = size.y - i * segmentHeight;
    layer.position = Vector2(0, fixedBottomY - height);

    add(layer);
    _liquidComponents.add(layer);

    // Ensure renderer on top
    if (_renderer.parent == null) {
      add(_renderer);
    } else {
      _renderer.priority = 2; // Bump priority above liquids
    }
  }

  // Optimized Bubble Spawner
  static final Random _random = Random();

  void spawnBubbles(Color color, int count) {
    for (int i = 0; i < count; i++) {
      final bubble = BubbleParticle(
        position: Vector2(_random.nextDouble() * size.x, size.y * 0.8),
        color: Colors.white.withValues(alpha: 0.4),
        speed: 30 + _random.nextDouble() * 40,
        radius: 1 + _random.nextDouble() * 2,
        maxLifeTime: 0.6,
      );
      add(bubble);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.world.onTap(this);
  }
}
