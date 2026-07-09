import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static const Color accentGold = Color(0xFFFFD700);
  static const Color accentPurple = Colors.purpleAccent;
  static const Color textLight = Colors.white70;
  static const Color successGreen = Colors.greenAccent;
  static const Color accentOrange = Colors.orangeAccent;
  static const Color surfaceDark = Color(0xFF1a0b2e);
  static const Color backgroundDark = Color(0xFF0F0817);

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppConstants.backgroundColor,
      primaryColor: AppConstants.primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: AppConstants.primaryColor,
        secondary: AppConstants.accentColor,
        surface: AppConstants.backgroundColor,
      ),
      textTheme: GoogleFonts.pressStart2pTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            displayLarge: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            bodyLarge: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
