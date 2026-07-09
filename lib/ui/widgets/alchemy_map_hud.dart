import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/managers/game_manager.dart';
import '../../core/managers/settings_manager.dart';
import '../../core/managers/audio_manager.dart';
import '../../data/models/player_profile.dart';

class AlchemyMapHud extends StatelessWidget {
  final VoidCallback onAvatarTap;

  const AlchemyMapHud({super.key, required this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Left: Profile Avatar
            ValueListenableBuilder<PlayerProfile>(
              valueListenable: SettingsManager().profileNotifier,
              builder: (context, profile, child) {
                return GestureDetector(
                  onTap: () {
                    AudioManager().playButtonClick();
                    onAvatarTap();
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1E293B),
                      border: Border.all(
                        color: AppTheme.accentGold,
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      _getIconData(profile.avatarIcon),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(width: 12),

            // Center/Left: Game Identity
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ALCHEMY',
                    style: GoogleFonts.cinzel(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.8),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'WORLD',
                    style: GoogleFonts.cinzel(
                      color: AppTheme.accentGold,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 3.0,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.8),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Right: Star Score
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF161B28),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: Color(0xFFFFD700),
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  ValueListenableBuilder<int>(
                    valueListenable: GameManager().score,
                    builder: (context, score, child) {
                      return Text(
                        '$score',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFFFFD700),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'science':
        return Icons.science;
      case 'auto_awesome':
        return Icons.auto_awesome;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'star':
        return Icons.star;
      case 'pets':
        return Icons.pets;
      default:
        return Icons.person;
    }
  }
}
