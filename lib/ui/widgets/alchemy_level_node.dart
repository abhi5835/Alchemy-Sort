import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../models/alchemy_world_theme.dart';

class AlchemyLevelNode extends StatefulWidget {
  final int level;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLocked;
  final VoidCallback? onTap;
  final AlchemyWorldTheme theme;
  final int stars; // 1-3 based on progression

  const AlchemyLevelNode({
    super.key,
    required this.level,
    this.isCompleted = false,
    this.isCurrent = false,
    this.isLocked = true,
    this.onTap,
    required this.theme,
    this.stars = 0,
  });

  @override
  State<AlchemyLevelNode> createState() => _AlchemyLevelNodeState();
}

class _AlchemyLevelNodeState extends State<AlchemyLevelNode>
    with SingleTickerProviderStateMixin {
  AnimationController? _pulseController;
  Animation<double>? _pulseAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.isCurrent) {
      _pulseController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500),
      )..repeat(reverse: true);
      _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _pulseController!, curve: Curves.easeInOut),
      );
    }
  }

  @override
  void dispose() {
    _pulseController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine if it's a milestone level (e.g., every 10th level)
    final isMilestone = widget.level % 10 == 0;

    return GestureDetector(
      onTap: widget.isLocked ? null : widget.onTap,
      child: SizedBox(
        width: 80,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (widget.isCurrent && _pulseAnimation != null)
                  AnimatedBuilder(
                    animation: _pulseAnimation!,
                    builder: (context, child) {
                      return Container(
                        width: 70 + (10 * _pulseAnimation!.value),
                        height: 70 + (10 * _pulseAnimation!.value),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.accentGold.withValues(
                            alpha: 0.3 * (1 - _pulseAnimation!.value),
                          ),
                        ),
                      );
                    },
                  ),
                Container(
                  width: isMilestone ? 65 : 55,
                  height: isMilestone ? 65 : 55,
                  decoration: BoxDecoration(
                    shape: isMilestone ? BoxShape.rectangle : BoxShape.circle,
                    borderRadius: isMilestone
                        ? BorderRadius.circular(16)
                        : null,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: widget.isLocked
                          ? [Colors.grey.shade800, Colors.grey.shade900]
                          : [
                              widget.theme.nodeBaseColor,
                              widget.theme.nodeAccentColor,
                            ],
                    ),
                    border: Border.all(
                      color: widget.isCurrent
                          ? AppTheme.accentGold
                          : (widget.isLocked ? Colors.white24 : Colors.white70),
                      width: widget.isCurrent ? 3 : 1.5,
                    ),
                    boxShadow: widget.isLocked
                        ? []
                        : [
                            BoxShadow(
                              color: widget.theme.nodeAccentColor.withValues(
                                alpha: 0.4,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                            if (widget.isCurrent)
                              BoxShadow(
                                color: AppTheme.accentGold.withValues(
                                  alpha: 0.6,
                                ),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                          ],
                  ),
                  child: Center(
                    child: widget.isLocked
                        ? const Icon(
                            Icons.lock_rounded,
                            color: Colors.white30,
                            size: 24,
                          )
                        : Text(
                            '${widget.level}',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: isMilestone ? 22 : 20,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
                // Play Icon overlay for current level
                if (widget.isCurrent)
                  Positioned(
                    bottom: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.accentGold,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.black,
                        size: 14,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            if (widget.isCompleted)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return Icon(
                    Icons.star_rounded,
                    size: 14,
                    color: i < widget.stars
                        ? const Color(0xFFFFD700)
                        : Colors.white24,
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }
}
