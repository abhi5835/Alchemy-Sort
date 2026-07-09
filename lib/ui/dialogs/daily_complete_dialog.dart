import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../game/models/daily_completion_result.dart';
import 'package:flutter/services.dart';

class DailyCompleteDialog extends StatefulWidget {
  final DailyCompletionResult result;

  const DailyCompleteDialog({super.key, required this.result});

  @override
  State<DailyCompleteDialog> createState() => _DailyCompleteDialogState();
}

class _DailyCompleteDialogState extends State<DailyCompleteDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    HapticFeedback.heavyImpact();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final isPractice = !result.firstCompletion;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppTheme.backgroundDark,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.accentGold, width: 2),
            boxShadow: [
              BoxShadow(color: AppTheme.accentGold.withOpacity(0.3), blurRadius: 30, spreadRadius: 5),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: AppTheme.accentGold, size: 64),
              const SizedBox(height: 16),
              
              Text(
                isPractice ? "PRACTICE COMPLETE" : "DAILY ALCHEMY COMPLETE",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontFamily: 'Cinzel',
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Icon(
                    index < result.stars ? Icons.star : Icons.star_border,
                    color: AppTheme.accentGold,
                    size: 40,
                  );
                }),
              ),
              const SizedBox(height: 24),
              
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    if (!isPractice && result.rewardGranted) ...[
                      const Text(
                        "REWARD EARNED",
                        style: TextStyle(color: Colors.white70, fontSize: 14, letterSpacing: 1.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "+${result.reward.totalXp} XP",
                        style: const TextStyle(color: AppTheme.successGreen, fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      if (result.reward.hasMilestoneBonus) ...[
                        Text(
                          "🔥 ${result.currentStreak} DAY STREAK MILESTONE!",
                          style: const TextStyle(color: AppTheme.accentOrange, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ] else if (isPractice) ...[
                      const Text(
                        "PRACTICE REWARD",
                        style: TextStyle(color: Colors.white70, fontSize: 14, letterSpacing: 1.5),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "+0 XP",
                        style: TextStyle(color: Colors.white38, fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                    ],

                    Text(
                      "Current Streak: 🔥 ${result.currentStreak} DAYS",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentGold,
                          foregroundColor: AppTheme.backgroundDark,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('CONTINUE', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
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
