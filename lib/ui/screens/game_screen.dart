import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../game/alchemy_game.dart';
import '../dialogs/win_dialog.dart';
import '../../core/managers/game_manager.dart';
import '../../core/managers/banner_ad_widget.dart';
import '../../core/constants/app_constants.dart';


class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final AlchemyGame _game;

  @override
  void initState() {
    super.initState();
    _game = AlchemyGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background - gradient or image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/back1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Game Layer - With padding for UI
          GameWidget<AlchemyGame>(
            game: _game,
            overlayBuilderMap: {
              'WinDialog': (context, game) => WinDialog(game: game),
            },
          ),

          // UI Content
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                const Spacer(),
                _buildBottomBar(context),
                const BannerAdWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        children: [
          // Top Row: Title Area and Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title Area
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValueListenableBuilder<int>(
                    valueListenable: GameManager().currentLevelIndex,
                    builder: (context, levelIndex, _) {
                      return Text(
                        'LEVEL ${levelIndex + 1}',
                        style: GoogleFonts.cinzel(
                          color: Colors.white60,
                          fontSize: 22,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ],
              ),


            ],
          ),

          const SizedBox(height: 20),

          // Score Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: AppConstants.pillBackground,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: AppConstants.uiGold, size: 20),
                const SizedBox(width: 8),
                ValueListenableBuilder<int>(
                  valueListenable: GameManager().score,
                  builder: (context, score, _) {
                    return Text(
                      'SCORE:  ${_formatScore(score)}',
                      style: GoogleFonts.sourceCodePro(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatScore(int score) {
    return score.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Undo Button
          ValueListenableBuilder<int>(
            valueListenable: _game.world.undoRemaining,
            builder: (context, count, _) {
              return _BottomActionButton(
                iconData: Icons.undo,
                label: 'UNDO',
                onTap: () => _game.world.undoMove(),
                badgeCount: count,
              );
            },
          ),

          // Add Vial Button (Center, Large)
          ValueListenableBuilder<int>(
            valueListenable: _game.world.addTubeRemaining,
            builder: (context, count, _) {
              return _AddVialButton(
                onTap: () => _game.world.addTube(),
                badgeCount: count,
              );
            },
          ),

          // Hint Button
          ValueListenableBuilder<int>(
            valueListenable: _game.world.hintRemaining,
            builder: (context, count, _) {
              return _BottomActionButton(
                iconData: Icons.lightbulb_outline,
                label: 'HINT',
                onTap: () => _game.world.showHint(),
                badgeCount: count,
              );
            },
          ),
        ],
      ),
    );
  }
}


class _BottomActionButton extends StatelessWidget {
  final IconData iconData;
  final String label;
  final VoidCallback onTap;
  final int badgeCount;

  const _BottomActionButton({
    required this.iconData,
    required this.label,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppConstants.iconBackground,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1.5,
                  ),
                ),
                child: Icon(iconData, color: Colors.white, size: 28),
              ),
            ),
            if (badgeCount > 0)
              Positioned(
                top: -5,
                right: -5,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppConstants.uiGold,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$badgeCount',
                    style: GoogleFonts.outfit(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.outfit(
            color: Colors.white60,
            fontSize: 12,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _AddVialButton extends StatelessWidget {
  final VoidCallback onTap;
  final int badgeCount;

  const _AddVialButton({required this.onTap, this.badgeCount = 0});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppConstants.mainActionBtnGradientStart,
                      AppConstants.mainActionBtnGradientEnd,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.mainActionBtnGradientStart
                          .withValues(alpha: 0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.add, color: Colors.white, size: 40),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Icon(
                        Icons.science, // Flask icon
                        color: Colors.white.withValues(alpha: 0.3),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              if (badgeCount > 0)
                Positioned(
                  top: -5,
                  right: -5,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppConstants.uiGold,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$badgeCount',
                      style: GoogleFonts.outfit(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'ADD VIAL',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 12,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
