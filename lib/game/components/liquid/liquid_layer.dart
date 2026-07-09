import 'dart:ui';
import 'package:flame/components.dart';

class LiquidLayer extends PositionComponent {
  Color _liquidColor;
  final bool isBottomLayer;
  late final Paint _paint;

  LiquidLayer({required Color liquidColor, this.isBottomLayer = false})
    : _liquidColor = liquidColor {
    _paint = Paint()..color = liquidColor;
  }

  Color get liquidColor => _liquidColor;
  set liquidColor(Color value) {
    _liquidColor = value;
    _paint.color = value;
  }

  @override
  void render(Canvas canvas) {
    final rect = size.toRect();

    if (isBottomLayer) {
      // Clip to rounded bottom
      final radius = Radius.circular(size.x / 2);
      final rrect = RRect.fromRectAndCorners(
        rect,
        bottomLeft: radius,
        bottomRight: radius,
      );
      canvas.drawRRect(rrect, _paint);
    } else {
      canvas.drawRect(rect, _paint);
    }
  }
}
