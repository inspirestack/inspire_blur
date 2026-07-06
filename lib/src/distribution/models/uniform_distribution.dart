part of 'package:inspire_blur/src/distribution/blur_distribution.dart';

/// A blur distribution with uniform intensity over the entire area.
///
/// Every point receives the maximum blur strength.
class UniformDistribution extends BlurDistribution {
  /// Creates a uniform blur distribution.
  const UniformDistribution();

  /// Returns a copy of this distribution.
  @override
  UniformDistribution copyWith() => const UniformDistribution();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UniformDistribution;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'UniformDistribution';
}
