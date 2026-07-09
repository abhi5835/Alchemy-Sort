import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PerformanceMonitor extends PositionComponent {
  late TextComponent _fpsText;
  late TextComponent _componentCountText;

  double _elapsed = 0;
  int _frameCount = 0;

  PerformanceMonitor() : super(position: Vector2(10, 50)) {
    priority = 1000; // Always on top
  }

  @override
  Future<void> onLoad() async {
    if (!kDebugMode) {
      removeFromParent();
      return;
    }

    final textStyle = TextPaint(
      style: const TextStyle(
        color: Colors.greenAccent,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        backgroundColor: Colors.black54,
      ),
    );

    _fpsText = TextComponent(
      text: 'FPS: 0',
      textRenderer: textStyle,
      position: Vector2(0, 0),
    );

    _componentCountText = TextComponent(
      text: 'Components: 0',
      textRenderer: textStyle,
      position: Vector2(0, 15),
    );

    add(_fpsText);
    add(_componentCountText);
  }

  @override
  void update(double dt) {
    if (!kDebugMode) return;

    super.update(dt);
    _frameCount++;
    _elapsed += dt;

    if (_elapsed >= 1.0) {
      final fps = (_frameCount / _elapsed).round();
      final msPerFrame = ((_elapsed * 1000) / _frameCount).toStringAsFixed(1);

      _fpsText.text = 'FPS: $fps ($msPerFrame ms)';

      if (parent != null) {
        _componentCountText.text = 'Components: ${parent!.children.length}';
      }

      _frameCount = 0;
      _elapsed = 0;
    }
  }
}
