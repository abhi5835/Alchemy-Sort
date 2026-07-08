import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/widgets.dart';

class StreamComponent extends PositionComponent with HasPaint {
  final Color streamColor;
  double targetHeight;

  StreamComponent({
    required this.streamColor,
    required this.targetHeight,
    required Vector2 position,
  }) : super(position: position, size: Vector2(4, 0)) {
    paint.color = streamColor;
  }

  @override
  void render(Canvas canvas) {
    // Draw the liquid stream as a rounded rectangle for a "drop" feel
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(2)),
      paint,
    );
  }

  /// High-performance growth animation using Flame Effects
  void animateGrowth(double duration) {
    add(
      SizeEffect.to(
        Vector2(size.x, targetHeight),
        EffectController(duration: duration, curve: Curves.easeInCubic),
      ),
    );
  }

  void animateShrink(double duration) {
    add(
      SizeEffect.to(
        Vector2(size.x, 0),
        EffectController(duration: duration, curve: Curves.easeOut),
      )..onComplete = removeFromParent,
    );
  }
}
