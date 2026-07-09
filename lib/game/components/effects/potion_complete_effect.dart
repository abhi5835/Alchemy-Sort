import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../../../core/managers/settings_manager.dart';
import '../../../data/models/player_settings.dart';

class PotionCompleteEffect extends PositionComponent with HasPaint {
  final Color potionColor;

  static final Random _random = Random();
  late final TextComponent _floatingText;

  PotionCompleteEffect({required this.potionColor})
    : super(anchor: Anchor.center) {
    priority = 100; // Ensure it renders above the liquids
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // 0ms: Subtle magical glow
    // We use a lighter variant of the potion color for the glow
    final hsl = HSLColor.fromColor(potionColor);
    final lighterColor = hsl
        .withLightness((hsl.lightness + 0.2).clamp(0.0, 1.0))
        .toColor();

    final glow = CircleComponent(
      radius: 40,
      paint: Paint()
        ..color = lighterColor.withValues(alpha: 0.5)
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

    // 150-500ms: Particle burst (8-14 particles)
    // Delayed by ~150ms
    add(
      TimerComponent(
        period: 0.15,
        removeOnFinish: true,
        onTick: () {
          _spawnParticles(lighterColor);
        },
      ),
    );

    // 500-900ms: Floating text
    final textStyle = TextPaint(
      style: TextStyle(
        color: lighterColor, // Use potion-derived color
        fontSize: 16,
        fontWeight: FontWeight.bold,
        shadows: const [Shadow(color: Colors.black54, blurRadius: 3)],
      ),
    );

    _floatingText = TextComponent(
      text: 'POTION CREATED!',
      textRenderer: textStyle,
      anchor: Anchor.center,
      position: Vector2(0, -20),
    );

    _floatingText.scale = Vector2.all(0.85);

    // Animate text starting at 500ms
    _floatingText.add(
      SequenceEffect([
        ScaleEffect.to(
          Vector2.all(1.0),
          EffectController(startDelay: 0.5, duration: 0.1),
        ),
      ]),
    );
    _floatingText.add(
      SequenceEffect([
        MoveEffect.by(
          Vector2(0, -25),
          EffectController(
            startDelay: 0.5,
            duration: 0.4,
            curve: Curves.easeOut,
          ),
        ),
      ]),
    );

    // Flame 1.x TextComponent opacity workaround: OpacityEffect works if we use OpacityProvider or just let it vanish via parent.
    // We will just let the parent (this) remove itself at 900ms.
    add(_floatingText);

    // Self Cleanup at ~900ms-1000ms
    add(RemoveEffect(delay: 1.0));
  }

  void _spawnParticles(Color baseColor) {
    final quality = SettingsManager().settingsNotifier.value.graphicsQuality;
    if (quality == GraphicsQuality.batterySaver) return;

    int particleCount = 8 + _random.nextInt(7); // 8 to 14
    if (quality == GraphicsQuality.balanced) {
      particleCount = max(1, particleCount ~/ 2);
    }

    final particleComponent = ParticleSystemComponent(
      particle: Particle.generate(
        count: particleCount,
        lifespan: 0.45 + _random.nextDouble() * 0.3, // 450-750ms
        generator: (i) {
          final speed = 40 + _random.nextDouble() * 60;
          // Adjust angle to be "upward": in Flame, y increases downwards, so we want angles between PI and 2*PI.
          final upAngle = pi + _random.nextDouble() * pi;

          final dx = cos(upAngle) * speed;
          final dy = sin(upAngle) * speed;

          final isVeryLight = _random.nextBool();
          final pColor = isVeryLight ? Colors.white : baseColor;

          return AcceleratedParticle(
            speed: Vector2(dx, dy),
            child: CircleParticle(
              radius: 2 + _random.nextDouble() * 2,
              paint: Paint()..color = pColor.withValues(alpha: 0.8),
            ),
          );
        },
      ),
    );
    add(particleComponent);
  }
}
