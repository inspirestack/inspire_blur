part of 'package:inspire_blur/src/distribution/blur_distribution.dart';

/// Defines the shared semantics for a gradient-based blur distribution.
///
/// The blur intensity across the area is controlled by a gradient defined
/// by starting and ending point (however the subclass defines it), as well as
/// [values] and [stops] which define the blur strength progression.
sealed class GradientDistribution extends BlurDistribution {
  /// The blur intensity at each stop, from 0.0 to 1.0.
  ///
  /// Each value defines the fraction of the maximum blur strength
  /// (defined by `sigma`) applied at the corresponding control point
  /// from [stops].
  ///
  /// * 0.0: Effective sigma is zero, which results in no blur effect.
  /// * 1.0: Sigma reaches maximum, which produces full blur strength.
  ///
  /// The values must be in the range `[0.0, 1.0]`.
  ///
  /// ### Examples
  ///
  /// Fading out from begin to end:
  /// ```dart
  /// values: const <double>[1.0, 0.0],
  /// stops:  const <double>[0.0, 1.0],
  /// ```
  ///
  /// Peaking in the middle of the gradient:
  /// ```dart
  /// values: const <double>[0.0, 1.0, 0.0],
  /// stops:  const <double>[0.0, 0.5, 1.0],
  /// ```
  final List<double> values;

  /// Positions of the blur strength control points.
  ///
  /// Normalized to the range `[0.0, 1.0]`. Values outside this range are
  /// allowed.
  ///
  /// Must be sorted in non-decreasing order and match the length of [values].
  final List<double> stops;

  /// Constructs the base blur gradient distribution with [values] and [stops].
  GradientDistribution({
    required List<double> values,
    required List<double> stops,
  })  : values = List.unmodifiable(values),
        stops = List.unmodifiable(stops) {
    assert(
      values.length >= 2,
      'Provide at least two gradient values',
    );

    assert(
      stops.length >= 2,
      'Provide at least two gradient stops',
    );

    assert(
      values.length == stops.length,
      'Provide same number of values and stops',
    );

    for (final value in values) {
      assert(
        value >= 0.0 && value <= 1.0,
        'Provide all values in the range [0.0, 1.0]',
      );
    }

    for (int i = 1; i < stops.length; i++) {
      assert(
        stops[i] >= stops[i - 1],
        'Provide stops in non-decreasing order',
      );
    }
  }

  @protected
  bool gradientDistributionEquals(GradientDistribution other) {
    return listEquals(values, other.values) && listEquals(stops, other.stops);
  }

  @protected
  int gradientDistributionHashCode() {
    return Object.hash(
      Object.hashAll(values),
      Object.hashAll(stops),
    );
  }
}
