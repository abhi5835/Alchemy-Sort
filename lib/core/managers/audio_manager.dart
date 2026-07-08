import 'package:flame_audio/flame_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();

  factory AudioManager() {
    return _instance;
  }

  AudioManager._internal();

  SharedPreferences? _prefs;
  bool _isMusicEnabled = true;
  bool _isSfxEnabled = true;
  String? _currentBgmFile;

  // Volumes
  final double _bgmVolume = 0.22;
  static const double _volSelectVial = 0.45;
  static const double _volPour = 0.35;
  static const double _volPotionComplete = 0.70;
  static const double _volCombo = 0.75;
  static const double _volLevelComplete = 0.80;
  static const double _volButtonClick = 0.40;

  static const String _musicPrefsKey = 'is_music_enabled';
  static const String _sfxPrefsKey = 'is_sfx_enabled';

  bool get isMusicEnabled => _isMusicEnabled;
  bool get isSfxEnabled => _isSfxEnabled;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isMusicEnabled = _prefs?.getBool(_musicPrefsKey) ?? true;
    _isSfxEnabled = _prefs?.getBool(_sfxPrefsKey) ?? true;

    FlameAudio.bgm.initialize();

    // Preload SFX
    await FlameAudio.audioCache.loadAll([
      'sfx/select_vial.wav',
      'sfx/pour.wav',
      'sfx/potion_complete.wav',
      'sfx/combo.wav',
      'sfx/level_complete.wav',
      'sfx/button_click.wav',
    ]);
  }

  Future<void> playBgm(String filename) async {
    if (_currentBgmFile == filename && FlameAudio.bgm.isPlaying) {
      return; // Prevent duplicate playback
    }
    _currentBgmFile = filename;

    if (_isMusicEnabled) {
      await FlameAudio.bgm.stop(); // Stop previous if any
      await FlameAudio.bgm.play(filename, volume: _bgmVolume);
    }
  }

  Future<void> pauseBgm() async {
    await FlameAudio.bgm.pause();
  }

  Future<void> resumeBgm() async {
    if (_isMusicEnabled && _currentBgmFile != null) {
      await FlameAudio.bgm.resume();
    }
  }

  Future<void> stopBgm() async {
    await FlameAudio.bgm.stop();
    _currentBgmFile = null;
  }

  Future<void> setMusicEnabled(bool enabled) async {
    _isMusicEnabled = enabled;
    await _prefs?.setBool(_musicPrefsKey, enabled);

    if (enabled) {
      if (_currentBgmFile != null) {
        await playBgm(_currentBgmFile!);
      }
    } else {
      await pauseBgm();
    }
  }

  Future<void> setSfxEnabled(bool enabled) async {
    _isSfxEnabled = enabled;
    await _prefs?.setBool(_sfxPrefsKey, enabled);
  }

  void _playSfx(String filename, double volume) {
    if (_isSfxEnabled) {
      FlameAudio.play(filename, volume: volume);
    }
  }

  void playSelectVial() => _playSfx('sfx/select_vial.wav', _volSelectVial);
  void playPour() => _playSfx('sfx/pour.wav', _volPour);
  void playPotionComplete() =>
      _playSfx('sfx/potion_complete.wav', _volPotionComplete);
  void playCombo() => _playSfx('sfx/combo.wav', _volCombo);
  void playLevelComplete() =>
      _playSfx('sfx/level_complete.wav', _volLevelComplete);
  void playButtonClick() => _playSfx('sfx/button_click.wav', _volButtonClick);
}
