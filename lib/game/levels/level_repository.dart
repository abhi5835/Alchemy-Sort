import 'dart:ui';
import 'level_model.dart';
import 'level_generator.dart';

class LevelRepository {
  static final Map<int, LevelModel> _levelCache = {};

  static LevelModel getLevel(int index) {
    if (!_levelCache.containsKey(index)) {
      _levelCache[index] = LevelGenerator.generate(index);
    }

    // Return a deep copy so mutable tube state doesn't pollute the cached immutable definition
    final cached = _levelCache[index]!;
    final copiedTubes = cached.tubes
        .map((tube) => List<Color>.from(tube))
        .toList();

    return LevelModel(
      levelNumber: cached.levelNumber,
      tubes: copiedTubes,
      palette: List<Color>.from(cached.palette),
    );
  }

  // To support your UI map
  static int get maxLevels => 1000;
}
