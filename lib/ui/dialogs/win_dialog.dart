import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../game/alchemy_game.dart';
import '../../core/managers/game_manager.dart';
import '../../core/managers/audio_manager.dart';
import '../../core/constants/app_constants.dart';
import '../../game/levels/level_repository.dart';
import '../../game/analytics/game_analytics_service.dart';

class WinDialog extends StatefulWidget {
  final AlchemyGame game;

  const WinDialog({super.key, required this.game});

  @override
  State<WinDialog> createState() => _WinDialogState();
}

class _WinDialogState extends State<WinDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isNavigating = false;
  late int _starsEarned;
  late bool _isFinalLevel;

  @override
  void initState() {
    super.initState();
    _starsEarned = widget.game.world.sessionStats.calculateStars();

    final int currentIndex = GameManager().currentLevelIndex.value;
    _isFinalLevel = currentIndex >= LevelRepository.maxLevels - 1;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_isNavigating) return;
    _isNavigating = true;
    AudioManager().playButtonClick();

    final result = widget.game.world.completionResult;

    // If we have no result for some reason, or it's the final level, go back to map.
    if (result == null || !result.nextLevelAvailable) {
      widget.game.overlays.remove('WinDialog');
      Navigator.of(context).pop(); // Go back to Level Map
      return;
    }

    if (result.newlyDiscoveredPotion != null) {
      widget.game.lastDiscoveredPotion = result.newlyDiscoveredPotion;
      widget.game.overlays.remove('WinDialog');
      widget.game.overlays.add('PotionDiscoveryDialog');
    } else {
      // Normal flow
      GameManager().nextLevel();
      widget.game.overlays.remove('WinDialog');
      widget.game.world.loadNextLevel();
    }

    final sessionId = widget.game.world.currentSessionId;
    if (sessionId != null) {
      GameAnalyticsService().trackCompletionContinued(
        sessionId,
        GameManager().currentLevelIndex.value,
      );
    }
  }

  void _handleLevelMap() {
    if (_isNavigating) return;
    _isNavigating = true;
    AudioManager().playButtonClick();
    final sessionId = widget.game.world.currentSessionId;
    if (sessionId != null) {
      GameAnalyticsService().trackCompletionMapSelected(
        sessionId,
        GameManager().currentLevelIndex.value,
      );
    }

    widget.game.overlays.remove('WinDialog');
    Navigator.of(context).pop();
  }

  Widget _buildStar(int index) {
    final double start = 0.2 + (index * 0.15); // Stagger stars: 0.2, 0.35, 0.50
    final double end = start + 0.3;
    final curve = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end.clamp(0.0, 1.0), curve: Curves.elasticOut),
    );

    return ScaleTransition(
      scale: curve,
      child: Icon(
        Icons.star,
        size: index == 1 ? 64 : 48, // Middle star is larger
        color: index < _starsEarned
            ? AppConstants.uiGold
            : Colors.grey.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, double animationStart) {
    final fadeCurve = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        animationStart,
        animationStart + 0.3,
        curve: Curves.easeIn,
      ),
    );
    final slideCurve = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        animationStart,
        animationStart + 0.3,
        curve: Curves.easeOutCubic,
      ),
    );

    return FadeTransition(
      opacity: fadeCurve,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(slideCurve),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.outfit(color: Colors.white70, fontSize: 16),
              ),
              Text(
                value,
                style: GoogleFonts.sourceCodePro(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = widget.game.world.sessionStats;
    final int levelNumber = GameManager().currentLevelIndex.value + 1;
    final int score = GameManager().score.value;

    final titleFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
    );

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 340,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(
              0xFF1a0b2e,
            ).withValues(alpha: 0.95), // Deep magical purple
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppConstants.uiGold.withValues(alpha: 0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.purpleAccent.withValues(alpha: 0.3),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              FadeTransition(
                opacity: titleFade,
                child: Column(
                  children: [
                    Text(
                      'ALCHEMY COMPLETE',
                      style: GoogleFonts.cinzel(
                        color: AppConstants.uiGold,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'LEVEL $levelNumber',
                      style: GoogleFonts.outfit(
                        color: Colors.white60,
                        fontSize: 14,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildStar(0),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 12.0,
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: _buildStar(1),
                  ),
                  _buildStar(2),
                ],
              ),
              const SizedBox(height: 32),

              // Stats
              _buildStatRow('SCORE', score.toString(), 0.4),
              _buildStatRow('COMBO BONUS', '+${stats.comboBonusEarned}', 0.55),
              _buildStatRow(
                'POTIONS COMPLETED',
                '${stats.solvedPotionCount}',
                0.7,
              ),

              const SizedBox(height: 40),

              // Buttons
              FadeTransition(
                opacity: CurvedAnimation(
                  parent: _controller,
                  curve: const Interval(0.8, 1.0, curve: Curves.easeIn),
                ),
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.uiGold,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _handleContinue,
                      child: Text(
                        _isFinalLevel ? 'BACK TO MAP' : 'CONTINUE',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white70,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: _handleLevelMap,
                      child: Text(
                        'LEVEL MAP',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
