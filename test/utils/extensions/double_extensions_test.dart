import 'package:flutter_test/flutter_test.dart';
import 'package:inspire_blur/src/utils/extensions/inspire_double_extensions.dart';

void main() {
  group('coerceAtLeast', () {
    final cases = [
      (value: 0.0, min: 0.0, expected: 0.0),
      (value: 0.0, min: 1.0, expected: 1.0),
      (value: 1.0, min: 0.0, expected: 1.0),
      (value: 0.0, min: -1.0, expected: 0.0),
      (value: -1.0, min: 0.0, expected: 0.0),
      (value: -0.0001, min: 0.0, expected: 0.0),
      (value: 0.0001, min: 0.0, expected: 0.0001),
      (value: 123.0, min: 234.0, expected: 234.0),
      (value: -123.0, min: 234.0, expected: 234.0),
      (value: 9999.9999, min: 9999.9999, expected: 9999.9999),
      (value: 9999.0, min: 9999.9999, expected: 9999.9999),
    ];

    for (final c in cases) {
      test('${c.value}.coerceAtLeast(${c.min}) == ${c.expected}', () {
        expect(c.value.coerceAtLeast(c.min), c.expected);
      });
    }
  });

  group('coerceAtMost', () {
    final cases = [
      (value: 0.0, max: 0.0, expected: 0.0),
      (value: 0.0, max: 1.0, expected: 0.0),
      (value: 1.0, max: 0.0, expected: 0.0),
      (value: 0.0, max: -1.0, expected: -1.0),
      (value: -1.0, max: 0.0, expected: -1.0),
      (value: -0.0001, max: 0.0, expected: -0.0001),
      (value: 0.0001, max: 0.0, expected: 0.0),
      (value: 123.0, max: 234.0, expected: 123.0),
      (value: -123.0, max: 234.0, expected: -123.0),
      (value: 9999.9999, max: 9999.9999, expected: 9999.9999),
      (value: 9999.0, max: 9999.9999, expected: 9999.0),
    ];

    for (final c in cases) {
      test('${c.value}.coerceAtMost(${c.max}) == ${c.expected}', () {
        expect(c.value.coerceAtMost(c.max), c.expected);
      });
    }
  });

  group('takeNegativeOrZero', () {
    final cases = [
      (value: 0.0, expected: 0.0),
      (value: -0.001234, expected: -0.001234),
      (value: -1.0, expected: -1.0),
      (value: -1234.0, expected: -1234.0),
      (value: -1234.5678, expected: -1234.5678),
      (value: 0.001234, expected: 0.0),
      (value: 1.0, expected: 0.0),
      (value: 1234.0, expected: 0.0),
      (value: 1234.5678, expected: 0.0),
    ];

    for (final c in cases) {
      test('${c.value}.takeNegativeOrZero() == ${c.expected}', () {
        expect(c.value.takeNegativeOrZero(), c.expected);
      });
    }
  });

  group('takePositiveOrZero', () {
    final cases = [
      (value: 0.0, expected: 0.0),
      (value: -0.001234, expected: 0.0),
      (value: -1.0, expected: 0.0),
      (value: -1234.0, expected: 0.0),
      (value: -1234.5678, expected: 0.0),
      (value: 0.001234, expected: 0.001234),
      (value: 1.0, expected: 1.0),
      (value: 1234.0, expected: 1234.0),
      (value: 1234.5678, expected: 1234.5678),
    ];

    for (final c in cases) {
      test('${c.value}.takePositiveOrZero() == ${c.expected}', () {
        expect(c.value.takePositiveOrZero(), c.expected);
      });
    }
  });

  group('isCloseTo', () {
    final cases = [
      (value: 0.0, other: 0.0, isClose: true),

      (value: -100.0, other: -100.0, isClose: true),
      (value: -0.123456, other: -0.123456, isClose: true),

      (value: 100.0, other: 100.0, isClose: true),
      (value: 0.123456, other: 0.123456, isClose: true),

      // epsilon boundary
      (value: 0.0, other: 1e-7, isClose: true),
      (value: 0.0, other: -1e-7, isClose: true),

      // within epsilon
      (value: 0.0, other: 1e-7, isClose: true),
      (value: 0.0, other: 1e-12, isClose: true),

      // outside epsilon
      (value: 0.0, other: 1e-6, isClose: false),
      (value: 0.0, other: -1e-6, isClose: false),
    ];

    for (final c in cases) {
      test('${c.value}.isCloseTo(${c.other}) == ${c.isClose}', () {
        expect(c.value.isCloseTo(c.other), c.isClose);
        expect(c.value.isNotCloseTo(c.other), !c.isClose);
      });
    }
  });
}
