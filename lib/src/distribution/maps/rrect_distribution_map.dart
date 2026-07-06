import 'dart:math' show max, sqrt, min;

import 'package:inspire_blur/src/distribution/maps/gradient_distribution_map.dart';

class RRectDistributionMap extends GradientDistributionMap {
  final double horizontalInset;
  final double verticalInset;
  final double cornerRadius;

  late final double left;
  late final double right;
  late final double top;
  late final double bottom;

  late final double centerX;
  late final double centerY;

  late final double halfWidth;
  late final double halfHeight;

  late final double effectiveRadius;

  late final double centerDistance;

  RRectDistributionMap({
    required super.width,
    required super.height,
    required super.values,
    required super.stops,
    required this.horizontalInset,
    required this.verticalInset,
    required this.cornerRadius,
  }) {
    left = horizontalInset;
    right = 1.0 - horizontalInset;
    top = verticalInset;
    bottom = 1.0 - verticalInset;

    centerX = (left + right) * 0.5;
    centerY = (top + bottom) * 0.5;

    halfWidth = (right - left) * 0.5;
    halfHeight = (bottom - top) * 0.5;

    effectiveRadius = cornerRadius * min(halfWidth, halfHeight);

    centerDistance = _signedDistanceToRRect(
      x: 0.0,
      y: 0.0,
      halfWidth: halfWidth,
      halfHeight: halfHeight,
      radius: effectiveRadius,
    ).abs();
  }

  @override
  double intensityAt(double u, double v) {
    if (halfWidth <= 0.0 || halfHeight <= 0.0) {
      return 0.0;
    }

    final signedDistance = _signedDistanceToRRect(
      x: u - centerX,
      y: v - centerY,
      halfWidth: halfWidth,
      halfHeight: halfHeight,
      radius: effectiveRadius,
    );

    final position =
        centerDistance == 0.0 ? 1.0 : 1.0 + signedDistance / centerDistance;

    return sampleGradient(position);
  }

  static double _signedDistanceToRRect({
    required double x,
    required double y,
    required double halfWidth,
    required double halfHeight,
    required double radius,
  }) {
    final qx = x.abs() - (halfWidth - radius);
    final qy = y.abs() - (halfHeight - radius);

    final outsideX = max(qx, 0.0);
    final outsideY = max(qy, 0.0);

    final outsideDistance = sqrt(outsideX * outsideX + outsideY * outsideY);
    final insideDistance = min(max(qx, qy), 0.0);

    return outsideDistance + insideDistance - radius;
  }
}
