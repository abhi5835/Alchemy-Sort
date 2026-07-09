import 'dart:ui';
import '../../../core/constants/app_constants.dart';

class TubeLogic {
  final int capacity;
  final List<Color> _liquids = [];

  TubeLogic({
    this.capacity = AppConstants.tubeCapacity,
    List<Color>? initialLiquids,
  }) {
    if (initialLiquids != null) {
      if (initialLiquids.length > capacity) {
        throw Exception('Too many initial liquids');
      }
      _liquids.addAll(initialLiquids);
    }
  }

  List<Color> get liquids => List.unmodifiable(_liquids);

  bool get isFull => _liquids.length == capacity;
  bool get isEmpty => _liquids.isEmpty;
  Color? get topColor => isEmpty ? null : _liquids.last;
  int get currentFill => _liquids.length;

  /// Returns true if this tube is solved (full of same color) or empty.
  bool get isSolved {
    if (isEmpty) return true;
    if (!isFull) return false;
    return _liquids.every((color) => color == _liquids.first);
  }

  bool canAccept(Color color) {
    if (isFull) return false;
    if (isEmpty) return true;
    return topColor == color;
  }

  void addLiquid(Color color) {
    if (!canAccept(color)) throw Exception('Cannot add liquid');
    _liquids.add(color);
  }

  /// Adds liquid without checking color matching rules (checks capacity only).
  /// Used for Undo or Initialization.
  void forceAddLiquid(Color color) {
    if (isFull) throw Exception('Cannot force add: Tube is full');
    _liquids.add(color);
  }

  Color removeLiquid() {
    if (isEmpty) throw Exception('Cannot remove from empty tube');
    return _liquids.removeLast();
  }

  void restoreState(List<Color> newLiquids) {
    if (newLiquids.length > capacity) {
      throw Exception('Too many liquids to restore');
    }
    _liquids.clear();
    _liquids.addAll(newLiquids);
  }
}
