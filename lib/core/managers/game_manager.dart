import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameManager {
  static final GameManager _instance = GameManager._internal();

  factory GameManager() {
    return _instance;
  }

  GameManager._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    currentLevelIndex.value = _prefs?.getInt('current_level') ?? 0;
    keyUnlockedLevelIndex.value = _prefs?.getInt('unlocked_level') ?? 0;
    score.value = _prefs?.getInt('score') ?? 0;
  }

  // State
  final ValueNotifier<int> currentLevelIndex = ValueNotifier(0);
  final ValueNotifier<int> keyUnlockedLevelIndex = ValueNotifier(0);

  void setLevel(int index) {
    currentLevelIndex.value = index;
    _prefs?.setInt('current_level', index);
  }

  void unlockNextLevel() {
    if (currentLevelIndex.value >= keyUnlockedLevelIndex.value) {
      keyUnlockedLevelIndex.value = currentLevelIndex.value + 1;
      _prefs?.setInt('unlocked_level', keyUnlockedLevelIndex.value);
    }
  }

  void nextLevel() {
    currentLevelIndex.value++;
    _prefs?.setInt('current_level', currentLevelIndex.value);
  }

  // Score
  final ValueNotifier<int> score = ValueNotifier(0);

  void addScore(int amount) {
    score.value += amount;
    _prefs?.setInt('score', score.value);
  }

  void resetScore() {
    score.value = 0;
    _prefs?.setInt('score', 0);
  }

  bool isLevelUnlocked(int index) {
    return index <= keyUnlockedLevelIndex.value;
  }
}
