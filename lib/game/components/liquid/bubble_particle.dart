import 'dart:ui';
import 'package:flame/components.dart';
import 'dart:math';

class BubbleParticle extends PositionComponent {
  final double speed;
  final double maxLifeTime;
  double _lifeTime = 0;
  final double radius;
  late Paint _paint;

  BubbleParticle({
    required Vector2 position,
    required Color color,
    this.speed = 20.0,
    this.maxLifeTime = 1.0,
    this.radius = 2.0,
  }) : super(position: position) {
    _paint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    // Randomize horizontal drift slightly
    _drift = (Random().nextDouble() - 0.5) * 10;
  }

  late double _drift;

  @override
  void update(double dt) {
    super.update(dt);

    _lifeTime += dt;
    if (_lifeTime >= maxLifeTime) {
      removeFromParent();
      return;
    }

    // Move up
    position.y -= speed * dt;
    // Drift side to side
    position.x += _drift * dt;

    // Fade out
    _paint.color = _paint.color.withValues(
      alpha: 0.6 * (1 - _lifeTime / maxLifeTime).clamp(0.0, 1.0),
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(Offset.zero, radius, _paint);

    // Highlight
    canvas.drawCircle(
      Offset(-radius * 0.3, -radius * 0.3),
      radius * 0.3,
      Paint()..color = const Color(0xFFFFFFFF).withValues(alpha: 0.4),
    );
  }
}
