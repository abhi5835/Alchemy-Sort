import 'dart:math';

class ComboManager {
  int _combo = 0;

  int get combo => _combo;

  void registerMove() {
    _combo++;
  }

  void reset() {
    _combo = 0;
  }

  int calculateBonus() {
    if (_combo <= 1) return 0;
    return min((_combo - 1) * 5, 20);
  }
}
