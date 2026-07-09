import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/local/database/app_database.dart';

class GameManager {
  static final GameManager _instance = GameManager._internal();

  factory GameManager() {
    return _instance;
  }

  GameManager._internal();

  SharedPreferences? _prefs;
  AppDatabase? _db;

  Future<void> init(AppDatabase db) async {
    _db = db;
    _prefs = await SharedPreferences.getInstance();

    // Read UI state
    currentLevelIndex.value = _prefs?.getInt('current_level') ?? 0;

    // Read persistent game state from Drift
    final progress = await _db!.playerProgressDao.getProgress();
    keyUnlockedLevelIndex.value = progress.highestUnlockedLevelIndex;
    score.value = progress.totalScore;
  }

  AppDatabase get database {
    if (_db == null) throw Exception('Database not initialized');
    return _db!;
  }

  // State
  final ValueNotifier<int> currentLevelIndex = ValueNotifier(0);
  final ValueNotifier<int> keyUnlockedLevelIndex = ValueNotifier(0);

  // Derived getters for clarity
  int get highestCompletedLevelNumber => keyUnlockedLevelIndex.value;

  void setLevel(int index) {
    currentLevelIndex.value = index;
    _prefs?.setInt('current_level', index);
  }

  void unlockNextLevel() {
    if (currentLevelIndex.value >= keyUnlockedLevelIndex.value) {
      keyUnlockedLevelIndex.value = currentLevelIndex.value + 1;
      _db?.playerProgressDao.updateUnlockedLevel(keyUnlockedLevelIndex.value);
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
    _db?.playerProgressDao.updateScore(score.value);
  }

  void resetScore() {
    score.value = 0;
    _db?.playerProgressDao.updateScore(0);
  }

  bool isLevelUnlocked(int index) {
    return index <= keyUnlockedLevelIndex.value;
  }
}
