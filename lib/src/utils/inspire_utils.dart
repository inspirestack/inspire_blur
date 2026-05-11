import 'package:flutter/material.dart';

extension KeyLayoutExtensions on GlobalKey {
  Rect? getGlobalRenderBoxBounds() {
    final context = currentContext;

    if (context == null || !context.mounted) return null;

    try {
      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null || !renderBox.hasSize) return null;

      return renderBox.localToGlobal(Offset.zero) & renderBox.size;
    } catch (_) {
      return null;
    }
  }
}

extension RectExtensions on Rect {
  bool isClose(Rect other, {double epsilon = 1.0e-1}) {
    if (identical(this, other)) return true;

    if ((left - other.left).abs() > epsilon) return false;
    if ((top - other.top).abs() > epsilon) return false;
    if ((right - other.right).abs() > epsilon) return false;
    if ((bottom - other.bottom).abs() > epsilon) return false;

    return true;
  }

  bool isNotClose(Rect other, {double epsilon = 1.0e-1}) =>
      !isClose(other, epsilon: epsilon);
}

extension NumExtensions on double {
  double coerceAtLeast(double min) {
    return this < min ? min : this;
  }

  double takeNegativeOrZero() {
    return this < 0.0 ? this : 0.0;
  }

  double takePositiveOrZero() {
    return this > 0.0 ? this : 0.0;
  }
}

List<(double, double)> curveToStops({
  required double extent,
  required Curve curve,
  int stopsCount = 10,
}) {
  assert(
    extent >= 0.0 && extent <= 1.0,
    'Provide extent in range between 0.0 and 1.0',
  );

  assert(stopsCount >= 2, 'stopsCount must be >= 2');

  if (extent == 0.0) {
    return [(0.0, curve.transform(1.0)), (1.0, curve.transform(0.0))];
  }

  return List.generate(
    stopsCount,
    (i) {
      final t = i / (stopsCount - 1);
      final stop = t * extent;
      final value = curve.transform(1 - t).clamp(0.0, 1.0);
      return (stop, value);
    },
  );
}
