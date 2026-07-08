import '../../core/constants/app_constants.dart';
import '../../game/components/tube/tube_component.dart';
import '../../game/components/tube/tube_logic.dart';
import 'level_model.dart';

class LevelLoader {
  static List<TubeComponent> loadLevel(LevelModel level) {
    final List<TubeComponent> components = [];

    for (final liquidColors in level.tubes) {
      final logic = TubeLogic(
        capacity: AppConstants.tubeCapacity,
        initialLiquids: liquidColors,
      );

      // Position logic will be handled by the caller (GameWorld)
      components.add(TubeComponent(logic: logic));
    }
    return components;
  }
}
