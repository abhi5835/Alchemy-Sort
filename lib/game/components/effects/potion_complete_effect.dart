import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class PotionCompleteEffect extends PositionComponent {
  PotionCompleteEffect() : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // 1. Glow Effect
    final glow = CircleComponent(
      radius: 40,
      paint: Paint()
        ..color = Colors.purpleAccent.withValues(alpha: 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
      anchor: Anchor.center,
    );

    glow.add(
      ScaleEffect.by(
        Vector2.all(1.5),
        EffectController(duration: 0.4, curve: Curves.easeOut),
      ),
    );
    glow.add(
      OpacityEffect.to(
        0,
        EffectController(duration: 0.4, curve: Curves.easeOut),
      ),
    );
    add(glow);

    // 2. Floating Text
    final textStyle = TextPaint(
      style: const TextStyle(
        color: Colors.amber,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        shadows: [Shadow(color: Colors.black54, blurRadius: 3)],
      ),
    );

    final floatingText = TextComponent(
      text: 'POTION COMPLETE\n+50',
      textRenderer: textStyle,
      anchor: Anchor.center,
    );

    floatingText.add(
      MoveEffect.by(
        Vector2(0, -40),
        EffectController(duration: 0.9, curve: Curves.easeOut),
      ),
    );
    floatingText.add(
      ScaleEffect.to(
        Vector2.zero(),
        EffectController(duration: 0.9, curve: Curves.easeIn),
      ),
    );
    add(floatingText);

    // 3. Mystical Particles
    final random = Random();
    final particleComponent = ParticleSystemComponent(
      particle: Particle.generate(
        count: 20,
        lifespan: 0.6,
        generator: (i) {
          final speed = 30 + random.nextDouble() * 50;
          final angle = random.nextDouble() * 2 * pi;
          final dx = cos(angle) * speed;
          final dy = sin(angle) * speed;
          return AcceleratedParticle(
            speed: Vector2(dx, dy),
            child: CircleParticle(
              radius: 2 + random.nextDouble() * 3,
              paint: Paint()..color = Colors.amber.withValues(alpha: 0.8),
            ),
          );
        },
      ),
    );
    add(particleComponent);

    // Self Cleanup
    add(RemoveEffect(delay: 1.0));
  }
}
