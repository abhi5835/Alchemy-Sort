import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/managers/settings_manager.dart';
import '../../core/managers/game_manager.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/player_profile.dart';
import '../../data/models/player_settings.dart';
import '../../core/managers/audio_manager.dart';
import '../../core/managers/potion_collection_manager.dart';
import '../../game/potions/potion_repository.dart';
import 'potion_book_screen.dart';

class ProfileScreen extends StatelessWidget {
  final bool embedded;
  const ProfileScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'ALCHEMIST PROFILE',
          style: GoogleFonts.outfit(
            color: AppTheme.accentGold,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
        leading: embedded
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: AppTheme.accentGold),
                onPressed: () {
                  AudioManager().playButtonClick();
                  Navigator.of(context).pop();
                },
              ),
      ),
      body: ValueListenableBuilder<PlayerProfile>(
        valueListenable: SettingsManager().profileNotifier,
        builder: (context, profile, child) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: [
              _buildProfileHeader(context, profile),
              const SizedBox(height: 30),
              _buildStatsSection(),
              const SizedBox(height: 20),
              _buildPotionBookButton(context),
              const SizedBox(height: 30),
              _buildSettingsSection(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, PlayerProfile profile) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1E293B),
                border: Border.all(color: AppTheme.accentGold, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentGold.withValues(alpha: 0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                _getIconData(profile.avatarIcon),
                size: 50,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {
                AudioManager().playButtonClick();
                _showAvatarPicker(context);
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppTheme.accentGold,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, size: 16, color: Colors.black),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              profile.displayName,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white54, size: 20),
              onPressed: () {
                AudioManager().playButtonClick();
                _showNameEditor(context, profile.displayName);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CAREER STATS',
            style: GoogleFonts.outfit(
              color: Colors.white54,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ValueListenableBuilder<int>(
                valueListenable: GameManager().keyUnlockedLevelIndex,
                builder: (context, levelIndex, child) {
                  return _StatItem(
                    label: 'LEVEL',
                    value: '${levelIndex + 1}',
                    icon: Icons.stairs,
                    color: Colors.blueAccent,
                  );
                },
              ),
              ValueListenableBuilder<int>(
                valueListenable: GameManager().score,
                builder: (context, score, child) {
                  return _StatItem(
                    label: 'SCORE',
                    value: '$score',
                    icon: Icons.star,
                    color: AppTheme.accentGold,
                  );
                },
              ),
              ValueListenableBuilder<PlayerProfile>(
                valueListenable: SettingsManager().profileNotifier,
                builder: (context, profile, child) {
                  return _StatItem(
                    label: 'POTIONS',
                    value: '${profile.totalPotionsCreated}',
                    icon: Icons.science,
                    color: Colors.purpleAccent,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPotionBookButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AudioManager().playButtonClick();
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const PotionBookScreen()));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2633),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentGold.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.accentGold.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Text('🧪', style: TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'POTION BOOK',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'View discovered recipes',
                    style: GoogleFonts.outfit(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            ValueListenableBuilder<Set<String>>(
              valueListenable: PotionCollectionManager().discoveredPotionIds,
              builder: (context, discovered, child) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${discovered.length}/${PotionRepository.totalPotionCount}',
                    style: GoogleFonts.outfit(
                      color: AppTheme.accentGold,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white24,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return ValueListenableBuilder<PlayerSettings>(
      valueListenable: SettingsManager().settingsNotifier,
      builder: (context, settings, child) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'SETTINGS',
                  style: GoogleFonts.outfit(
                    color: Colors.white54,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const Divider(color: Colors.white10, height: 1),
              ValueListenableBuilder<bool>(
                valueListenable: AudioManager().musicEnabledNotifier,
                builder: (context, musicEnabled, child) {
                  return SwitchListTile(
                    title: const Text(
                      'Music',
                      style: TextStyle(color: Colors.white),
                    ),
                    secondary: const Icon(
                      Icons.music_note,
                      color: Colors.white70,
                    ),
                    value: musicEnabled,
                    activeTrackColor: AppTheme.accentGold,
                    onChanged: (val) {
                      AudioManager().playButtonClick();
                      AudioManager().setMusicEnabled(val);
                      // Update snapshot
                      SettingsManager().updateSettings(
                        settings.copyWith(musicEnabled: val),
                      );
                    },
                  );
                },
              ),
              ValueListenableBuilder<bool>(
                valueListenable: AudioManager().sfxEnabledNotifier,
                builder: (context, sfxEnabled, child) {
                  return SwitchListTile(
                    title: const Text(
                      'Sound Effects',
                      style: TextStyle(color: Colors.white),
                    ),
                    secondary: const Icon(
                      Icons.volume_up,
                      color: Colors.white70,
                    ),
                    value: sfxEnabled,
                    activeTrackColor: AppTheme.accentGold,
                    onChanged: (val) {
                      AudioManager().playButtonClick();
                      AudioManager().setSfxEnabled(val);
                      // Update snapshot
                      SettingsManager().updateSettings(
                        settings.copyWith(sfxEnabled: val),
                      );
                    },
                  );
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Haptics',
                  style: TextStyle(color: Colors.white),
                ),
                secondary: const Icon(Icons.vibration, color: Colors.white70),
                value: settings.hapticsEnabled,
                activeTrackColor: AppTheme.accentGold,
                onChanged: (val) {
                  AudioManager().playButtonClick();
                  SettingsManager().updateSettings(
                    settings.copyWith(hapticsEnabled: val),
                  );
                },
              ),
              const Divider(color: Colors.white10, height: 1),
              ListTile(
                title: const Text(
                  'Graphics Quality',
                  style: TextStyle(color: Colors.white),
                ),
                leading: const Icon(Icons.high_quality, color: Colors.white70),
                trailing: DropdownButton<GraphicsQuality>(
                  value: settings.graphicsQuality,
                  dropdownColor: AppTheme.surfaceDark,
                  underline: const SizedBox(),
                  style: const TextStyle(color: AppTheme.accentGold),
                  items: GraphicsQuality.values.map((q) {
                    return DropdownMenuItem(
                      value: q,
                      child: Text(q.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      AudioManager().playButtonClick();
                      SettingsManager().updateSettings(
                        settings.copyWith(graphicsQuality: val),
                      );
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text(
                  'Frame Rate',
                  style: TextStyle(color: Colors.white),
                ),
                leading: const Icon(Icons.speed, color: Colors.white70),
                trailing: DropdownButton<FrameRatePreference>(
                  value: settings.frameRate,
                  dropdownColor: AppTheme.surfaceDark,
                  underline: const SizedBox(),
                  style: const TextStyle(color: AppTheme.accentGold),
                  items: FrameRatePreference.values.map((q) {
                    return DropdownMenuItem(
                      value: q,
                      child: Text(q.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      AudioManager().playButtonClick();
                      SettingsManager().updateSettings(
                        settings.copyWith(frameRate: val),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _showNameEditor(BuildContext context, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceDark,
          title: const Text(
            'Edit Display Name',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.accentGold),
              ),
            ),
            maxLength: 15,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'CANCEL',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            TextButton(
              onPressed: () {
                final newName = controller.text.trim();
                if (newName.isNotEmpty) {
                  final profile = SettingsManager().profileNotifier.value;
                  SettingsManager().updateProfile(
                    profile.copyWith(displayName: newName),
                  );
                }
                Navigator.pop(context);
              },
              child: const Text(
                'SAVE',
                style: TextStyle(color: AppTheme.accentGold),
              ),
            ),
          ],
        );
      },
    ).then((_) {
      controller.dispose();
    });
  }

  void _showAvatarPicker(BuildContext context) {
    final icons = [
      'science',
      'auto_awesome',
      'emoji_events',
      'local_fire_department',
      'star',
      'pets',
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceDark,
          title: const Text(
            'Choose Avatar',
            style: TextStyle(color: Colors.white),
          ),
          content: Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: icons.map((iconName) {
              return GestureDetector(
                onTap: () {
                  final profile = SettingsManager().profileNotifier.value;
                  SettingsManager().updateProfile(
                    profile.copyWith(avatarIcon: iconName),
                  );
                  AudioManager().playButtonClick();
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Icon(
                    _getIconData(iconName),
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
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

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.outfit(
            color: Colors.white54,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}
