import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/player_profile.dart';
import '../../data/models/player_settings.dart';
import 'audio_manager.dart';

class SettingsManager {
  static final SettingsManager _instance = SettingsManager._internal();
  factory SettingsManager() => _instance;
  SettingsManager._internal();

  SharedPreferences? _prefs;

  final ValueNotifier<PlayerSettings> settingsNotifier = ValueNotifier(
    const PlayerSettings(),
  );
  final ValueNotifier<PlayerProfile> profileNotifier = ValueNotifier(
    const PlayerProfile(),
  );

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    _prefs = await SharedPreferences.getInstance();

    _loadSettings();
    _loadProfile();

    _isInitialized = true;
  }

  void _loadSettings() {
    final prefs = _prefs;
    if (prefs == null) return;

    // Populate from AudioManager
    final musicEnabled = AudioManager().isMusicEnabled;
    final sfxEnabled = AudioManager().isSfxEnabled;

    final hapticsEnabled = prefs.getBool('is_haptics_enabled') ?? true;

    final graphicsIndex =
        prefs.getInt('graphics_quality') ?? GraphicsQuality.high.index;
    final graphicsQuality = GraphicsQuality.values.firstWhere(
      (e) => e.index == graphicsIndex,
      orElse: () => GraphicsQuality.high,
    );

    final frameRateIndex =
        prefs.getInt('frame_rate_preference') ??
        FrameRatePreference.standard.index;
    final frameRate = FrameRatePreference.values.firstWhere(
      (e) => e.index == frameRateIndex,
      orElse: () => FrameRatePreference.standard,
    );

    settingsNotifier.value = PlayerSettings(
      musicEnabled: musicEnabled,
      sfxEnabled: sfxEnabled,
      hapticsEnabled: hapticsEnabled,
      graphicsQuality: graphicsQuality,
      frameRate: frameRate,
    );
  }

  void _loadProfile() {
    final prefs = _prefs;
    if (prefs == null) return;

    final displayName = prefs.getString('profile_display_name') ?? 'Alchemist';
    final avatarIcon = prefs.getString('profile_avatar_icon') ?? 'science';
    final totalPotionsCreated = prefs.getInt('profile_total_potions') ?? 0;

    profileNotifier.value = PlayerProfile(
      displayName: displayName,
      avatarIcon: avatarIcon,
      totalPotionsCreated: totalPotionsCreated,
    );
  }

  Future<void> updateSettings(PlayerSettings newSettings) async {
    settingsNotifier.value = newSettings;
    final prefs = _prefs;
    if (prefs != null) {
      await prefs.setBool('is_haptics_enabled', newSettings.hapticsEnabled);
      await prefs.setInt('graphics_quality', newSettings.graphicsQuality.index);
      await prefs.setInt('frame_rate_preference', newSettings.frameRate.index);
    }
  }

  Future<void> updateProfile(PlayerProfile newProfile) async {
    profileNotifier.value = newProfile;
    final prefs = _prefs;
    if (prefs != null) {
      await prefs.setString('profile_display_name', newProfile.displayName);
      await prefs.setString('profile_avatar_icon', newProfile.avatarIcon);
      await prefs.setInt(
        'profile_total_potions',
        newProfile.totalPotionsCreated,
      );
    }
  }

  Future<void> incrementPotionsCreated(int count) async {
    final updated = profileNotifier.value.copyWith(
      totalPotionsCreated: profileNotifier.value.totalPotionsCreated + count,
    );
    await updateProfile(updated);
  }
}
