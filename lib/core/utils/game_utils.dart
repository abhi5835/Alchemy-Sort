import 'dart:math';
import 'package:flutter/material.dart';

class GameUtils {
  static final Random _random = Random();

  /// Generates a random color.
  static Color getRandomColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
    );
  }

  /// Shuffles a list in place.
  static void shuffle<T>(List<T> list) {
    list.shuffle(_random);
  }
}
