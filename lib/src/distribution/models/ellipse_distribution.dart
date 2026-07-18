part of 'package:inspire_blur/src/distribution/blur_distribution.dart';

/// Defines an ellipse distribution starting from [center] and progressing
/// up to the ending point defined by [radiusX] and [radiusY] distance.
///
/// Blur intensity across the area is controlled by the gradient
/// progression control points defined by [values] and [stops].
class EllipseDistribution extends GradientDistribution {
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

  /// Center of the ellipse blur shape.
  final Alignment center;

  /// Creates an elliptical blur distribution.
  ///
  /// The blur intensity is distributed according to the gradient defined by
  /// [radiusX], [radiusY], [center], [values], and [stops].
  EllipseDistribution({
    required super.values,
    required super.stops,
    required this.radiusX,
    required this.radiusY,
    required this.center,
  })  : assert(
          radiusX >= 0.0,
          'radiusX must be greater than or equal to 0.0',
        ),
        assert(
          radiusY >= 0.0,
          'radiusY must be greater than or equal to 0.0',
        );

  /// Returns a copy of this distribution with the provided properties updated.
  ///
  /// Any parameter left `null` retains its current value.
  @override
  EllipseDistribution copyWith({
    double? radiusX,
    double? radiusY,
    Alignment? center,
    List<double>? values,
    List<double>? stops,
  }) {
    return EllipseDistribution(
      radiusX: radiusX ?? this.radiusX,
      radiusY: radiusY ?? this.radiusY,
      center: center ?? this.center,
      values: values ?? this.values,
      stops: stops ?? this.stops,
    );
  }

  /// Linearly interpolates between two [EllipseDistribution] objects.
  ///
  /// Enables seamless transitions inside implicit animations or tweens.
  static EllipseDistribution? lerp(
    EllipseDistribution? a,
    EllipseDistribution? b,
    double t,
  ) {
    if (identical(a, b)) return a;
    if (a == null) return b;
    if (b == null) return a;

    return EllipseDistribution(
      radiusX: lerpDouble(a.radiusX, b.radiusX, t)!,
      radiusY: lerpDouble(a.radiusY, b.radiusY, t)!,
      center: Alignment.lerp(a.center, b.center, t)!,
      values: lerpDoubleList(a.values, b.values, t),
      stops: lerpDoubleList(a.stops, b.stops, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EllipseDistribution &&
        other.radiusX == radiusX &&
        other.radiusY == radiusY &&
        other.center == center &&
        gradientDistributionEquals(other);
  }

  @override
  int get hashCode => Object.hash(
        radiusX,
        radiusY,
        center,
        gradientDistributionHashCode(),
      );

  @override
  String toString() => 'EllipseDistribution('
      'radiusX: $radiusX, '
      'radiusY: $radiusY, '
      'center: $center, '
      'values: [List of ${values.length} items], '
      'stops: [List of ${stops.length} items]'
      ')';
}
