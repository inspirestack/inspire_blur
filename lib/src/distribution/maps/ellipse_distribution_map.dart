import 'dart:math' show sqrt;

import 'package:flutter/painting.dart';
import 'package:inspire_blur/src/distribution/maps/gradient_distribution_map.dart';
import 'package:inspire_blur/src/utils/extensions/inspire_geometry_extensions.dart';

class EllipseDistributionMap extends GradientDistributionMap {
  /// Horizontal radius of the ellipse.
  ///
  /// Normalized to the range `[0.0, 1.0]`. Values greater than `1.0` are
  /// allowed.
  final double radiusX;

  /// Vertical radius of the ellipse.
  ///
  /// Normalized to the range `[0.0, 1.0]`. Values greater than `1.0` are
  /// allowed.
  final double radiusY;

  /// Center point of the ellipse.
  final Alignment center;

  /// Center point of the ellipse represented in UV coordinates.
  final Offset centerUV;

  EllipseDistributionMap({
    required super.width,
    required super.height,
    required super.values,
    required super.stops,
    required this.radiusX,
    required this.radiusY,
    required this.center,
  }) : centerUV = center.toNormalizedOffset();

  @override
  double intensityAt(double u, double v) {
    if (radiusX <= 0.0 || radiusY <= 0.0) return 0.0;

    final dx = (u - centerUV.dx) / radiusX;
    final dy = (v - centerUV.dy) / radiusY;

    final d = sqrt(dx * dx + dy * dy);

    return sampleGradient(d);
  }
}
