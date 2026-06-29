part of 'package:inspire_blur/src/distribution/blur_distribution.dart';

/// A rounded rectangle blur distribution.
///
/// Blur intensity across the area is controlled by the gradient
/// progression control points defined by [values] and [stops].
final class RRectDistribution extends GradientDistribution {
  /// The normalized distance from the left and right edges to the start
  /// of the blur region.
  ///
  /// Normalized to the range `[0.0, 0.5)`. Values greater than or equal
  /// to `0.5` will collapse the area.
  final double horizontalInset;

  /// The normalized distance from the top and bottom edges to the start
  /// of the blur region.
  ///
  /// Normalized to the range `[0.0, 0.5)`. Values greater than or equal
  /// to `0.5` will collapse the area.
  final double verticalInset;

  /// The normalized corner radius of the shape.
  ///
  /// The value must be in the range `[0.0, 1.0]`.
  ///
  /// A value of `0.0` produces a rectangle, while `1.0` produces the
  /// maximum corner rounding for the given shape.
  final double cornerRadius;

  /// Controls the blur direction:
  /// - `false`: blur starts inside the shape and fades outward.
  /// - `true`: blur starts outside the shape and fades toward the center,
  ///   creating a vignette-like effect.
  final bool inverse;

  /// Creates a rounded rectangle blur distribution configuration.
  ///
  /// The blur intensity is distributed according to the gradient
  /// defined by [values], and [stops].
  RRectDistribution({
    required super.values,
    required super.stops,
    required this.horizontalInset,
    required this.verticalInset,
    required this.cornerRadius,
    required this.inverse,
  }) : assert(
          cornerRadius >= 0.0 && cornerRadius <= 1.0,
          'cornerRadius must be in the range [0.0, 1.0]',
        );

  /// Returns a copy of this distribution with the provided properties updated.
  ///
  /// Any parameter left `null` retains its current value.
  @override
  RRectDistribution copyWith({
    double? horizontalInset,
    double? verticalInset,
    double? cornerRadius,
    bool? inverse,
    List<double>? values,
    List<double>? stops,
  }) {
    final newHorizontalInset = horizontalInset ?? this.horizontalInset;
    final newVerticalInset = verticalInset ?? this.verticalInset;
    final newCornerRadius = cornerRadius ?? this.cornerRadius;
    final newInverse = inverse ?? this.inverse;
    final newValues = values ?? this.values;
    final newStops = stops ?? this.stops;

    return RRectDistribution(
      horizontalInset: newHorizontalInset,
      verticalInset: newVerticalInset,
      cornerRadius: newCornerRadius,
      inverse: newInverse,
      values: newValues,
      stops: newStops,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RRectDistribution &&
        other.horizontalInset == horizontalInset &&
        other.verticalInset == verticalInset &&
        other.cornerRadius == cornerRadius &&
        other.inverse == inverse &&
        gradientDistributionEquals(other);
  }

  @override
  int get hashCode => Object.hash(
        horizontalInset,
        verticalInset,
        cornerRadius,
        inverse,
        gradientDistributionHashCode(),
      );
}
