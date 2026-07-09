import 'dart:async';
import 'package:alchemy_sort/game/levels/level_repository.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'daily_alchemy_screen.dart';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:google_fonts/google_fonts.dart';
import '../../core/managers/game_manager.dart';
// import '../../core/managers/banner_ad_widget.dart';
import 'game_screen.dart';
import '../../core/managers/audio_manager.dart';
import 'profile_screen.dart';
import '../../core/managers/settings_manager.dart';
import '../../data/models/player_profile.dart';

class LevelMapScreen extends StatelessWidget {
  const LevelMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Total levels to display
    final int levelCount = LevelRepository.maxLevels;

    return Scaffold(
      backgroundColor: const Color(
        0xFF101420,
      ), // Dark background from screenshot
      body: Stack(
        children: [
          // Background Gradient effect (Top Left blue glow)
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1E88E5).withValues(alpha: 0.02),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E88E5).withValues(alpha: 0.15),
                    blurRadius: 150,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 250,
            left: 250,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1E88E5).withValues(alpha: 0.15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E88E5).withValues(alpha: 0.15),
                    blurRadius: 150,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 30,
            left: 200,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1E88E5).withValues(alpha: 0.15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E88E5).withValues(alpha: 0.15),
                    blurRadius: 150,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 130,
            left: 30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFA855F7).withValues(alpha: 0.20),
                    blurRadius: 60,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 250,
            right: -20,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/GiantMushroom.png'),
                  opacity: 0.4,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Scrollable Map
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: _LevelMapScrollView(levelCount: levelCount),
          ),

          // Header
          const _MapHeader(),

          // Banner Ad at the bottom
          // const Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: BannerAdWidget(),
          // ),

          // Daily Alchemy Card
          Padding(
            padding: const EdgeInsets.only(top: 110, left: 16, right: 16),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.accentGold.withValues(alpha: 0.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentGold.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DailyAlchemyScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Ink(
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.accentGold.withValues(alpha: 0.5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentGold.withValues(alpha: 0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: AppTheme.accentGold,
                        size: 36,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'DAILY ALCHEMY',
                              style: TextStyle(
                                color: AppTheme.accentGold,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                fontFamily: 'Cinzel',
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Today's exclusive challenge",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: AppTheme.accentGold),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapHeader extends StatelessWidget {
  const _MapHeader();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Text(
              'ALCHEMY SORT',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w900,
              ),
            ),

            const Spacer(),

            // Profile Button
            ValueListenableBuilder<PlayerProfile>(
              valueListenable: SettingsManager().profileNotifier,
              builder: (context, profile, child) {
                return GestureDetector(
                  onTap: () {
                    AudioManager().playButtonClick();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1E293B),
                      border: Border.all(color: AppTheme.accentGold, width: 2),
                    ),
                    child: Icon(
                      _getIconData(profile.avatarIcon),
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'science':
        return Icons.science;
      case 'auto_awesome':
        return Icons.auto_awesome;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'star':
        return Icons.star;
      case 'pets':
        return Icons.pets;
      default:
        return Icons.person;
    }
  }
}

class _LevelMapScrollView extends StatefulWidget {
  final int levelCount;

  const _LevelMapScrollView({required this.levelCount});

  @override
  State<_LevelMapScrollView> createState() => _LevelMapScrollViewState();
}

class _LevelMapScrollViewState extends State<_LevelMapScrollView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Schedule scroll after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _scrollToActiveLevel();
      unawaited(AudioManager().playBgm('music/alchemy_theme.mp3'));
    });
  }

  void _scrollToActiveLevel() {
    if (!mounted) return;

    final int activeIndex = GameManager().keyUnlockedLevelIndex.value;
    // Calculation:
    // Level 1 (Index 0) is at bottom + 150 padding.
    // Each level adds 160 gap.
    // Scroll start (offset 0) is at bottom.
    // To center, we want the node to be at screenHeight / 2.
    // Node Position from Bottom = 150 + (index * 160).
    // Target Offset = NodePosition - (ScreenHeight / 2).

    final double screenHeight = MediaQuery.of(context).size.height;
    final double nodePosFromBottom = 150.0 + (activeIndex * 160.0);
    final double targetOffset = nodePosFromBottom - (screenHeight / 2);

    // Clamp to valid range (though single child scroll view clamps automatically)
    // Add small delay for UI drawing if needed, but post frame callback usually enough.
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        targetOffset.clamp(0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Height per level node area
    const double nodeGap = 160.0;
    final double totalHeight =
        nodeGap * widget.levelCount + 300; // Extra padding at bottom/top

    return SingleChildScrollView(
      controller: _scrollController,
      reverse: true, // Start from bottom (level 1)
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        height: totalHeight,
        child: ValueListenableBuilder<int>(
          valueListenable: GameManager().keyUnlockedLevelIndex,
          builder: (context, unlockedIndex, child) {
            return Stack(
              children: [
                // Path Line
                Positioned.fill(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: DashedPathPainter(
                        levelCount: widget.levelCount,
                        nodeGap: nodeGap,
                      ),
                    ),
                  ),
                ),

                // Level Nodes
                ...List.generate(widget.levelCount, (index) {
                  final int levelNumber = index + 1;
                  // Start from bottom, add padding
                  final double y = totalHeight - (index * nodeGap) - 150;

                  // Calculate X based on Sine wave
                  final double screenWidth = MediaQuery.of(context).size.width;
                  final double amplitude = screenWidth * 0.25; // Narrower wave
                  final double centerX = screenWidth / 2;

                  // Phase shift to match screenshot look (starts left-ish?)
                  final double x = centerX + amplitude * sin(index * 0.7 + pi);

                  final bool isLocked = index > unlockedIndex;
                  final bool isCurrent = index == unlockedIndex;
                  final bool isCompleted = index < unlockedIndex;

                  return Positioned(
                    left: x - 60, // Center the node (approx width 120/2)
                    top: y - 60, // Center the node
                    child: _buildNodeUi(
                      context,
                      levelNumber,
                      index,
                      isLocked,
                      isCurrent,
                      isCompleted,
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNodeUi(
    BuildContext context,
    int level,
    int index,
    bool isLocked,
    bool isCurrent,
    bool isCompleted,
  ) {
    if (isCurrent) {
      return _CurrentLevelNode(
        level: level,
        onTap: () => _navigateToGame(context, index),
      );
    } else if (isLocked) {
      return _LockedLevelNode(level: level);
    } else {
      return _CompletedLevelNode(
        level: level,
        index: index,
        onTap: () => _navigateToGame(context, index),
      );
    }
  }

  Future<void> _navigateToGame(BuildContext context, int levelIndex) async {
    AudioManager().playButtonClick();
    GameManager().setLevel(levelIndex);
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GameScreen()),
    );
    // When returning, ensure we scroll to the active level
    _scrollToActiveLevel();
  }
}

class DashedPathPainter extends CustomPainter {
  final int levelCount;
  final double nodeGap;

  // Cache the generated dashed path so we don't recalculate 54k pixels on repaints
  static Path? _cachedDashPath;
  static Size? _cachedSize;
  static int? _cachedLevelCount;
  static double? _cachedNodeGap;

  DashedPathPainter({required this.levelCount, required this.nodeGap});

  @override
  void paint(Canvas canvas, Size size) {
    if (_cachedDashPath == null ||
        _cachedSize != size ||
        _cachedLevelCount != levelCount ||
        _cachedNodeGap != nodeGap) {
      final path = Path();
      final double totalHeight = size.height;
      final double centerX = size.width / 2;
      final double amplitude = size.width * 0.25;

      bool firstPoint = true;

      // Plot curve
      for (double i = 0; i <= levelCount; i += 0.1) {
        final double y = totalHeight - (i * nodeGap) - 150;
        final double x = centerX + amplitude * sin(i * 0.7 + pi);

        if (firstPoint) {
          path.moveTo(x, y);
          firstPoint = false;
        } else {
          path.lineTo(x, y);
        }
      }

      _cachedDashPath = _dashPath(path, dashWidth: 10, dashSpace: 10);
      _cachedSize = size;
      _cachedLevelCount = levelCount;
      _cachedNodeGap = nodeGap;
    }

    final paint = Paint()
      ..color = const Color(0xFF3F51B5).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(_cachedDashPath!, paint);
  }

  Path _dashPath(
    Path source, {
    required double dashWidth,
    required double dashSpace,
  }) {
    final Path dest = Path();
    for (final ui.PathMetric metric in source.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        dest.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant DashedPathPainter oldDelegate) {
    return oldDelegate.levelCount != levelCount ||
        oldDelegate.nodeGap != nodeGap;
  }
}

// ---------------- NODE WIDGETS ----------------

class _CurrentLevelNode extends StatelessWidget {
  final int level;
  final VoidCallback onTap;

  const _CurrentLevelNode({required this.level, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 120, // container area
        height: 140, // include Text below
        child: Column(
          children: [
            // Main Circular Play Button
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFD700), // Gold
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Progress Ring (Simulated)
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: CircularProgressIndicator(
                      value: 0.7, // Random progress for visuals
                      color: Colors.black,
                      backgroundColor: Colors.transparent,
                      strokeWidth: 4,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.play_arrow,
                        color: Colors.black,
                        size: 28,
                      ),
                      Text(
                        'LVL $level',
                        style: GoogleFonts.outfit(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Play Now Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'PLAY NOW',
                style: GoogleFonts.outfit(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletedLevelNode extends StatelessWidget {
  final int level;
  final int index;
  final VoidCallback onTap;

  const _CompletedLevelNode({
    required this.level,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Cycle colors: Blue, Green, Red, Purple
    final List<Color> nodeColors = [
      const Color(0xFF2962FF), // Blue
      const Color(0xFF00C853), // Green
      const Color(0xFFD50000), // Red
      const Color(0xFFAA00FF), // Purple
    ];
    final Color color = nodeColors[index % nodeColors.length]; // cycle colors

    // Random stars 1-3 based on index hash for consistency
    final int stars = (index % 3) + 1;

    // Calculate fill height based on stars (1-3)
    final double fillPercent = stars / 3.0;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 120,
        height: 120,
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // Liquid Fill Effect
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [fillPercent, fillPercent],
                  colors: [
                    color.withValues(alpha: 0.8), // Filled liquid
                    color.withValues(alpha: 0.2), // Empty space
                  ],
                ),
                border: Border.all(color: color, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Inner gloss
                  Positioned(
                    top: 5,
                    child: Container(
                      width: 40,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: const BorderRadius.all(
                          Radius.elliptical(40, 20),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '$level',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        const Shadow(
                          color: Colors.black45,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (starIndex) {
                return Icon(
                  Icons.star,
                  size: 14,
                  color: starIndex < stars
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

class _LockedLevelNode extends StatelessWidget {
  final int level;

  const _LockedLevelNode({required this.level});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1F2633), // Dark grey/blue
              border: Border.all(color: Colors.white10, width: 2),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.lock, color: Colors.white24, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            'Lvl $level',
            style: GoogleFonts.outfit(
              color: Colors.white24,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
