import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../../../core/constants/app_constants.dart';

class LevelCompleteCelebration extends PositionComponent with HasGameReference {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Haptics
    HapticFeedback.mediumImpact();

    // 1. Background Glow
    final glow = RectangleComponent(
      size: game.size,
      paint: Paint()
        ..color = Colors.purpleAccent.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50),
    );
    glow.add(
      OpacityEffect.to(
        0,
        EffectController(duration: 1.5, curve: Curves.easeOut),
      ),
    );
    add(glow);

    // 2. Magical Particle Burst
    final random = Random();
    final center = game.size / 2;
    final particleComponent = ParticleSystemComponent(
      position: center,
      particle: Particle.generate(
        count: 100,
        lifespan: 1.5,
        generator: (i) {
          final speed = 100 + random.nextDouble() * 300;
          final angle = random.nextDouble() * 2 * pi;
          final dx = cos(angle) * speed;
          final dy = sin(angle) * speed;

          final isGold = random.nextBool();
          final color = isGold ? AppConstants.uiGold : Colors.purpleAccent;

          return AcceleratedParticle(
            speed: Vector2(dx, dy),
            acceleration: Vector2(0, 150), // slight gravity
            child: CircleParticle(
              radius: 3 + random.nextDouble() * 5,
              paint: Paint()..color = color.withValues(alpha: 0.9),
            ),
          );
        },
      ),
    );
    add(particleComponent);

    // Self Cleanup
    add(RemoveEffect(delay: 2.0));
  }
}
