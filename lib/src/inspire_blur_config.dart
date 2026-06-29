import 'package:flutter/widgets.dart';
import 'package:inspire_blur/src/distribution/blur_distribution.dart';
import 'package:inspire_blur/src/utils/inspire_stops_generator.dart';

/// Defines how blur is applied, including strength and spatial [distribution].
///
/// Blur strength can be:
/// - **Uniform:** using [sigma]
/// - **Independent per-axis:** using [sigmaX] and/or [sigmaY]
///
/// For common patterns, use the factory constructors, such as
/// [InspireBlurConfig.topToBottom] or [InspireBlurConfig.directional].
class InspireBlurConfig {
  /// Blur strength applied uniformly in both directions.
  ///
  /// This produces a standard two-dimensional Gaussian blur.
  ///
  /// To control horizontal and vertical blur strength separately,
  /// use [sigmaX] and/or [sigmaY].
  final double? sigma;

  /// Blur strength applied horizontally.
  ///
  /// Can be used independently or together with [sigmaY].
  final double? sigmaX;

  /// Blur strength applied vertically.
  ///
  /// Can be used independently or together with [sigmaX].
  final double? sigmaY;

  /// Returns the effective horizontal blur strength.
  double? get effectiveSigmaX => sigma ?? sigmaX;

  /// Returns the effective vertical blur strength.
  double? get effectiveSigmaY => sigma ?? sigmaY;

  /// Spatial distribution of the blur effect.
  final BlurDistribution distribution;

  /// Creates a blur configuration.
  ///
  /// To define blur strength, provide one of the following combinations:
  /// - [sigma]
  /// - at least one of [sigmaX], [sigmaY]
  ///
  /// [sigmaX] and [sigmaY] can have different values to generate different
  /// blur strengths on the horizontal and vertical axes.
  ///
  /// Providing [sigma] together with [sigmaX] or [sigmaY] will throw an error.
  InspireBlurConfig({
    required this.distribution,
    this.sigma,
    this.sigmaX,
    this.sigmaY,
  }) {
    assertValid();
  }

  /// Progressive blur fading from top to bottom.
  ///
  /// [fadeCurve] defines how blur intensity transitions across the gradient.
  /// For example:
  /// * [Curves.easeInSine] produces a smoother, more gradual fade than
  ///   [Curves.linear], especially for large blur sigma values.
  /// * [Curves.easeOut] concentrates most of the blur near the beginning,
  ///   creating a more abrupt fade near the end.
  ///
  /// [extent] defines how far the blur gradient extends from the
  /// starting point.
  ///
  /// Typical values are in the range `[0.0, 1.0]`, although larger values
  /// are also supported.
  factory InspireBlurConfig.topToBottom({
    double? sigma,
    double? sigmaX,
    double? sigmaY,
    Curve fadeCurve = Curves.easeInSine,
    double extent = 1.0,
  }) {
    return InspireBlurConfig.directional(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      sigma: sigma,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      fadeCurve: fadeCurve,
      extent: extent,
    );
  }

  /// Progressive blur fading from bottom to top.
  ///
  /// [fadeCurve] defines how blur intensity transitions across the gradient.
  /// For example:
  /// * [Curves.easeInSine] produces a smoother, more gradual fade than
  ///   [Curves.linear], especially for large blur sigma values.
  /// * [Curves.easeOut] concentrates most of the blur near the beginning,
  ///   creating a more abrupt fade near the end.
  ///
  /// [extent] defines how far the blur gradient extends from the
  /// starting point.
  ///
  /// Typical values are in the range `[0.0, 1.0]`, although larger values
  /// are also supported.
  factory InspireBlurConfig.bottomToTop({
    double? sigma,
    double? sigmaX,
    double? sigmaY,
    Curve fadeCurve = Curves.easeInSine,
    double extent = 1.0,
  }) {
    return InspireBlurConfig.directional(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      sigma: sigma,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      fadeCurve: fadeCurve,
      extent: extent,
    );
  }

  /// Progressive blur fading from left to right.
  ///
  /// [fadeCurve] defines how blur intensity transitions across the gradient.
  /// For example:
  /// * [Curves.easeInSine] produces a smoother, more gradual fade than
  ///   [Curves.linear], especially for large blur sigma values.
  /// * [Curves.easeOut] concentrates most of the blur near the beginning,
  ///   creating a more abrupt fade near the end.
  ///
  /// [extent] defines how far the blur gradient extends from the
  /// starting point.
  ///
  /// Typical values are in the range `[0.0, 1.0]`, although larger values
  /// are also supported.
  factory InspireBlurConfig.leftToRight({
    double? sigma,
    double? sigmaX,
    double? sigmaY,
    Curve fadeCurve = Curves.easeInSine,
    double extent = 1.0,
  }) {
    return InspireBlurConfig.directional(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      sigma: sigma,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      fadeCurve: fadeCurve,
      extent: extent,
    );
  }

  /// Progressive blur fading from right to left.
  ///
  /// [fadeCurve] defines how blur intensity transitions across the gradient.
  /// For example:
  /// * [Curves.easeInSine] produces a smoother, more gradual fade than
  ///   [Curves.linear], especially for large blur sigma values.
  /// * [Curves.easeOut] concentrates most of the blur near the beginning,
  ///   creating a more abrupt fade near the end.
  ///
  /// [extent] defines how far the blur gradient extends from the
  /// starting point.
  ///
  /// Typical values are in the range `[0.0, 1.0]`, although larger values
  /// are also supported.
  factory InspireBlurConfig.rightToLeft({
    double? sigma,
    double? sigmaX,
    double? sigmaY,
    Curve fadeCurve = Curves.easeInSine,
    double extent = 1.0,
  }) {
    return InspireBlurConfig.directional(
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      sigma: sigma,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      fadeCurve: fadeCurve,
      extent: extent,
    );
  }

  /// Progressive blur from [begin] to [end].
  ///
  /// [fadeCurve] defines how blur intensity transitions across the gradient.
  /// For example:
  /// * [Curves.easeInSine] produces a smoother, more gradual fade than
  ///   [Curves.linear], especially for large blur sigma values.
  /// * [Curves.easeOut] concentrates most of the blur near the beginning,
  ///   creating a more abrupt fade near the end.
  ///
  /// [extent] defines how far the blur gradient extends from the
  /// starting point.
  ///
  /// Typical values are in the range `[0.0, 1.0]`, although larger values
  /// are also supported.
  factory InspireBlurConfig.directional({
    required Alignment begin,
    required Alignment end,
    double? sigma,
    double? sigmaX,
    double? sigmaY,
    Curve fadeCurve = Curves.easeInSine,
    double extent = 1.0,
  }) {
    assert(
      extent >= 0.0,
      'extent must be greater than or equal to 0.0',
    );

    final points = curveToValuesAndStops(endStop: extent, curve: fadeCurve);

    return InspireBlurConfig(
      sigma: sigma,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      distribution: DirectionalDistribution(
        begin: begin,
        end: end,
        values: points.map((e) => e.$1).toList(),
        stops: points.map((e) => e.$2).toList(),
      ),
    );
  }

  /// Blur with an elliptical fade.
  ///
  /// [radiusX] and [radiusY] define the size of the elliptical blur region
  /// as a fraction of the area.
  /// Typical values are in the range `[0.0, 1.0]`, although values greater
  /// than 1.0 are also supported. This causes the ellipse to extend beyond
  /// the widget bounds, which can be useful for creating large vignette or
  /// spotlight effects.
  ///
  /// [feather] is the width of the blur transition. A value of 0.0 creates
  /// a hard edge, while larger values create a softer and more gradual
  /// transition.
  ///
  /// [center] specifies the center point of the elliptical blur region.
  /// The default is [Alignment.center].
  ///
  /// Set [inverse] to `true` to invert the blur distribution, creating
  /// a vignette-like effect where the blur is strongest outside the ellipse
  /// and gradually fades toward its center.
  ///
  /// [fadeCurve] defines how blur intensity transitions across the gradient.
  /// For example:
  /// * [Curves.easeInSine] produces a smoother, more gradual fade than
  ///   [Curves.linear], especially for large blur sigma values.
  /// * [Curves.easeOut] concentrates most of the blur near the beginning,
  ///   creating a more abrupt fade near the end.
  factory InspireBlurConfig.ellipse({
    required double radiusX,
    required double radiusY,
    double? sigma,
    double? sigmaX,
    double? sigmaY,
    double feather = 1.0,
    bool inverse = false,
    Alignment center = Alignment.center,
    Curve fadeCurve = Curves.easeOutSine,
  }) {
    assert(
      feather >= 0.0 && feather <= 1.0,
      'feather must be in the range [0.0, 1.0]',
    );

    final points = curveToValuesAndStops(
      startStop: 1.0 - feather,
      endStop: 1.0,
      curve: fadeCurve,
    );

    return InspireBlurConfig(
      sigma: sigma,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      distribution: EllipseDistribution(
        radiusX: radiusX,
        radiusY: radiusY,
        center: center,
        inverse: inverse,
        values: points.map((e) => e.$1).toList(),
        stops: points.map((e) => e.$2).toList(),
      ),
    );
  }

  /// Blur with a rectangular fade.
  ///
  /// [horizontalInset] is the distance from the left and right edges of
  /// the widget to the rectangular blur region.
  ///
  /// [verticalInset] is the distance from the top and bottom edges of
  /// the widget to the rectangular blur region.
  ///
  /// [feather] is the width of the blur transition. A value of 0.0 creates
  /// a hard edge, while larger values create a softer and more gradual
  /// transition.
  ///
  /// [horizontalInset], [verticalInset], and [feather] are normalized
  /// to the range `[0.0, 1.0]`.
  ///
  /// Set [inverse] to `true` to invert the blur distribution, creating
  /// a vignette-like effect where the blur is strongest outside the rectangle
  /// and gradually fades toward its center.
  ///
  /// [fadeCurve] defines how blur intensity transitions across the gradient.
  /// For example:
  /// * [Curves.easeInSine] produces a smoother, more gradual fade than
  ///   [Curves.linear], especially for large blur sigma values.
  /// * [Curves.easeOut] concentrates most of the blur near the beginning,
  ///   creating a more abrupt fade near the end.
  factory InspireBlurConfig.rectangle({
    required double horizontalInset,
    required double verticalInset,
    required double feather,
    double? sigma,
    double? sigmaX,
    double? sigmaY,
    bool inverse = false,
    Curve fadeCurve = Curves.easeOutSine,
  }) {
    return InspireBlurConfig.roundedRectangle(
      horizontalInset: horizontalInset,
      verticalInset: verticalInset,
      cornerRadius: 0.0,
      feather: feather,
      sigma: sigma,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      inverse: inverse,
      fadeCurve: fadeCurve,
    );
  }

  /// Blur with a rounded rectangular fade.
  ///
  /// [horizontalInset] is the distance from the left and right edges of
  /// the widget to the rectangular blur region.
  ///
  /// [verticalInset] is the distance from the top and bottom edges of
  /// the widget to the rectangular blur region.
  ///
  /// [cornerRadius] is the radius of the rectangle corners.
  ///
  /// [feather] is the width of the blur transition. A value of 0.0 creates
  /// a hard edge, while larger values create a softer and more gradual
  /// transition.
  ///
  /// [horizontalInset], [verticalInset], [cornerRadius], and [feather]
  /// are normalized to the range `[0.0, 1.0]`.
  ///
  /// Set [inverse] to `true` to invert the blur distribution, creating
  /// a vignette-like effect where the blur is strongest outside the rectangle
  /// and gradually fades toward its center.
  ///
  /// [fadeCurve] defines how blur intensity transitions across the gradient.
  /// For example:
  /// * [Curves.easeInSine] produces a smoother, more gradual fade than
  ///   [Curves.linear], especially for large blur sigma values.
  /// * [Curves.easeOut] concentrates most of the blur near the beginning,
  ///   creating a more abrupt fade near the end.
  factory InspireBlurConfig.roundedRectangle({
    required double horizontalInset,
    required double verticalInset,
    required double cornerRadius,
    required double feather,
    double? sigma,
    double? sigmaX,
    double? sigmaY,
    bool inverse = false,
    Curve fadeCurve = Curves.easeOutSine,
  }) {
    assert(
      feather >= 0.0 && feather <= 1.0,
      'feather must be in the range [0.0, 1.0]',
    );

    final points = curveToValuesAndStops(
      startStop: 1.0 - feather,
      endStop: 1.0,
      curve: fadeCurve,
    );

    return InspireBlurConfig(
      sigma: sigma,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      distribution: RRectDistribution(
        horizontalInset: horizontalInset,
        verticalInset: verticalInset,
        cornerRadius: cornerRadius,
        inverse: inverse,
        values: points.map((e) => e.$1).toList(),
        stops: points.map((e) => e.$2).toList(),
      ),
    );
  }

  /// Blur with a constant strength across the whole widget area.
  factory InspireBlurConfig.solid({
    double? sigma,
    double? sigmaX,
    double? sigmaY,
  }) {
    return InspireBlurConfig(
      sigma: sigma,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      distribution: UniformDistribution(),
    );
  }

  InspireBlurConfig copyWith({
    double? sigma,
    double? sigmaX,
    double? sigmaY,
    BlurDistribution? distribution,
  }) {
    final newSigma = sigma ?? this.sigma;
    final newSigmaX = sigmaX ?? this.sigmaX;
    final newSigmaY = sigmaY ?? this.sigmaY;
    final newDistribution = distribution ?? this.distribution;

    return InspireBlurConfig(
      sigma: newSigma,
      sigmaX: newSigmaX,
      sigmaY: newSigmaY,
      distribution: newDistribution,
    );
  }

  /// Returns a copy with blur applied only horizontally.
  InspireBlurConfig onlyHorizontal(double sigma) {
    return InspireBlurConfig(
      sigmaX: sigma,
      sigmaY: null,
      sigma: null,
      distribution: distribution,
    );
  }

  /// Returns a copy with blur applied only vertically.
  InspireBlurConfig onlyVertical(double sigma) {
    return InspireBlurConfig(
      sigmaX: null,
      sigmaY: sigma,
      sigma: null,
      distribution: distribution,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InspireBlurConfig &&
        other.sigma == sigma &&
        other.sigmaX == sigmaX &&
        other.sigmaY == sigmaY &&
        other.distribution == distribution;
  }

  @override
  int get hashCode => Object.hash(
        sigma,
        sigmaX,
        sigmaY,
        distribution,
      );
}

extension InspireBlurConfigAssertions on InspireBlurConfig {
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
  }
}
