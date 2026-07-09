import 'package:flutter/material.dart';

class PotionVisual extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final bool isDiscovered;
  final double width;
  final double height;

  const PotionVisual({
    super.key,
    required this.primaryColor,
    required this.secondaryColor,
    this.isDiscovered = true,
    this.width = 60,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    if (!isDiscovered) {
      return CustomPaint(
        size: Size(width, height),
        painter: FlaskPainter(
          primaryColor: const Color(0xFF1A1A1A),
          secondaryColor: const Color(0xFF0D0D0D),
          isLocked: true,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
        shape: BoxShape.circle,
      ),
      child: CustomPaint(
        size: Size(width, height),
        painter: FlaskPainter(
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
          isLocked: false,
        ),
      ),
    );
  }
}

class FlaskPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final bool isLocked;

  FlaskPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.isLocked,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    final path = Path();

    // Start at top left lip
    path.moveTo(width * 0.35, height * 0.05);
    path.lineTo(width * 0.65, height * 0.05); // top right lip
    path.lineTo(width * 0.6, height * 0.1); // inner right lip
    path.lineTo(width * 0.6, height * 0.4); // right neck bottom

    // curve down to right base
    path.quadraticBezierTo(
      width * 0.85,
      height * 0.6,
      width * 0.9,
      height * 0.85,
    );
    path.quadraticBezierTo(
      width * 0.9,
      height * 0.95,
      width * 0.75,
      height * 0.95,
    );

    // bottom
    path.lineTo(width * 0.25, height * 0.95);

    // left base
    path.quadraticBezierTo(
      width * 0.1,
      height * 0.95,
      width * 0.1,
      height * 0.85,
    );

    // curve up to left neck bottom
    path.quadraticBezierTo(
      width * 0.15,
      height * 0.6,
      width * 0.4,
      height * 0.4,
    );

    // left neck
    path.lineTo(width * 0.4, height * 0.1); // inner left lip
    path.close();

    // Fill paint
    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [primaryColor, secondaryColor],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);

    if (!isLocked) {
      // Glass highlight
      final highlightPath = Path();
      highlightPath.moveTo(width * 0.3, height * 0.7);
      highlightPath.quadraticBezierTo(
        width * 0.2,
        height * 0.85,
        width * 0.4,
        height * 0.9,
      );

      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(highlightPath, highlightPaint);

      // Cork
      final corkPath = Path();
      corkPath.moveTo(width * 0.4, 0);
      corkPath.lineTo(width * 0.6, 0);
      corkPath.lineTo(width * 0.55, height * 0.05);
      corkPath.lineTo(width * 0.45, height * 0.05);
      corkPath.close();

      final corkPaint = Paint()
        ..color = const Color(0xFF8B5A2B)
        ..style = PaintingStyle.fill;

      canvas.drawPath(corkPath, corkPaint);
    }

    // Outline
    final outlinePaint = Paint()
      ..color = isLocked ? Colors.white12 : Colors.white70
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant FlaskPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor ||
        oldDelegate.isLocked != isLocked;
  }
}
