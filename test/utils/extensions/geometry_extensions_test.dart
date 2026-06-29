import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inspire_blur/src/utils/extensions/inspire_double_extensions.dart';
import 'package:inspire_blur/src/utils/extensions/inspire_geometry_extensions.dart';

void main() {
  group('RectExtensions.isClose', () {
    const rect = Rect.fromLTRB(1.0, 2.0, 3.0, 4.0);

    final cases = [
      (
        description: 'same instance',
        rectA: rect,
        rectB: rect,
        epsilon: 1.0e-7,
        isClose: true,
      ),
      (
        description: 'equal empty rects',
        rectA: const Rect.fromLTRB(0.0, 0.0, 0.0, 0.0),
        rectB: const Rect.fromLTRB(0.0, 0.0, 0.0, 0.0),
        epsilon: 1.0e-7,
        isClose: true,
      ),
      (
        description: 'equal arbitrary rects',
        rectA: const Rect.fromLTRB(12.34, 56.78, 999.999, 0.0000001),
        rectB: const Rect.fromLTRB(12.34, 56.78, 999.999, 0.0000001),
        epsilon: 1.0e-7,
        isClose: true,
      ),
      (
        description: 'left difference below epsilon',
        rectA: const Rect.fromLTRB(100.00000009, 100.0, 100.0, 100.0),
        rectB: const Rect.fromLTRB(100.0, 100.0, 100.0, 100.0),
        epsilon: 1.0e-7,
        isClose: true,
      ),
      (
        description: 'left difference equal to epsilon',
        rectA: const Rect.fromLTRB(100.0000001, 100.0, 100.0, 100.0),
        rectB: const Rect.fromLTRB(100.0, 100.0, 100.0, 100.0),
        epsilon: 1.0e-7,
        isClose: true,
      ),
      (
        description: 'left difference above epsilon',
        rectA: const Rect.fromLTRB(100.00000011, 100.0, 100.0, 100.0),
        rectB: const Rect.fromLTRB(100.0, 100.0, 100.0, 100.0),
        epsilon: 1.0e-7,
        isClose: false,
      ),
      (
        description: 'top difference below epsilon',
        rectA: const Rect.fromLTRB(100.0, 100.00000009, 100.0, 100.0),
        rectB: const Rect.fromLTRB(100.0, 100.0, 100.0, 100.0),
        epsilon: 1.0e-7,
        isClose: true,
      ),
      (
        description: 'top difference equal to epsilon',
        rectA: const Rect.fromLTRB(100.0, 100.0000001, 100.0, 100.0),
        rectB: const Rect.fromLTRB(100.0, 100.0, 100.0, 100.0),
        epsilon: 1.0e-7,
        isClose: true,
      ),
      (
        description: 'top difference above epsilon',
        rectA: const Rect.fromLTRB(100.0, 100.00000011, 100.0, 100.0),
        rectB: const Rect.fromLTRB(100.0, 100.0, 100.0, 100.0),
        epsilon: 1.0e-7,
        isClose: false,
      ),
      (
        description: 'right difference below epsilon',
        rectA: const Rect.fromLTRB(100.0, 100.0, 100.00000009, 100.0),
        rectB: const Rect.fromLTRB(100.0, 100.0, 100.0, 100.0),
        epsilon: 1.0e-7,
        isClose: true,
      ),
      (
        description: 'right difference equal to epsilon',
        rectA: const Rect.fromLTRB(100.0, 100.0, 100.0000001, 100.0),
        rectB: const Rect.fromLTRB(100.0, 100.0, 100.0, 100.0),
        epsilon: 1.0e-7,
        isClose: true,
      ),
      (
        description: 'right difference above epsilon',
        rectA: const Rect.fromLTRB(100.0, 100.0, 100.00000011, 100.0),
        rectB: const Rect.fromLTRB(100.0, 100.0, 100.0, 100.0),
        epsilon: 1.0e-7,
        isClose: false,
      ),
      (
        description: 'bottom difference below epsilon',
        rectA: const Rect.fromLTRB(100.0, 100.0, 100.0, 100.00000009),
        rectB: const Rect.fromLTRB(100.0, 100.0, 100.0, 100.0),
        epsilon: 1.0e-7,
        isClose: true,
      ),
      (
        description: 'bottom difference equal to epsilon',
        rectA: const Rect.fromLTRB(100.0, 100.0, 100.0, 100.0000001),
        rectB: const Rect.fromLTRB(100.0, 100.0, 100.0, 100.0),
        epsilon: 1.0e-7,
        isClose: true,
      ),
      (
        description: 'bottom difference above epsilon',
        rectA: const Rect.fromLTRB(100.0, 100.0, 100.0, 100.00000011),
        rectB: const Rect.fromLTRB(100.0, 100.0, 100.0, 100.0),
        epsilon: 1.0e-7,
        isClose: false,
      ),
      (
        description: 'all differences below epsilon',
        rectA: const Rect.fromLTRB(
          100.00000009,
          100.00000009,
          100.00000009,
          100.00000009,
        ),
        rectB: const Rect.fromLTRB(100.0, 100.0, 100.0, 100.0),
        epsilon: 1.0e-7,
        isClose: true,
      ),
      (
        description: 'all differences equal to epsilon',
        rectA: const Rect.fromLTRB(
          100.0000001,
          100.0000001,
          100.0000001,
          100.0000001,
        ),
        rectB: const Rect.fromLTRB(100.0, 100.0, 100.0, 100.0),
        epsilon: 1.0e-7,
        isClose: true,
      ),
      (
        description: 'all differences above epsilon',
        rectA: const Rect.fromLTRB(
          100.00000011,
          100.00000011,
          100.00000011,
          100.00000011,
        ),
        rectB: const Rect.fromLTRB(100.0, 100.0, 100.0, 100.0),
        epsilon: 1.0e-7,
        isClose: false,
      ),
    ];

    for (final c in cases) {
      test(c.description, () {
        expect(c.rectA.isClose(c.rectB, epsilon: c.epsilon), c.isClose);
        expect(c.rectB.isClose(c.rectA, epsilon: c.epsilon), c.isClose);
        expect(c.rectA.isNotClose(c.rectB, epsilon: c.epsilon), !c.isClose);
        expect(c.rectB.isNotClose(c.rectA, epsilon: c.epsilon), !c.isClose);
      });
    }
  });

  group('OffsetExtensions.isClose', () {
    const offset = Offset(1.0, 2.0);

    final cases = [
      (
        description: 'same instance',
        offsetA: offset,
        offsetB: offset,
        epsilon: 1.0e-7,
        isClose: true,
      ),
      (
        description: 'equal zero offsets',
        offsetA: Offset.zero,
        offsetB: Offset.zero,
        epsilon: 1.0e-7,
        isClose: true,
      ),
      (
        description: 'equal arbitrary offsets',
        offsetA: const Offset(12.34, 56.78),
        offsetB: const Offset(12.34, 56.78),
        epsilon: 1.0e-7,
        isClose: true,
      ),
      (
        description: 'dx difference below epsilon',
        offsetA: const Offset(100.00000009, 100.0),
        offsetB: const Offset(100.0, 100.0),
        epsilon: 1.0e-7,
        isClose: true,
      ),
      (
        description: 'dx difference equal to epsilon',
        offsetA: const Offset(100.0000001, 100.0),
        offsetB: const Offset(100.0, 100.0),
        epsilon: 1.0e-7,
        isClose: true,
      ),
      (
        description: 'dx difference above epsilon',
        offsetA: const Offset(100.00000011, 100.0),
        offsetB: const Offset(100.0, 100.0),
        epsilon: 1.0e-7,
        isClose: false,
      ),
      (
        description: 'dy difference below epsilon',
        offsetA: const Offset(100.0, 100.00000009),
        offsetB: const Offset(100.0, 100.0),
        epsilon: 1.0e-7,
        isClose: true,
      ),
      (
        description: 'dy difference equal to epsilon',
        offsetA: const Offset(100.0, 100.0000001),
        offsetB: const Offset(100.0, 100.0),
        epsilon: 1.0e-7,
        isClose: true,
      ),
      (
        description: 'dy difference above epsilon',
        offsetA: const Offset(100.0, 100.00000011),
        offsetB: const Offset(100.0, 100.0),
        epsilon: 1.0e-7,
        isClose: false,
      ),
      (
        description: 'both differences below epsilon',
        offsetA: const Offset(100.00000009, 100.00000009),
        offsetB: const Offset(100.0, 100.0),
        epsilon: 1.0e-7,
        isClose: true,
      ),
      (
        description: 'both differences equal to epsilon',
        offsetA: const Offset(100.0000001, 100.0000001),
        offsetB: const Offset(100.0, 100.0),
        epsilon: 1.0e-7,
        isClose: true,
      ),
      (
        description: 'both differences above epsilon',
        offsetA: const Offset(100.00000011, 100.00000011),
        offsetB: const Offset(100.0, 100.0),
        epsilon: 1.0e-7,
        isClose: false,
      ),
    ];

    for (final c in cases) {
      test(c.description, () {
        expect(c.offsetA.isClose(c.offsetB, epsilon: c.epsilon), c.isClose);
        expect(c.offsetB.isClose(c.offsetA, epsilon: c.epsilon), c.isClose);
        expect(c.offsetA.isNotClose(c.offsetB, epsilon: c.epsilon), !c.isClose);
        expect(c.offsetB.isNotClose(c.offsetA, epsilon: c.epsilon), !c.isClose);
      });
    }
  });

  group('OffsetExtensions.dot', () {
    final cases = [
      (
        value: 0.0,
        offset1: const Offset(0.0, 0.0),
        offset2: const Offset(0.0, 0.0),
      ),
      (
        value: 2.0,
        offset1: const Offset(1.0, 0.0),
        offset2: const Offset(2.0, 0.0),
      ),
      (
        value: 3.0,
        offset1: const Offset(0.0, 1.0),
        offset2: const Offset(0.0, 3.0),
      ),
      (
        value: 2.0,
        offset1: const Offset(1.0, 1.0),
        offset2: const Offset(1.0, 1.0),
      ),
      (
        value: 0.2,
        offset1: const Offset(0.1, 1.0),
        offset2: const Offset(1.0, 0.1),
      ),
      (
        value: -2.0,
        offset1: const Offset(1.0, 0.0),
        offset2: const Offset(-2.0, 0.0),
      ),
      (
        value: -3.0,
        offset1: const Offset(0.0, 1.0),
        offset2: const Offset(0.0, -3.0),
      ),
      (
        value: 2.0,
        offset1: const Offset(-1.0, -1.0),
        offset2: const Offset(-1.0, -1.0),
      ),
      (
        value: -0.2,
        offset1: const Offset(-0.1, -1.0),
        offset2: const Offset(1.0, 0.1),
      ),
    ];

    for (final c in cases) {
      test('${c.offset1}.dot(${c.offset2}) == ${c.value}', () {
        expect(
          c.offset1.dot(c.offset2).isCloseTo(c.value),
          isTrue,
        );
      });
    }
  });

  group('Alignment.toNormalizedOffset', () {
    final cases = [
      (offset: const Offset(0.0, 0.0), alignment: Alignment.topLeft),
      (offset: const Offset(0.5, 0.0), alignment: Alignment.topCenter),
      (offset: const Offset(1.0, 0.0), alignment: Alignment.topRight),
      (offset: const Offset(0.0, 0.5), alignment: Alignment.centerLeft),
      (offset: const Offset(0.5, 0.5), alignment: Alignment.center),
      (offset: const Offset(1.0, 0.5), alignment: Alignment.centerRight),
      (offset: const Offset(0.0, 1.0), alignment: Alignment.bottomLeft),
      (offset: const Offset(0.5, 1.0), alignment: Alignment.bottomCenter),
      (offset: const Offset(1.0, 1.0), alignment: Alignment.bottomRight),
      (
        offset: const Offset(0.25, 0.75),
        alignment: const Alignment(-0.5, 0.5),
      ),
      (
        offset: const Offset(0.75, 0.25),
        alignment: const Alignment(0.5, -0.5),
      ),
      (
        offset: const Offset(0.6, 0.9),
        alignment: const Alignment(0.2, 0.8),
      ),
      (
        offset: const Offset(0.05, 0.95),
        alignment: const Alignment(-0.9, 0.9),
      ),
    ];

    for (final c in cases) {
      test('${c.alignment}.toNormalizedOffset() == ${c.offset}', () {
        expect(
          c.alignment.toNormalizedOffset().isClose(c.offset),
          isTrue,
        );
      });
    }
  });
}
