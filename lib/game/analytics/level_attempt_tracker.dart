class LevelAttemptTracker {
  final String sessionId;
  final int levelIndex;
  final int levelNumber;
  DateTime? _intervalStart;
  Duration _accumulatedDuration = Duration.zero;

  int moveCount = 0;
  int undoCount = 0;
  int restartCount = 0;

  LevelAttemptTracker({
    required this.sessionId,
    required this.levelIndex,
    required this.restartCount,
  }) : levelNumber = levelIndex + 1 {
    _intervalStart = DateTime.now();
  }

  void pause() {
    if (_intervalStart != null) {
      _accumulatedDuration += DateTime.now().difference(_intervalStart!);
      _intervalStart = null;
    }
  }

  void resume() {
    _intervalStart ??= DateTime.now();
  }

  Duration get elapsedDuration {
    var total = _accumulatedDuration;
    if (_intervalStart != null) {
      total += DateTime.now().difference(_intervalStart!);
    }
    return total;
  }

  void recordMove() {
    moveCount++;
  }

  void recordUndo() {
    undoCount++;
  }
}
