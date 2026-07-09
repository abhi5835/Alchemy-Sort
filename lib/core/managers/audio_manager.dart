import 'package:flame_audio/flame_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();

  factory AudioManager() {
    return _instance;
  }

  AudioManager._internal();

  SharedPreferences? _prefs;
  bool _isMusicEnabled = true;
  final ValueNotifier<bool> musicEnabledNotifier = ValueNotifier(true);
  bool _isSfxEnabled = true;
  final ValueNotifier<bool> sfxEnabledNotifier = ValueNotifier(true);

  bool _isInitialized = false;
  Future<void>? _initializationFuture;

  bool _isBgmPlaying = false;
  bool _isStartingBgm = false;
  bool _isBgmPaused = false;
  String? _currentBgmFile;
  String? _desiredBgmFile;

  AudioPool? _poolSelectVial;
  AudioPool? _poolPour;
  AudioPool? _poolPotionComplete;
  AudioPool? _poolCombo;
  AudioPool? _poolLevelComplete;
  AudioPool? _poolButtonClick;

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

  Future<AudioPool?> _createPoolSafely(
    String asset, {
    required int minPlayers,
    required int maxPlayers,
  }) async {
    try {
      return await FlameAudio.createPool(
        asset,
        minPlayers: minPlayers,
        maxPlayers: maxPlayers,
      );
    } catch (error) {
      debugPrint('AudioPool initialization failed for $asset: $error');
      return null;
    }
  }

  Future<void> init() {
    if (_isInitialized) {
      return Future.value();
    }

    final existingInitialization = _initializationFuture;
    if (existingInitialization != null) {
      return existingInitialization;
    }

    final future = _initialize();
    _initializationFuture = future;
    return future;
  }

  Future<void> _initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();

      _isMusicEnabled = _prefs?.getBool(_musicPrefsKey) ?? true;
      musicEnabledNotifier.value = _isMusicEnabled;

      _isSfxEnabled = _prefs?.getBool(_sfxPrefsKey) ?? true;
      sfxEnabledNotifier.value = _isSfxEnabled;

      FlameAudio.bgm.initialize();

      await FlameAudio.audioCache.loadAll([
        'sfx/select_vial.wav',
        'sfx/pour.wav',
        'sfx/potion_complete.wav',
        'sfx/combo.wav',
        'sfx/level_complete.wav',
        'sfx/button_click.wav',
      ]);

      _poolSelectVial = await _createPoolSafely(
        'sfx/select_vial.wav',
        minPlayers: 2,
        maxPlayers: 4,
      );
      _poolPour = await _createPoolSafely(
        'sfx/pour.wav',
        minPlayers: 2,
        maxPlayers: 5,
      );
      _poolPotionComplete = await _createPoolSafely(
        'sfx/potion_complete.wav',
        minPlayers: 1,
        maxPlayers: 2,
      );
      _poolCombo = await _createPoolSafely(
        'sfx/combo.wav',
        minPlayers: 1,
        maxPlayers: 3,
      );
      _poolLevelComplete = await _createPoolSafely(
        'sfx/level_complete.wav',
        minPlayers: 1,
        maxPlayers: 1,
      );
      _poolButtonClick = await _createPoolSafely(
        'sfx/button_click.wav',
        minPlayers: 1,
        maxPlayers: 3,
      );

      _isInitialized = true;
    } finally {
      _initializationFuture = null;
    }
  }

  Future<void> playBgm(String filename) async {
    if (!_isInitialized) return;

    _desiredBgmFile = filename;

    if (!_isMusicEnabled) return;
    if (_isStartingBgm) return;

    if (_isBgmPlaying && _currentBgmFile == filename) {
      return;
    }

    _isStartingBgm = true;

    try {
      if (_isBgmPlaying) {
        await FlameAudio.bgm.stop();
        _isBgmPlaying = false;
      }

      await FlameAudio.bgm.play(filename, volume: _bgmVolume);

      _currentBgmFile = filename;
      _isBgmPlaying = true;
      _isBgmPaused = false;
    } catch (error) {
      debugPrint('Failed to play BGM $filename: $error');
      _isBgmPlaying = false;
    } finally {
      _isStartingBgm = false;
    }
  }

  Future<void> pauseBgm() async {
    if (_isBgmPlaying && !_isBgmPaused) {
      await FlameAudio.bgm.pause();
      _isBgmPaused = true;
    }
  }

  Future<void> resumeBgm() async {
    if (_isMusicEnabled && _currentBgmFile != null && _isBgmPaused) {
      await FlameAudio.bgm.resume();
      _isBgmPaused = false;
    }
  }

  Future<void> stopBgm() async {
    await FlameAudio.bgm.stop();
    _currentBgmFile = null;
    _isBgmPlaying = false;
    _isBgmPaused = false;
    _isStartingBgm = false;
  }

  Future<void> setMusicEnabled(bool enabled) async {
    if (_isMusicEnabled == enabled) return;

    _isMusicEnabled = enabled;
    musicEnabledNotifier.value = enabled;
    await _prefs?.setBool(_musicPrefsKey, enabled);

    if (enabled) {
      if (_desiredBgmFile != null) {
        await playBgm(_desiredBgmFile!);
      }
    } else {
      await stopBgm();
    }
  }

  Future<void> setSfxEnabled(bool enabled) async {
    _isSfxEnabled = enabled;
    sfxEnabledNotifier.value = enabled;
    await _prefs?.setBool(_sfxPrefsKey, enabled);
  }

  void _playSfx({
    required AudioPool? pool,
    required String asset,
    required double volume,
  }) {
    if (!_isSfxEnabled) return;

    if (pool != null) {
      unawaited(_safePoolPlay(pool, asset, volume));
      return;
    }

    unawaited(_safeFallbackPlay(asset, volume));
  }

  Future<void> _safePoolPlay(
    AudioPool pool,
    String asset,
    double volume,
  ) async {
    try {
      await pool.start(volume: volume);
    } catch (error) {
      debugPrint('AudioPool playback failed for $asset: $error');
    }
  }

  Future<void> _safeFallbackPlay(String asset, double volume) async {
    try {
      await FlameAudio.play(asset, volume: volume);
    } catch (error) {
      debugPrint('Fallback audio playback failed for $asset: $error');
    }
  }

  void playSelectVial() => _playSfx(
    pool: _poolSelectVial,
    asset: 'sfx/select_vial.wav',
    volume: _volSelectVial,
  );
  void playPour() =>
      _playSfx(pool: _poolPour, asset: 'sfx/pour.wav', volume: _volPour);
  void playPotionComplete() => _playSfx(
    pool: _poolPotionComplete,
    asset: 'sfx/potion_complete.wav',
    volume: _volPotionComplete,
  );
  void playCombo() =>
      _playSfx(pool: _poolCombo, asset: 'sfx/combo.wav', volume: _volCombo);
  void playLevelComplete() => _playSfx(
    pool: _poolLevelComplete,
    asset: 'sfx/level_complete.wav',
    volume: _volLevelComplete,
  );
  void playButtonClick() => _playSfx(
    pool: _poolButtonClick,
    asset: 'sfx/button_click.wav',
    volume: _volButtonClick,
  );

  void dispose() {
    _poolSelectVial?.dispose();
    _poolSelectVial = null;
    _poolPour?.dispose();
    _poolPour = null;
    _poolPotionComplete?.dispose();
    _poolPotionComplete = null;
    _poolCombo?.dispose();
    _poolCombo = null;
    _poolLevelComplete?.dispose();
    _poolLevelComplete = null;
    _poolButtonClick?.dispose();
    _poolButtonClick = null;

    _isInitialized = false;
    _initializationFuture = null;
    _isBgmPlaying = false;
    _isBgmPaused = false;
    _isStartingBgm = false;
    _currentBgmFile = null;
  }
}
