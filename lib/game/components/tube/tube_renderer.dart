import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' show Colors, LinearGradient, Alignment;
import '../../../core/constants/app_constants.dart';
import 'tube_component.dart';

class TubeRenderer extends PositionComponent {
  late final RRect _rrect;
  late final Paint _bodyPaint;
  late final Paint _borderPaint;
  late final Paint _selectedPaint;
  late final Rect _rimRect;
  late final Paint _rimPaint;
  late final Paint _rimFillPaint;
  late final Paint _reflectionPaint;
  late final Path _reflectionPath;
  late final Rect _capRect;
  late final Paint _capPaint;
  late final Paint _capBorder;
  late final Paint _starPaint;
  late final Offset _starOffset;

  TubeRenderer() {
    size = Vector2(AppConstants.tubeWidth, AppConstants.tubeHeight);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final rect = size.toRect();
    final radius = Radius.circular(size.x / 2);
    _rrect = RRect.fromRectAndCorners(
      rect,
      bottomLeft: radius,
      bottomRight: radius,
    );

    _bodyPaint = Paint()
      ..color = const Color(0xFF000000).withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    _borderPaint = Paint()
      ..color = const Color(0xFFAAAAAA).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    _selectedPaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 4.0);

    _rimRect = Rect.fromLTWH(0, -2, size.x, 6);
    _rimPaint = Paint()
      ..color = const Color(0xFFCCCCCC).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    _rimFillPaint = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    _reflectionPaint = Paint()
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

    _reflectionPath = Path()
      ..moveTo(size.x * 0.2, 10)
      ..lineTo(size.x * 0.2, size.y - 10);

    _capRect = Rect.fromLTWH(-4, -6, size.x + 8, 12);
    _capPaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;

    _capBorder = Paint()
      ..color = const Color(0xFFFFAB00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    _starPaint = Paint()..color = Colors.white.withValues(alpha: 0.8);
    _starOffset = Offset(size.x / 2, 0.0);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(_rrect, _bodyPaint);
    canvas.drawRRect(_rrect, _borderPaint);

    final parentTube = parent as TubeComponent?;
    if (parentTube != null && parentTube.isSelected) {
      canvas.drawRRect(_rrect, _selectedPaint);
    }

    canvas.drawOval(_rimRect, _rimFillPaint);
    canvas.drawOval(_rimRect, _rimPaint);

    canvas.drawPath(_reflectionPath, _reflectionPaint);

    if (parentTube != null &&
        parentTube.logic.isSolved &&
        !parentTube.logic.isEmpty) {
      canvas.drawOval(_capRect, _capPaint);
      canvas.drawOval(_capRect, _capBorder);
      canvas.drawCircle(_starOffset, 3, _starPaint);
    }
  }
}
