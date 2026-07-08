import 'dart:ui';
import 'package:flame/components.dart';

class LiquidLayer extends PositionComponent {
  final Color liquidColor;
  final bool isBottomLayer;

  LiquidLayer({required this.liquidColor, this.isBottomLayer = false});

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = liquidColor;
    final rect = size.toRect();

    if (isBottomLayer) {
      // Clip to rounded bottom
      final radius = Radius.circular(size.x / 2);
      final rrect = RRect.fromRectAndCorners(
        rect,
        bottomLeft: radius,
        bottomRight: radius,
      );
      canvas.drawRRect(rrect, paint);
    } else {
      canvas.drawRect(rect, paint);
    }
  }
}
