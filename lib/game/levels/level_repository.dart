import 'level_model.dart';
import 'level_generator.dart';

class LevelRepository {
  // We no longer need the hardcoded _levels list.

  static LevelModel getLevel(int index) {
    // Pro Tip: You could still check a JSON file for "boss levels"
    // and use the generator for everything else.
    return LevelGenerator.generate(index);
  }

  // To support your UI map
  static int get maxLevels => 1000;
}
