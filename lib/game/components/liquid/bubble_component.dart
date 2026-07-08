import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class BubbleComponent extends CircleComponent {
  BubbleComponent(Color color)
    : super(
        radius: 3 + Random().nextDouble() * 3,
        paint: Paint()..color = color.withValues(alpha: 0.6),
      );
}
