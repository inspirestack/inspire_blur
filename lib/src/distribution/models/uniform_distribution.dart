part of 'package:inspire_blur/src/distribution/blur_distribution.dart';

/// A blur distribution with uniform intensity over the entire area.
///
/// Every point receives the maximum blur strength.
class UniformDistribution extends BlurDistribution {
  @override
  UniformDistribution copyWith() => UniformDistribution();
}
