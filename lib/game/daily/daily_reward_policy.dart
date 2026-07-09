class DailyRewardResult {
  final int baseXp;
  final int starBonusXp;
  final int streakBonusXp;

  const DailyRewardResult({
    required this.baseXp,
    required this.starBonusXp,
    required this.streakBonusXp,
  });

  int get totalXp => baseXp + starBonusXp + streakBonusXp;
  
  bool get hasMilestoneBonus => streakBonusXp > 0;
}

class DailyRewardPolicy {
  static const int baseXp = 150;

  static int calculateStarBonus(int stars) {
    switch (stars) {
      case 3:
        return 50;
      case 2:
        return 25;
      default:
        return 0;
    }
  }

  static int calculateStreakBonus(int streak) {
    if (streak <= 0) return 0;
    
    // Precedence: Monthly bonus overrides Weekly bonus
    if (streak % 30 == 0) {
      return 500;
    } else if (streak % 7 == 0) {
      return 100;
    }
    
    return 0;
  }

  static DailyRewardResult calculateReward({
    required int stars,
    required int newStreak,
  }) {
    return DailyRewardResult(
      baseXp: baseXp,
      starBonusXp: calculateStarBonus(stars),
      streakBonusXp: calculateStreakBonus(newStreak),
    );
  }
}
