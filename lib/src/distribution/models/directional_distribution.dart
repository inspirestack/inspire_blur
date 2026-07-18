part of 'package:inspire_blur/src/distribution/blur_distribution.dart';

/// Defines a directional blur distribution based on a linear gradient
/// between [begin] and [end].
///
/// Blur intensity across the area is controlled by the gradient
/// progression control points defined by [values] and [stops].
final class DirectionalDistribution extends GradientDistribution {
  /// Starting point of the gradient.
  ///
  /// Defines where the gradient begins.
  final Alignment begin;

  /// Ending point of the gradient.
  ///
  /// Defines where the gradient ends.
  final Alignment end;

  /// Creates a directional distribution.
  ///
  /// The blur intensity is distributed according to the gradient
  /// defined by [begin], [end], [values], and [stops].
  DirectionalDistribution({
    required super.values,
    required super.stops,
    required this.begin,
    required this.end,
  }) : assert(begin != end, 'Provide different begin and end');

  /// Returns a copy of this distribution with the provided properties updated.
  ///
  /// Any parameter left `null` retains its current value.
  @override
  DirectionalDistribution copyWith({
    Alignment? begin,
    Alignment? end,
    List<double>? values,
    List<double>? stops,
  }) {
    return DirectionalDistribution(
      begin: begin ?? this.begin,
      end: end ?? this.end,
      values: values ?? this.values,
      stops: stops ?? this.stops,
    );
  }

  /// Linearly interpolates between two [DirectionalDistribution] objects.
  ///
  /// Enables seamless transitions inside implicit animations or tweens.
  static DirectionalDistribution? lerp(
    DirectionalDistribution? a,
    DirectionalDistribution? b,
    double t,
  ) {
    if (identical(a, b)) return a;
    if (a == null) return b;
    if (b == null) return a;

    return DirectionalDistribution(
      begin: Alignment.lerp(a.begin, b.begin, t)!,
      end: Alignment.lerp(a.end, b.end, t)!,
      values: lerpDoubleList(a.values, b.values, t),
      stops: lerpDoubleList(a.stops, b.stops, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DirectionalDistribution &&
        other.begin == begin &&
        other.end == end &&
        gradientDistributionEquals(other);
  }

  @override
  int get hashCode => Object.hash(
        begin,
        end,
        gradientDistributionHashCode(),
      );

  @override
  String toString() => 'DirectionalDistribution('
      'begin: $begin, '
      'end: $end, '
      'values: [List of ${values.length} items], '
      'stops: [List of ${stops.length} items]'
      ')';
}
