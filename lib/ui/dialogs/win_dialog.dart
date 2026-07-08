import 'package:flutter/material.dart';
import '../../game/alchemy_game.dart';
import '../../core/managers/game_manager.dart';
// import '../../core/managers/ad_manager.dart';
import '../../core/managers/audio_manager.dart';

class WinDialog extends StatelessWidget {
  final AlchemyGame game;

  const WinDialog({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Level Complete!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                AudioManager().playButtonClick();
                final gameManager = GameManager();
                gameManager.unlockNextLevel();
                gameManager.nextLevel();

                game.overlays.remove('WinDialog');

                // Show Interstitial Ad then load next level
                // AdManager().showInterstitialAd(
                //   onAdDismissed: () {
                //     game.world.loadNextLevel();
                //   },
                // );
                game.world.loadNextLevel();
              },
              child: Text(
                'Next Level',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
