import 'package:flutter/widgets.dart';
import 'package:inspire_blur/src/distribution/maps/gradient_distribution_map.dart';
import 'package:inspire_blur/src/utils/extensions/inspire_geometry_extensions.dart';

class DirectionalDistributionMap extends GradientDistributionMap {
  final Alignment begin;
  final Alignment end;

  late final Offset beginUV;
  late final Offset endUV;
  late final Offset gradientVector;
  late final double beginEndDistanceInvSquared;

  DirectionalDistributionMap({
    required super.width,
    required super.height,
    required super.values,
    required super.stops,
    required this.begin,
    required this.end,
  }) {
    beginUV = begin.toNormalizedOffset();
    endUV = end.toNormalizedOffset();
    gradientVector = endUV - beginUV;
    beginEndDistanceInvSquared = 1.0 / gradientVector.dot(gradientVector);
  }

  @override
  double intensityAt(double u, double v) {
    final point = Offset(u, v) - beginUV;

    return sampleGradient(
      point.dot(gradientVector) * beginEndDistanceInvSquared,
    );
  }
}
