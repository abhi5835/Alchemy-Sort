import 'dart:ui';

class LevelModel {
  final int levelNumber;
  final List<List<Color>> tubes;
  final List<Color> palette; // Added to track this level's specific colors

  const LevelModel({
    required this.levelNumber,
    required this.tubes,
    required this.palette,
  });
}
