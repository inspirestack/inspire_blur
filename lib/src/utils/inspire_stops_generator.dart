import 'dart:ui';

import 'package:flutter/widgets.dart';

/// Generates gradient control points as `(value, stop)` pairs that
/// fade from `1.0` to `0.0` using the provided [curve].
///
/// [startStop] and [endStop] may be outside the `[0.0, 1.0]` range,
/// provided that [startStop] is less than or equal to [endStop].
///
/// [stopsCount] can be increased for better interpolation accuracy.
List<(double value, double stop)> curveToValuesAndStops({
  required double endStop,
  required Curve curve,
  double startStop = 0.0,
  int stopsCount = 16,
}) {
  assert(startStop <= endStop);
  assert(stopsCount >= 2);

  if (startStop >= endStop) {
    return [
      (1.0, startStop),
      (0.0, endStop),
    ];
  }

  final result = <(double value, double stop)>[];

  if (startStop > 0.0) {
    result.add((1.0, 0.0));
  }

  result.addAll(List.generate(stopsCount, (i) {
    final t = i / (stopsCount - 1);
    final stop = lerpDouble(startStop, endStop, t)!;
    final value = curve.transform(1.0 - t).clamp(0.0, 1.0);
    return (value, stop);
  }));

  if (endStop < 1.0) {
    result.add((0.0, 1.0));
  }

  return result;
}
