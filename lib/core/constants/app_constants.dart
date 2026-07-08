import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Alchemy Sort';

  // Game Configuration
  static const double tubeWidth = 50.0;
  static const double tubeHeight = 200.0;
  static const int tubeCapacity = 4;
  // Reserve 10% of height as empty space at the top
  static final double liquidSegmentHeight = (tubeHeight * 0.9) / tubeCapacity;
  static const double tubeSpacing = 20.0;

  // Colors
  // Colors
  static const Color primaryColor = Color(0xFF2E0249);
  static const Color accentColor = Color(0xFFA91079);
  static const Color backgroundColor = Color(0xFF1A1A2E); // Darker Blue/Purple
  static const Color tubeColor = Color(0x22FFFFFF); // More transparent
  static const Color tubeBorderColor = Color(0x44FFFFFF);

  // UI Colors
  static const Color uiGold = Color(0xFFFFD700);
  static const Color uiPurple = Color(0xFF5D12D2);
  static const Color uiDarkPurple = Color(0xFF16213E);

  // Master Alchemist Theme
  static const Color textGold = Color(0xFFFFD700);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color pillBackground = Color(0xFF2A1B3D);
  static const Color iconBackground = Color(0xFF2A1B3D);
  static const Color bottomBarGradientStart = Color(0xFF1A1A2E);
  static const Color bottomBarGradientEnd = Color(0xFF16213E);
  static const Color mainActionBtnGradientStart = Color(0xFF8A2BE2);
  static const Color mainActionBtnGradientEnd = Color(0xFF4B0082);

  // Liquid Colors
  static const List<Color> liquidColors = [
    Color(0xFFE53935), // Red
    Color(0xFF1E88E5), // Blue
    Color(0xFF43A047), // Green
    Color(0xFFFDD835), // Yellow
    Color(0xFF8E24AA), // Purple
    Color(0xFFFB8C00), // Orange
    Color(0xFF00ACC1), // Cyan
    Color(0xFFD81B60), // Pink
  ];
}
