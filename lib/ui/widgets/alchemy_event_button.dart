import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/managers/audio_manager.dart';

class AlchemyEventButton extends StatefulWidget {
  final VoidCallback onTap;

  const AlchemyEventButton({super.key, required this.onTap});

  @override
  State<AlchemyEventButton> createState() => _AlchemyEventButtonState();
}

class _AlchemyEventButtonState extends State<AlchemyEventButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AudioManager().playButtonClick();
        widget.onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF161B28),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: AppTheme.accentGold.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentGold.withValues(
                          alpha: 0.3 * _pulseAnimation.value,
                        ),
                        blurRadius: 10 * _pulseAnimation.value,
                        spreadRadius: 2 * _pulseAnimation.value,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: AppTheme.accentGold,
                    size: 20,
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            Text(
              'DAILY',
              style: GoogleFonts.outfit(
                color: AppTheme.accentGold,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
