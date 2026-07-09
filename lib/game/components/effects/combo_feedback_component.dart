import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/managers/audio_manager.dart';

class ComboFeedbackComponent extends PositionComponent with HasPaint {
  final int combo;
  late TextComponent _primaryText;

  ComboFeedbackComponent({required this.combo}) {
    priority = 100; // Render above all other world components
  }

  @override
  Future<void> onLoad() async {
    String primaryMsg;
    if (combo == 2) {
      primaryMsg = "GOOD!";
    } else if (combo == 3) {
      primaryMsg = "GREAT!";
    } else if (combo == 4) {
      primaryMsg = "MAGICAL!";
    } else {
      primaryMsg = "ALCHEMY COMBO ×$combo";
    }

    final primaryPaint = TextPaint(
      style: const TextStyle(
        color: AppConstants.uiGold,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(color: Colors.black54, offset: Offset(2, 2), blurRadius: 4),
        ],
      ),
    );

    _primaryText = TextComponent(
      text: primaryMsg,
      textRenderer: primaryPaint,
      anchor: Anchor.center,
    );

    add(_primaryText);

    // Initial state
    scale = Vector2.all(0.75);

    // Animation: Scale in (0.75 -> 1.1 -> 1.0) and fade in, then float up and fade out
    add(
      SequenceEffect([
        ScaleEffect.to(Vector2.all(1.1), EffectController(duration: 0.15)),
        ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.1)),
        ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.5)),
      ]),
    );

    // Make text fade out manually via an OpacityProvider if needed, but since TextComponent in flame 1.x doesn't directly support OpacityEffect without HasPaint, we can use a wrapper or just let them disappear. Wait, TextComponent uses TextPaint. TextPaint opacity can be tricky. Let's just scale and move it up, then remove it.
    // Wait, let's use the Flame 1.x standard approach:
    add(
      MoveEffect.by(
        Vector2(0, -20),
        EffectController(startDelay: 0.75, duration: 0.3),
      )..onComplete = removeFromParent,
    );

    // Audio delayed slightly to avoid colliding with potion complete sound
    add(
      TimerComponent(
        period: 0.15,
        removeOnFinish: true,
        onTick: () {
          AudioManager().playCombo();
        },
      ),
    );
  }
}
