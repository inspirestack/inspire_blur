import 'dart:ui';

import 'package:inspire_blur/src/distribution/blur_distribution_map.dart';

abstract class GradientDistributionMap extends IntensityBasedDistributionMap {
  final List<double> values;
  final List<double> stops;

  GradientDistributionMap({
    required super.width,
    required super.height,
    required this.values,
    required this.stops,
  });

  double sampleGradient(double t) {
    int i = 0;

    while (i < stops.length - 2 && t > stops[i + 1]) {
      i++;
    }

    final next = i + 1;

    final stop0 = stops[i];
    final stop1 = stops[next];

    if (stop0 == stop1) {
      return t > stop0 ? values[next] : values[i];
    }

    final localT = (t - stop0) / (stop1 - stop0);
    final value = lerpDouble(
      values[i],
      values[next],
      localT,
    )!;

    return value;
  }
}
