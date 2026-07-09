class LevelSessionStats {
  int solvedPotionCount = 0;
  int comboBonusEarned = 0;
  int highestCombo = 0;
  int undoUsedCount = 0;

  void reset() {
    solvedPotionCount = 0;
    comboBonusEarned = 0;
    highestCombo = 0;
    undoUsedCount = 0;
  }

  void updateHighestCombo(int combo) {
    if (combo > highestCombo) {
      highestCombo = combo;
    }
  }

  int calculateStars() {
    if (undoUsedCount == 0 && highestCombo >= 2) return 3;
    if (undoUsedCount <= 2) return 2;
    return 1;
  }
}
