import 'dart:math';
import '../levels/level_repository.dart';

class DailyChallenge {
  final String dateKey;
  final int seed;
  final int sourceLevelIndex;

  const DailyChallenge({
    required this.dateKey,
    required this.seed,
    required this.sourceLevelIndex,
  });
}

class DailyChallengeGenerator {
  /// Minimum normal level index to use as a source pool for daily challenges.
  /// Set to 9 (Level 10) to avoid tutorial-style levels.
  static const int minSourceLevelIndex = 9;

  /// Maximum normal level index to use as a source pool.
  static final int maxSourceLevelIndex = min(
    149,
    LevelRepository.maxLevels - 1,
  );

  /// Deterministically generates a DailyChallenge for the given date.
  static DailyChallenge generate(DateTime date) {
    // 1. Calculate a stable deterministic seed
    // Using simple integer arithmetic so it's immune to String.hashCode changes.
    final localDate = date.toLocal();
    final seed =
        (localDate.year * 10000) + (localDate.month * 100) + localDate.day;

    // 2. Select the source level index deterministically
    final random = Random(seed);

    // Generate a number between 0 and (max - min) inclusive
    final poolSize = maxSourceLevelIndex - minSourceLevelIndex + 1;
    final randomOffset = random.nextInt(poolSize);
    final sourceLevelIndex = minSourceLevelIndex + randomOffset;

    // 3. Format the dateKey
    final year = localDate.year.toString().padLeft(4, '0');
    final month = localDate.month.toString().padLeft(2, '0');
    final day = localDate.day.toString().padLeft(2, '0');
    final dateKey = '$year-$month-$day';

    return DailyChallenge(
      dateKey: dateKey,
      seed: seed,
      sourceLevelIndex: sourceLevelIndex,
    );
  }
}
