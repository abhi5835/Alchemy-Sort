import 'dart:math';
import 'package:flutter/material.dart';
import '../models/alchemy_world_theme.dart';

class AlchemyWorldBackground extends StatelessWidget {
  final int levelCount;
  final double nodeGap;
  final ScrollController scrollController;

  const AlchemyWorldBackground({
    super.key,
    required this.levelCount,
    required this.nodeGap,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    // Instead of completely dynamic background that listens to scroll constantly,
    // we'll draw a continuous gradient background over the entire scroll extent.
    // The CustomPainter will draw the elements based on height.

    final double totalHeight = nodeGap * levelCount + 300;

    return Container(
      height: totalHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF101420), // Fallback base
      ),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _WorldBackgroundPainter(
            levelCount: levelCount,
            nodeGap: nodeGap,
            themes: AlchemyWorldTheme.worlds,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _WorldBackgroundPainter extends CustomPainter {
  final int levelCount;
  final double nodeGap;
  final List<AlchemyWorldTheme> themes;

  _WorldBackgroundPainter({
    required this.levelCount,
    required this.nodeGap,
    required this.themes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // The coordinate system:
    // y = 0 is the TOP of the scroll view (highest level).
    // y = size.height is the BOTTOM of the scroll view (level 1).

    // We will paint bands of background gradients for each theme.
    // To do this efficiently, we can just use linear gradients for each section.

    for (final theme in themes) {
      // Calculate start and end Y for this theme's section
      // Level 1 is at bottom (y = size.height - 150)
      // Level 20 is at y = size.height - 150 - (20 * nodeGap)

      // We extend the boundaries a bit so they overlap smoothly
      double startY =
          size.height - 150 - (theme.endLevel * nodeGap) - (nodeGap / 2);
      double endY =
          size.height -
          150 -
          ((theme.startLevel - 1) * nodeGap) +
          (nodeGap / 2);

      // Clamp to bounds
      startY = max(0, startY);
      endY = min(size.height, endY);

      if (endY <= startY) continue;

      final rect = Rect.fromLTRB(0, startY, size.width, endY);

      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: theme.backgroundGradient,
          stops: const [0.0, 0.5, 1.0],
        ).createShader(rect);

      canvas.drawRect(rect, paint);

      // Draw procedural decorations based on theme name
      _drawProceduralDecorations(canvas, rect, theme);
    }
  }

  void _drawProceduralDecorations(
    Canvas canvas,
    Rect rect,
    AlchemyWorldTheme theme,
  ) {
    // Lightweight decorations based on theme
    final random = Random(theme.name.hashCode);

    final paint = Paint()..style = PaintingStyle.fill;

    int elementCount = 15; // Budget per section

    for (int i = 0; i < elementCount; i++) {
      final x = random.nextDouble() * rect.width;
      final y = rect.top + random.nextDouble() * rect.height;
      final radius = 10.0 + random.nextDouble() * 30.0;

      if (theme.name == 'MYSTIC GARDEN') {
        paint.color = Colors.white.withValues(alpha: 0.05);
        canvas.drawCircle(Offset(x, y), radius, paint);
      } else if (theme.name == 'CRYSTAL CAVES') {
        paint.color = const Color(0xFF00E5FF).withValues(alpha: 0.05);
        final path = Path()
          ..moveTo(x, y - radius)
          ..lineTo(x + radius * 0.6, y + radius)
          ..lineTo(x - radius * 0.6, y + radius)
          ..close();
        canvas.drawPath(path, paint);
      } else if (theme.name == 'MOONLIGHT LAB') {
        paint.color = const Color(0xFFD500F9).withValues(alpha: 0.05);
        canvas.drawCircle(Offset(x, y), radius, paint);
      } else {
        // Generic soft glow
        paint.color = theme.nodeAccentColor.withValues(alpha: 0.05);
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WorldBackgroundPainter oldDelegate) {
    return oldDelegate.levelCount != levelCount ||
        oldDelegate.nodeGap != nodeGap;
  }
}
