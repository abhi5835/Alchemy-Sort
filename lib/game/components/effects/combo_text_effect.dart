import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class ComboTextEffect extends PositionComponent {
  final int combo;

  ComboTextEffect({required this.combo}) : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    String text;
    if (combo == 2) {
      text = 'GOOD!';
    } else if (combo == 3) {
      text = 'GREAT!';
    } else if (combo == 4) {
      text = 'MAGICAL!';
    } else {
      text = 'ALCHEMY COMBO ×$combo';
    }

    final textStyle = TextPaint(
      style: const TextStyle(
        color: Colors.orangeAccent,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        shadows: [Shadow(color: Colors.black, blurRadius: 4)],
      ),
    );

    final textComponent = TextComponent(
      text: text,
      textRenderer: textStyle,
      anchor: Anchor.center,
    );

    // Initial scale 0 for pop-in effect
    textComponent.scale = Vector2.zero();

    // Scale in
    textComponent.add(
      ScaleEffect.to(
        Vector2.all(1.2),
        EffectController(duration: 0.2, curve: Curves.easeOutBack),
      ),
    );

    // Float up
    textComponent.add(
      MoveEffect.by(
        Vector2(0, -30),
        EffectController(duration: 0.8, curve: Curves.easeOut),
      ),
    );

    // Shrink out instead of fade out (TextComponent does not support OpacityEffect)
    textComponent.add(
      ScaleEffect.to(
        Vector2.zero(),
        EffectController(duration: 0.6, startDelay: 0.2, curve: Curves.easeIn),
      ),
    );

    add(textComponent);

    // Self Cleanup
    add(RemoveEffect(delay: 0.9));
  }
}
