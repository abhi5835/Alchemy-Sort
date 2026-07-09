import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/managers/game_manager.dart';
import '../../game/alchemy_game_mode.dart';
import '../../game/daily/daily_challenge_generator.dart';
import '../../data/repositories/daily_alchemy_repository.dart';
import '../../data/local/database/app_database.dart';
import '../../data/local/database/tables/daily_alchemy_records_table.dart';
import 'game_screen.dart';

class DailyAlchemyScreen extends StatefulWidget {
  const DailyAlchemyScreen({super.key});

  @override
  State<DailyAlchemyScreen> createState() => _DailyAlchemyScreenState();
}

class _DailyAlchemyScreenState extends State<DailyAlchemyScreen> {
  late final DailyAlchemyRepository _repo;
  DailyChallenge? _challenge;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _repo = DailyAlchemyRepository(GameManager().database);
    _initDaily();
  }

  Future<void> _initDaily() async {
    final challenge = await _repo.resolveTodayChallenge();
    if (mounted) {
      setState(() {
        _challenge = challenge;
        _isLoading = false;
      });
    }
  }

  Future<void> _startAttempt(DailyAlchemyRecordData record) async {
    final isCompleted = record.status == DailyChallengeStatus.completed;

    if (!isCompleted) {
      await _repo.startAttempt(_challenge!.dateKey);
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => GameScreen(
            gameMode: GameMode.dailyAlchemy,
            dailyChallenge: _challenge,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _challenge == null) {
      return const Scaffold(
        backgroundColor: AppTheme.backgroundDark,
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.accentGold),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Daily Alchemy',
          style: TextStyle(
            color: AppTheme.accentGold,
            fontFamily: 'Cinzel',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.accentGold),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<DailyAlchemyRecordData?>(
        stream: _repo.watchDailyRecord(_challenge!.dateKey),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.accentGold),
            );
          }

          final record = snapshot.data!;
          final isCompleted = record.status == DailyChallengeStatus.completed;
          final dateStr = _challenge!.dateKey;

          return Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppTheme.accentGold.withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentPurple.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: AppTheme.accentGold,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isCompleted
                        ? "TODAY'S ALCHEMY COMPLETE"
                        : "TODAY'S CHALLENGE",
                    style: const TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dateStr,
                    style: const TextStyle(
                      color: AppTheme.accentGold,
                      fontFamily: 'Cinzel',
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 32),

                  if (isCompleted) ...[
                    _buildStatRow(
                      'Best Time',
                      '${(record.bestDurationMs ?? 0) ~/ 1000}s',
                    ),
                    const SizedBox(height: 12),
                    _buildStatRow('Best Moves', '${record.bestMoveCount ?? 0}'),
                    const SizedBox(height: 12),
                    _buildStatRow('Stars', '${record.bestStars ?? 0}/3'),
                    const SizedBox(height: 12),
                    _buildStatRow(
                      'Reward Earned',
                      '+${record.xpReward} XP',
                      color: AppTheme.successGreen,
                    ),
                    const SizedBox(height: 32),
                  ] else ...[
                    _buildStatRow('Difficulty', 'Arcane'),
                    const SizedBox(height: 12),
                    _buildStatRow('Base Reward', '+150 XP'),
                    const SizedBox(height: 32),
                  ],

                  ElevatedButton(
                    onPressed: () => _startAttempt(record),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCompleted
                          ? AppTheme.surfaceDark
                          : AppTheme.accentGold,
                      foregroundColor: isCompleted
                          ? AppTheme.accentGold
                          : AppTheme.backgroundDark,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                      side: isCompleted
                          ? const BorderSide(
                              color: AppTheme.accentGold,
                              width: 2,
                            )
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      isCompleted ? 'PRACTICE AGAIN' : 'BEGIN ALCHEMY',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  if (isCompleted) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Practice grants 0 XP',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatRow(
    String label,
    String value, {
    Color color = Colors.white,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'SourceCodePro',
            ),
          ),
        ),
      ],
    );
  }
}
