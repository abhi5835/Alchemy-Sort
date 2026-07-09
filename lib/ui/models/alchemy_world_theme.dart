import 'package:flutter/material.dart';

class AlchemyWorldTheme {
  final String name;
  final String? subtitle;
  final int startLevel;
  final int endLevel;
  final List<Color> backgroundGradient;
  final Color pathCenterColor;
  final Color pathEdgeColor;
  final Color nodeBaseColor;
  final Color nodeAccentColor;

  const AlchemyWorldTheme({
    required this.name,
    this.subtitle,
    required this.startLevel,
    required this.endLevel,
    required this.backgroundGradient,
    required this.pathCenterColor,
    required this.pathEdgeColor,
    required this.nodeBaseColor,
    required this.nodeAccentColor,
  });

  static const List<AlchemyWorldTheme> worlds = [
    AlchemyWorldTheme(
      name: 'MYSTIC GARDEN',
      subtitle: 'The First Brews',
      startLevel: 1,
      endLevel: 20,
      backgroundGradient: [
        Color(0xFF2B1B4D), // Dark purple
        Color(0xFF432C7A), // Mid purple
        Color(0xFF1E3D59), // Soft cyan
      ],
      pathCenterColor: Colors.white,
      pathEdgeColor: Color(0xFFA67CFF), // Soft purple
      nodeBaseColor: Color(0xFF5E35B1),
      nodeAccentColor: Color(0xFF8E24AA),
    ),
    AlchemyWorldTheme(
      name: 'CRYSTAL CAVES',
      subtitle: 'Crystal Secrets',
      startLevel: 21,
      endLevel: 40,
      backgroundGradient: [
        Color(0xFF0D1B2A), // Dark blue
        Color(0xFF1B263B), // Navy
        Color(0xFF00B4D8), // Cyan glow
      ],
      pathCenterColor: Colors.white,
      pathEdgeColor: Color(0xFF00E5FF), // Bright cyan
      nodeBaseColor: Color(0xFF0277BD),
      nodeAccentColor: Color(0xFF00BCD4),
    ),
    AlchemyWorldTheme(
      name: 'MOONLIGHT LAB',
      subtitle: 'Moonlit Experiments',
      startLevel: 41,
      endLevel: 60,
      backgroundGradient: [
        Color(0xFF120E26), // Deep violet
        Color(0xFF231C44),
        Color(0xFF673AB7), // Vibrant purple
      ],
      pathCenterColor: Color(0xFFFFF8E7), // Warm cream
      pathEdgeColor: Color(0xFFD500F9), // Magenta
      nodeBaseColor: Color(0xFF4527A0),
      nodeAccentColor: Color(0xFF9C27B0),
    ),
    AlchemyWorldTheme(
      name: 'DRAGON ALCHEMY',
      subtitle: 'Fiery Concoctions',
      startLevel: 61,
      endLevel: 80,
      backgroundGradient: [
        Color(0xFF2C0703), // Dark red/brown
        Color(0xFF4A1010),
        Color(0xFFFF5722), // Deep orange glow
      ],
      pathCenterColor: Color(0xFFFFF9C4), // Light yellow
      pathEdgeColor: Color(0xFFFF3D00), // Fiery orange
      nodeBaseColor: Color(0xFFC62828),
      nodeAccentColor: Color(0xFFF4511E),
    ),
    AlchemyWorldTheme(
      name: 'ENCHANTED SWAMP',
      subtitle: 'Murky Magic',
      startLevel: 81,
      endLevel: 100,
      backgroundGradient: [
        Color(0xFF0B2117), // Dark green
        Color(0xFF163C2E),
        Color(0xFF00E676), // Toxic green glow
      ],
      pathCenterColor: Color(0xFFE8F5E9),
      pathEdgeColor: Color(0xFF00C853),
      nodeBaseColor: Color(0xFF2E7D32),
      nodeAccentColor: Color(0xFF43A047),
    ),
    AlchemyWorldTheme(
      name: 'CELESTIAL TOWER',
      subtitle: 'Starry Solutions',
      startLevel: 101,
      endLevel: 120,
      backgroundGradient: [
        Color(0xFF050B14), // Almost black blue
        Color(0xFF0A1835),
        Color(0xFF2962FF), // Royal blue glow
      ],
      pathCenterColor: Colors.white,
      pathEdgeColor: Color(0xFFFFD700), // Gold
      nodeBaseColor: Color(0xFF1565C0),
      nodeAccentColor: Color(0xFF42A5F5),
    ),
  ];

  static AlchemyWorldTheme getThemeForLevel(int level) {
    for (final theme in worlds) {
      if (level >= theme.startLevel && level <= theme.endLevel) {
        return theme;
      }
    }
    // Fallback if level exceeds 120 currently
    return worlds.last;
  }
}
