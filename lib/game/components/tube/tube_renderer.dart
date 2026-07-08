import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' show Colors, LinearGradient, Alignment;
import '../../../core/constants/app_constants.dart';
import 'tube_component.dart';

class TubeRenderer extends PositionComponent {
  TubeRenderer() {
    size = Vector2(AppConstants.tubeWidth, AppConstants.tubeHeight);
  }

  @override
  void render(Canvas canvas) {
    final rect = size.toRect();
    final radius = Radius.circular(size.x / 2);
    // Round bottom, straight top
    final rrect = RRect.fromRectAndCorners(
      rect,
      bottomLeft: radius,
      bottomRight: radius,
    );

    // 1. Darker Body (Translucent Black)
    final bodyPaint = Paint()
      ..color = const Color(0xFF000000).withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    // 2. Distinct Outline (White/Grey)
    final borderPaint = Paint()
      ..color = const Color(0xFFAAAAAA).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // 3. Draw Body and Border
    canvas.drawRRect(rrect, bodyPaint);
    canvas.drawRRect(rrect, borderPaint);

    // Selected Outline
    final parentTube = parent as TubeComponent?;
    if (parentTube != null && parentTube.isSelected) {
      final selectedPaint = Paint()
        ..color =
            const Color(0xFFFFD700) // Gold outline
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..maskFilter = const MaskFilter.blur(
          BlurStyle.outer,
          4.0,
        ); // Glow effect

      canvas.drawRRect(rrect, selectedPaint);
    }

    // 4. Rim Design (Oval at top)
    // The reference has a distinct "cap" or thicker rim at the top.
    final rimRect = Rect.fromLTWH(0, -2, size.x, 6);
    final rimPaint = Paint()
      ..color = const Color(0xFFCCCCCC).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final rimFillPaint = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    canvas.drawOval(rimRect, rimFillPaint);
    canvas.drawOval(rimRect, rimPaint);

    // 5. Highlights (Reflection)
    // Vertical reflection line
    final reflectionPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.05),
          Colors.white.withValues(alpha: 0.5),
          Colors.white.withValues(alpha: 0.05),
        ],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw reflection on the left side
    final reflectionPath = Path()
      ..moveTo(size.x * 0.2, 10)
      ..lineTo(size.x * 0.2, size.y - 10);
    canvas.drawPath(reflectionPath, reflectionPaint);

    // 6. Solved Cap (Gold Lid)
    if (parentTube != null &&
        parentTube.logic.isSolved &&
        !parentTube.logic.isEmpty) {
      final capRect = Rect.fromLTWH(-4, -6, size.x + 8, 12);
      final capPaint = Paint()
        ..color =
            const Color(0xFFFFD700) // Gold
        ..style = PaintingStyle.fill;

      final capBorder = Paint()
        ..color = const Color(0xFFFFAB00)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      // Draw Cap
      canvas.drawOval(capRect, capPaint);
      canvas.drawOval(capRect, capBorder);

      // Star on Cap (Simplified to a dot for now)
      final cx = size.x / 2;
      final cy = 0.0;
      canvas.drawCircle(
        Offset(cx, cy),
        3,
        Paint()..color = Colors.white.withValues(alpha: 0.8),
      );
    }
  }
}
