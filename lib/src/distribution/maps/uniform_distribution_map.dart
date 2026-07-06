import 'package:inspire_blur/src/distribution/blur_distribution_map.dart';

class UniformDistributionMap extends IntensityBasedDistributionMap {
  const UniformDistributionMap({
    required super.width,
    required super.height,
  });

  @override
  double intensityAt(double u, double v) => 1.0;
}
