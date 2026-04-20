import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Defines how blur is applied, including strength and spatial distribution.
///
/// A blur can be:
/// - uniform (using [sigma])
/// - directional (using [sigmaX] and/or [sigmaY])
///
/// The blur intensity across the widget is controlled by a gradient defined
/// by [start], [end], [stops], and [values].
///
/// Use the provided factory constructors for common patterns.
class InspireBlurConfig {
  /// Blur strength applied in both directions.
  ///
  /// This produces a standard two-dimensional Gaussian blur.
  ///
  /// To control blur per axis, use [sigmaX] and/or [sigmaY] instead.
  ///
  /// Providing only one of [sigmaX] or [sigmaY] results in a
  /// one-directional blur.
  final double? sigma;

  /// Blur strength applied horizontally.
  ///
  /// Can be used independently or together with [sigmaY].
  final double? sigmaX;

  /// Blur strength applied vertically.
  ///
  /// Can be used independently or together with [sigmaX].
  final double? sigmaY;

  /// Start of the blur gradient.
  ///
  /// Defines where the gradient begins.
  final Alignment start;

  /// End of the blur gradient.
  ///
  /// Defines where the gradient ends.
  final Alignment end;

  /// Positions of blur gradient stops, in the range [0.0, 1.0].
  ///
  /// Must be sorted in ascending order and match the length of [values].
  final List<double> stops;

  /// Blur intensity at each stop, in the range [0.0, 1.0].
  /// - 0.0 → no blur
  /// - 1.0 → full blur (based on sigma)
  ///
  /// Example:
  /// - stops:    [0.0, 1.0]
  ///   values:   [1.0, 0.0] → blur fades out from start to end
  ///
  /// - stops:    [0.0, 0.5, 1.0]
  ///   values:   [0.0, 1.0, 0.0] → blur peaks in the middle
  final List<double> values;

  /// Returns effective horizontal blur strength.
  double? overallSigmaHorizontally() => sigma ?? sigmaX;

  /// Returns effective vertical blur strength.
  double? overallSigmaVertically() => sigma ?? sigmaY;

  /// Creates a blur configuration.
  ///
  /// Exactly one of the following must be provided:
  /// - [sigma]
  /// - at least one of [sigmaX] or [sigmaY]
  ///
  /// [sigmaX] and [sigmaY] can be different to generate different blur
  /// strength horizontally and vertically.
  ///
  /// The blur intensity is distributed according to the gradient
  /// defined by [start], [end], [stops], and [values].
  InspireBlurConfig({
    required this.start,
    required this.end,
    required this.stops,
    required this.values,
    this.sigma,
    this.sigmaX,
    this.sigmaY,
  }) {
    assertValid();
  }

  /// Progressive blur from top (full strength) to bottom (zero strength).
  ///
  /// [fadeCurve] defines how blur intensity transitions across the gradient.
  /// For example:
  /// - [Curves.easeIn] produces a smoother, more gradual fade than the
  ///   linear curve, especially with larger blur sigma.
  /// - [Curves.easeOut] concentrates most of the blur earlier,
  ///   creating a more abrupt fade near the end.
  ///
  ///
  /// [extent] defines how far the blur gradient extends from the
  /// starting point (0.0–1.0).
  factory InspireBlurConfig.topToBottom({
    double? sigma,
    double? sigmaX,
    double? sigmaY,
    Curve fadeCurve = Curves.easeIn,
    double extent = 1.0,
  }) {
    final points = _curveToStops(extent: extent, curve: fadeCurve);
    return InspireBlurConfig(
      sigma: sigma,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      start: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: points.map((e) => e.$1).toList(),
      values: points.map((e) => e.$2).toList(),
    );
  }

  /// Progressive blur from bottom (full strength) to top (zero strength).
  ///
  /// [fadeCurve] defines how blur intensity transitions across the gradient.
  /// For example:
  /// - [Curves.easeIn] produces a smoother, more gradual fade than the
  ///   linear curve, especially with larger blur sigma.
  /// - [Curves.easeOut] concentrates most of the blur earlier,
  ///   creating a more abrupt fade near the end.
  ///
  ///
  /// [extent] defines how far the blur gradient extends from the
  /// starting point (0.0–1.0).
  factory InspireBlurConfig.bottomToTop({
    double? sigma,
    double? sigmaX,
    double? sigmaY,
    Curve fadeCurve = Curves.easeIn,
    double extent = 1.0,
  }) {
    final points = _curveToStops(extent: extent, curve: fadeCurve);
    return InspireBlurConfig(
      sigma: sigma,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      start: Alignment.bottomCenter,
      end: Alignment.topCenter,
      stops: points.map((e) => e.$1).toList(),
      values: points.map((e) => e.$2).toList(),
    );
  }

  /// Progressive blur from left (full strength) to right (zero strength).
  ///
  /// [fadeCurve] defines how blur intensity transitions across the gradient.
  /// For example:
  /// - [Curves.easeIn] produces a smoother, more gradual fade than the
  ///   linear curve, especially with larger blur sigma.
  /// - [Curves.easeOut] concentrates most of the blur earlier,
  ///   creating a more abrupt fade near the end.
  ///
  ///
  /// [extent] defines how far the blur gradient extends from the
  /// starting point (0.0–1.0).
  factory InspireBlurConfig.leftToRight({
    double? sigma,
    double? sigmaX,
    double? sigmaY,
    Curve fadeCurve = Curves.easeIn,
    double extent = 1.0,
  }) {
    final points = _curveToStops(extent: extent, curve: fadeCurve);
    return InspireBlurConfig(
      sigma: sigma,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      start: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: points.map((e) => e.$1).toList(),
      values: points.map((e) => e.$2).toList(),
    );
  }

  /// Progressive blur from right (full strength) to left (zero strength).
  ///
  /// [fadeCurve] defines how blur intensity transitions across the gradient.
  /// For example:
  /// - [Curves.easeIn] produces a smoother, more gradual fade than the
  ///   linear curve, especially with larger blur sigma.
  /// - [Curves.easeOut] concentrates most of the blur earlier,
  ///   creating a more abrupt fade near the end.
  ///
  ///
  /// [extent] defines how far the blur gradient extends from the
  /// starting point (0.0–1.0).
  factory InspireBlurConfig.rightToLeft({
    double? sigma,
    double? sigmaX,
    double? sigmaY,
    Curve fadeCurve = Curves.easeIn,
    double extent = 1.0,
  }) {
    final points = _curveToStops(extent: extent, curve: fadeCurve);
    return InspireBlurConfig(
      sigma: sigma,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      start: Alignment.centerRight,
      end: Alignment.centerLeft,
      stops: points.map((e) => e.$1).toList(),
      values: points.map((e) => e.$2).toList(),
    );
  }

  /// Progressive blur from [start] to [end].
  ///
  /// [fadeCurve] defines how blur intensity transitions across the gradient.
  /// For example:
  /// - [Curves.easeIn] produces a smoother, more gradual fade than the
  ///   linear curve, especially with larger blur sigma.
  /// - [Curves.easeOut] concentrates most of the blur earlier,
  ///   creating a more abrupt fade near the end.
  ///
  ///
  /// [extent] defines how far the blur gradient extends from the
  /// starting point (0.0–1.0).
  factory InspireBlurConfig.directional({
    required Alignment start,
    required Alignment end,
    double? sigma,
    double? sigmaX,
    double? sigmaY,
    Curve fadeCurve = Curves.easeIn,
    double extent = 1.0,
  }) {
    final points = _curveToStops(extent: extent, curve: fadeCurve);
    return InspireBlurConfig(
      sigma: sigma,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      start: start,
      end: end,
      stops: points.map((e) => e.$1).toList(),
      values: points.map((e) => e.$2).toList(),
    );
  }

  /// Blur that has a constant strength across the whole widget area.
  factory InspireBlurConfig.uniform({
    double? sigma,
    double? sigmaX,
    double? sigmaY,
  }) {
    return InspireBlurConfig(
      sigma: sigma,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      start: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0, 1],
      values: [1, 1],
    );
  }

  static List<(double, double)> _curveToStops({
    required double extent,
    required Curve curve,
    int stopsCount = 10,
  }) {
    assert(
      extent >= 0.0 && extent <= 1.0,
      'Provide extent in range between 0.0 and 1.0',
    );

    assert(stopsCount >= 2, 'stopsCount must be >= 2');

    if (extent == 0.0) {
      return [(0.0, curve.transform(1.0)), (1.0, curve.transform(0.0))];
    }

    return List.generate(
      stopsCount,
      (i) {
        final t = i / (stopsCount - 1);
        final stop = t * extent;
        final value = curve.transform(1 - t).clamp(0.0, 1.0);
        return (stop, value);
      },
    );
  }

  InspireBlurConfig copyWith({
    double? sigma,
    double? sigmaX,
    double? sigmaY,
    Alignment? start,
    Alignment? end,
    List<double>? stops,
    List<double>? values,
  }) {
    final newSigma = sigma ?? this.sigma;
    final newSigmaX = sigmaX ?? this.sigmaX;
    final newSigmaY = sigmaY ?? this.sigmaY;
    final newStart = start ?? this.start;
    final newEnd = end ?? this.end;
    final newStops = stops?.toList() ?? this.stops.toList();
    final newValues = values?.toList() ?? this.values.toList();

    return InspireBlurConfig(
      sigma: newSigma,
      sigmaX: newSigmaX,
      sigmaY: newSigmaY,
      start: newStart,
      end: newEnd,
      stops: newStops,
      values: newValues,
    );
  }

  /// Returns a copy with blur applied only horizontally.
  InspireBlurConfig onlyHorizontal(double sigma) {
    return InspireBlurConfig(
      sigmaX: sigma,
      sigmaY: null,
      sigma: null,
      start: start,
      end: end,
      stops: stops.toList(),
      values: values.toList(),
    );
  }

  /// Returns a copy with blur applied only vertically.
  InspireBlurConfig onlyVertical(double sigma) {
    return InspireBlurConfig(
      sigmaX: null,
      sigmaY: sigma,
      sigma: null,
      start: start,
      end: end,
      stops: stops.toList(),
      values: values.toList(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InspireBlurConfig &&
        other.sigma == sigma &&
        other.sigmaX == sigmaX &&
        other.sigmaY == sigmaY &&
        other.start == start &&
        other.end == end &&
        listEquals(other.stops, stops) &&
        listEquals(other.values, values);
  }

  @override
  int get hashCode => Object.hash(
        sigma,
        sigmaX,
        sigmaY,
        start,
        end,
        Object.hashAll(stops),
        Object.hashAll(values),
      );
}

extension ConfigAssertExtension on InspireBlurConfig {
  void assertValid() {
    final s = sigma;
    final sx = sigmaX;
    final sy = sigmaY;

    assert(
      (s != null) ^ (sx != null || sy != null),
      'Provide either sigma OR at least one of sigmaX / sigmaY',
    );

    if (s != null) {
      assert(s >= 0.0, 'Provide non-negative sigma');
    }

    if (sx != null) {
      assert(sx >= 0.0, 'Provide non-negative sigmaX');
    }

    if (sy != null) {
      assert(sy >= 0.0, 'Provide non-negative sigmaY');
    }

    assert(
      start != end,
      'Provide different start and end',
    );

    assert(
      stops.length >= 2,
      'Provide at least two blur stops',
    );

    assert(
      values.length >= 2,
      'Provide at least two blur values',
    );

    assert(
      stops.length == values.length,
      'Provide same number of stops and values',
    );

    for (int i = 1; i < stops.length; i++) {
      assert(
        stops[i] > stops[i - 1],
        'Provide stops in increasing order',
      );
    }

    for (final stop in stops) {
      assert(
        stop >= 0.0 && stop <= 1.0,
        'Provide all stops in range between 0.0 and 1.0',
      );
    }

    for (final value in values) {
      assert(
        value >= 0.0 && value <= 1.0,
        'Provide all values in range between 0.0 and 1.0',
      );
    }
  }
}
