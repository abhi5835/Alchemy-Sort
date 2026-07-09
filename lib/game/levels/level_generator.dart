import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import 'level_model.dart';

class LevelGenerator {
  static LevelModel generate(int levelIndex) {
    // Seeded random ensures the level is the same every time you play it
    final random = Random(levelIndex);

    // 1. Determine difficulty
    int colorCount;
    int extraTubes;

    if (levelIndex == 0) {
      colorCount = 2; // Trivial 2-color puzzle
      extraTubes = 1;
    } else if (levelIndex == 1) {
      colorCount = 3;
      extraTubes = 2; // Extra forgiving
    } else {
      colorCount = (3 + (levelIndex ~/ 10)).clamp(2, 8);
      extraTubes = levelIndex < 5 ? 1 : 2;
    }
    
    int totalTubes = colorCount + extraTubes;

    // 2. Generate a unique color palette for THIS level
    // We pick random colors or shift Hues to ensure every level looks different
    List<Color> levelPalette = [];
    for (int i = 0; i < colorCount; i++) {
      levelPalette.add(
        HSVColor.fromAHSV(
          1.0,
          (random.nextDouble() * 360), // Random Hue
          0.7 + (random.nextDouble() * 0.3), // High Saturation
          0.6 + (random.nextDouble() * 0.4), // Brightness
        ).toColor(),
      );
    }

    // 3. Create the shuffled liquid data
    List<Color> allLiquids = [];
    for (var color in levelPalette) {
      for (int i = 0; i < AppConstants.tubeCapacity; i++) {
        allLiquids.add(color);
      }
    }
    allLiquids.shuffle(random);

    // 4. Distribute into tubes
    List<List<Color>> tubes = List.generate(totalTubes, (_) => []);
    for (int i = 0; i < allLiquids.length; i++) {
      int tubeIndex = i ~/ AppConstants.tubeCapacity;
      tubes[tubeIndex].add(allLiquids[i]);
    }

    return LevelModel(
      levelNumber: levelIndex + 1,
      tubes: tubes,
      palette: levelPalette,
    );
  }
}
