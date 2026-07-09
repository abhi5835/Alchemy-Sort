class AnimationUtils {
  /// Safely calculates a staggered interval start time that is mathematically
  /// guaranteed to remain inside [0.0, 1.0].
  /// [animationSpan] is the percentage of the controller's time to distribute items over (e.g. 0.5)
  static double normalizedIntervalStart({
    required int index,
    required int itemCount,
    required double animationSpan,
  }) {
    if (itemCount <= 1) return 0.0;

    // Ensure span itself doesn't exceed 1.0
    final validSpan = animationSpan.clamp(0.0, 1.0);

    final step = validSpan / itemCount;
    return (index * step).clamp(0.0, 1.0 - step);
  }
}
