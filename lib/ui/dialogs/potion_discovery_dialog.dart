import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../game/alchemy_game.dart';
import '../../game/models/potion_definition.dart';
import '../../core/managers/game_manager.dart';
import '../../core/managers/audio_manager.dart';
import '../../core/managers/potion_collection_manager.dart';
import '../../game/potions/potion_repository.dart';
import '../widgets/potion_visual.dart';

class PotionDiscoveryDialog extends StatefulWidget {
  final AlchemyGame game;
  final PotionDefinition potion;

  const PotionDiscoveryDialog({
    super.key,
    required this.game,
    required this.potion,
  });

  @override
  State<PotionDiscoveryDialog> createState() => _PotionDiscoveryDialogState();
}

class _PotionDiscoveryDialogState extends State<PotionDiscoveryDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Trigger haptics when potion scales
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) HapticFeedback.mediumImpact();
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleAdd() {
    if (_isNavigating) return;
    _isNavigating = true;
    AudioManager().playButtonClick();

    final gameManager = GameManager();
    gameManager.nextLevel();
    widget.game.overlays.remove('PotionDiscoveryDialog');
    widget.game.world.loadNextLevel();
  }

  @override
  Widget build(BuildContext context) {
    // 100-700ms Potion scale
    final potionScale =
        TweenSequence([
          TweenSequenceItem(
            tween: Tween(
              begin: 0.7,
              end: 1.05,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 400,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: 1.05,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 200,
          ),
        ]).animate(
          CurvedAnimation(parent: _controller, curve: const Interval(0.1, 0.7)),
        );

    final potionFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.1, 0.4),
    );
    final titleFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.7, 0.85),
    );
    final nameFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.85, 1.0),
    );
    final descFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(1.0, 1.2),
    );
    final collectionFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(1.2, 1.4),
    );
    final buttonFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(1.4, 1.5),
    );

    final count = PotionCollectionManager().discoveredCount;
    final total = PotionRepository.totalPotionCount;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1a0b2e).withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: widget.potion.primaryColor.withValues(alpha: 0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.potion.primaryColor.withValues(alpha: 0.3),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeTransition(
                opacity: titleFade,
                child: Text(
                  'NEW DISCOVERY',
                  style: GoogleFonts.outfit(
                    color: Colors.white70,
                    fontSize: 14,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              FadeTransition(
                opacity: potionFade,
                child: ScaleTransition(
                  scale: potionScale,
                  child: SizedBox(
                    width: 120,
                    height: 160,
                    child: PotionVisual(
                      primaryColor: widget.potion.primaryColor,
                      secondaryColor: widget.potion.secondaryColor,
                      width: 120,
                      height: 160,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              FadeTransition(
                opacity: nameFade,
                child: Text(
                  widget.potion.name.toUpperCase(),
                  style: GoogleFonts.cinzel(
                    color: widget.potion.primaryColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              FadeTransition(
                opacity: descFade,
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      '${widget.potion.rarity.name.toUpperCase()} POTION',
                      style: GoogleFonts.outfit(
                        color: widget.potion.secondaryColor,
                        fontSize: 12,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '"${widget.potion.description}"',
                      style: GoogleFonts.outfit(
                        color: Colors.white60,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              FadeTransition(
                opacity: collectionFade,
                child: Column(
                  children: [
                    Text(
                      'COLLECTION',
                      style: GoogleFonts.outfit(
                        color: Colors.white54,
                        fontSize: 10,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      '$count / $total POTIONS',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              FadeTransition(
                opacity: buttonFade,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final isEnabled =
                        _controller.value >= 1.0; // Enable near end
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.potion.primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: Colors.white10,
                      ),
                      onPressed: isEnabled ? _handleAdd : null,
                      child: Text(
                        'ADD TO POTION BOOK',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
