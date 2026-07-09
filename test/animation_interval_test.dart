import 'package:flutter_test/flutter_test.dart';
import 'package:alchemy_sort/utils/animation_utils.dart';

void main() {
  group('Animation Interval Bounds Tests', () {
    test('1 item generates valid interval', () {
      final start = AnimationUtils.normalizedIntervalStart(
        index: 0,
        itemCount: 1,
        animationSpan: 1.0,
      );
      expect(start, greaterThanOrEqualTo(0.0));
      expect(start, lessThanOrEqualTo(1.0));
    });

    for (final count in [2, 3, 6, 10, 20]) {
      test('$count items generate valid intervals', () {
        final span = 0.5; // testing a typical span
        for (int i = 0; i < count; i++) {
          final start = AnimationUtils.normalizedIntervalStart(
            index: i,
            itemCount: count,
            animationSpan: span,
          );
          final end = start + (span / count);

          expect(start, greaterThanOrEqualTo(0.0));
          expect(end, lessThanOrEqualTo(1.0));
          expect(start, lessThan(end));
        }
      });
    }

    test('WinDialog sections count interval validity', () {
      // WinDialog has 3 stat rows
      final count = 3;
      final span = 0.6;
      for (int i = 0; i < count; i++) {
        final start = AnimationUtils.normalizedIntervalStart(
          index: i,
          itemCount: count,
          animationSpan: span,
        );
        final end = start + (span / count);
        expect(start, greaterThanOrEqualTo(0.0));
        expect(end, lessThanOrEqualTo(1.0));
        expect(start, lessThan(end));
      }
    });

    test('DailyCompleteDialog conditional items interval validity', () {
      // DailyCompleteDialog might animate 2 to 5 items conditionally
      for (final count in [2, 3, 4, 5]) {
        final span = 0.4;
        for (int i = 0; i < count; i++) {
          final start = AnimationUtils.normalizedIntervalStart(
            index: i,
            itemCount: count,
            animationSpan: span,
          );
          final end = start + (span / count);
          expect(start, greaterThanOrEqualTo(0.0));
          expect(end, lessThanOrEqualTo(1.0));
          expect(start, lessThan(end));
        }
      }
    });
  });
}
