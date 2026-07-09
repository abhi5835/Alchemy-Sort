enum GraphicsQuality { high, balanced, batterySaver }

enum FrameRatePreference { standard, highRefresh }

class PlayerSettings {
  final bool musicEnabled;
  final bool sfxEnabled;
  final bool hapticsEnabled;
  final GraphicsQuality graphicsQuality;
  final FrameRatePreference frameRate;

  const PlayerSettings({
    this.musicEnabled = true,
    this.sfxEnabled = true,
    this.hapticsEnabled = true,
    this.graphicsQuality = GraphicsQuality.high,
    this.frameRate = FrameRatePreference.standard,
  });

  PlayerSettings copyWith({
    bool? musicEnabled,
    bool? sfxEnabled,
    bool? hapticsEnabled,
    GraphicsQuality? graphicsQuality,
    FrameRatePreference? frameRate,
  }) {
    return PlayerSettings(
      musicEnabled: musicEnabled ?? this.musicEnabled,
      sfxEnabled: sfxEnabled ?? this.sfxEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      graphicsQuality: graphicsQuality ?? this.graphicsQuality,
      frameRate: frameRate ?? this.frameRate,
    );
  }
}
