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

  @override
  DirectionalDistribution copyWith({
    Alignment? begin,
    Alignment? end,
    List<double>? values,
    List<double>? stops,
  }) {
    final newBegin = begin ?? this.begin;
    final newEnd = end ?? this.end;
    final newValues = values ?? this.values;
    final newStops = stops ?? this.stops;

    return DirectionalDistribution(
      begin: newBegin,
      end: newEnd,
      values: newValues,
      stops: newStops,
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
}
