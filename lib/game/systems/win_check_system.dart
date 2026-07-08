import '../components/tube/tube_component.dart';

class WinCheckSystem {
  static bool checkWin(List<TubeComponent> tubes) {
    for (final tube in tubes) {
      if (!tube.logic.isSolved) {
        return false;
      }
    }
    return true;
  }
}
