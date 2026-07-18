import 'dart:ui' as ui show Image;

import 'package:flutter/widgets.dart';
import 'package:inspire_blur/src/color_adjustment/blur_color_adjustment.dart';
import 'package:inspire_blur/src/distribution/blur_distribution.dart';
import 'package:inspire_blur/src/transform/blur_transform.dart';
import 'package:inspire_blur/src/utils/inspire_stops_generator.dart';

/// Defines how blur is applied, including strength and spatial [distribution].
///
/// Allows for custom [transform] of the spatial distribution and
/// [colorAdjustment] of the blur effect.
///
/// Blur strength can be:
/// * **Uniform:** using [sigma]
/// * **Independent per-axis:** using [sigmaX] and/or [sigmaY]
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

  /// Returns the effective horizontal blur strength specified
  /// by [sigma] or [sigmaX].
  double? get effectiveSigmaX => sigma ?? sigmaX;

  /// Returns the effective vertical blur strength specified
  /// by [sigma] or [sigmaY].
  double? get effectiveSigmaY => sigma ?? sigmaY;

  /// Spatial distribution of the blur effect.
  final BlurDistribution distribution;

  /// Transformation of the blur effect distribution.
  final BlurTransform transform;

  /// Color adjustment of the blur effect.
  final BlurColorAdjustment colorAdjustment;

  /// Creates a blur configuration.
  ///
  /// To define blur strength, provide one of the following combinations:
  /// * [sigma]
  /// * at least one of [sigmaX], [sigmaY]
  ///
  /// [sigmaX] and [sigmaY] can have different values to generate different
  /// blur strengths on the horizontal and vertical axes.
  ///
  /// Providing [sigma] together with [sigmaX] or [sigmaY] will throw an
  /// assertion error.
  const InspireBlurConfig({
    required this.distribution,
    this.transform = BlurTransform.identity,
    this.colorAdjustment = const BlurColorAdjustment(),
    this.sigma,
    this.sigmaX,
    this.sigmaY,
  })  : assert(
          (sigma != null) ^ (sigmaX != null || sigmaY != null),
          'Provide either sigma OR at least one of sigmaX / sigmaY',
        ),
        assert(
          sigma != null ? sigma >= 0.0 : true,
          'Provide non-negative sigma',
        ),
        assert(
          sigmaX != null ? sigmaX >= 0.0 : true,
          'Provide non-negative sigmaX',
        ),
        assert(
          sigmaY != null ? sigmaY >= 0.0 : true,
          'Provide non-negative sigmaY',
        );

  /// Progressive blur fading from top to bottom.
  ///
  /// {@template inspire_blur_config.gradient_extent}
  /// [extent] defines how far the blur gradient extends from the
  /// starting point.
  ///
  /// Typical values are in the range `[0.0, 1.0]`, although larger values
  /// are also supported.
  /// {@endtemplate}
  ///
  /// {@template inspire_blur_config.gradient_curves}
  /// [fadeCurve] defines how blur intensity transitions across the gradient.
  ///
  /// For example:
  /// * [Curves.easeIn] produces a smoother, more gradual fade than
  ///   [Curves.linear], especially for large blur sigma values.
  /// * [Curves.easeOut] concentrates most of the blur near the beginning,
  ///   creating a more abrupt fade near the end.
  /// {@endtemplate}
  factory InspireBlurConfig.topToBottom({
    double? sigma,
    double? sigmaX,
    double? sigmaY,
    double extent = 1.0,
    Curve fadeCurve = Curves.easeInSine,
    BlurTransform transform = const BlurTransform(),
    BlurColorAdjustment colorAdjustment = const BlurColorAdjustment(),
  }) {
    return InspireBlurConfig.directional(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      sigma: sigma,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      extent: extent,
      fadeCurve: fadeCurve,
      transform: transform,
      colorAdjustment: colorAdjustment,
    );
  }

  /// Progressive blur fading from bottom to top.
  ///
  /// {@macro inspire_blur_config.gradient_extent}
  ///
  /// {@macro inspire_blur_config.gradient_curves}
  factory InspireBlurConfig.bottomToTop({
    double? sigma,
    double? sigmaX,
    double? sigmaY,
    double extent = 1.0,
    Curve fadeCurve = Curves.easeInSine,
    BlurTransform transform = const BlurTransform(),
    BlurColorAdjustment colorAdjustment = const BlurColorAdjustment(),
  }) {
    return InspireBlurConfig.directional(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      sigma: sigma,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      extent: extent,
      fadeCurve: fadeCurve,
      transform: transform,
      colorAdjustment: colorAdjustment,
    );
  }

  /// Progressive blur fading from left to right.
  ///
  /// {@macro inspire_blur_config.gradient_extent}
  ///
  /// {@macro inspire_blur_config.gradient_curves}
  factory InspireBlurConfig.leftToRight({
    double? sigma,
    double? sigmaX,
    double? sigmaY,
    double extent = 1.0,
    Curve fadeCurve = Curves.easeInSine,
    BlurTransform transform = const BlurTransform(),
    BlurColorAdjustment colorAdjustment = const BlurColorAdjustment(),
  }) {
    return InspireBlurConfig.directional(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      sigma: sigma,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      extent: extent,
      fadeCurve: fadeCurve,
      transform: transform,
      colorAdjustment: colorAdjustment,
    );
  }

  /// Progressive blur fading from right to left.
  ///
  /// {@macro inspire_blur_config.gradient_extent}
  ///
  /// {@macro inspire_blur_config.gradient_curves}
  factory InspireBlurConfig.rightToLeft({
    double? sigma,
    double? sigmaX,
    double? sigmaY,
    double extent = 1.0,
    Curve fadeCurve = Curves.easeInSine,
    BlurTransform transform = const BlurTransform(),
    BlurColorAdjustment colorAdjustment = const BlurColorAdjustment(),
  }) {
    return InspireBlurConfig.directional(
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      sigma: sigma,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      extent: extent,
      fadeCurve: fadeCurve,
      transform: transform,
      colorAdjustment: colorAdjustment,
    );
  }

  /// Progressive blur from [begin] to [end].
  ///
  /// {@macro inspire_blur_config.gradient_extent}
  ///
  /// {@macro inspire_blur_config.gradient_curves}
  factory InspireBlurConfig.directional({
    required Alignment begin,
    required Alignment end,
    double? sigma,
    double? sigmaX,
    double? sigmaY,
    double extent = 1.0,
    Curve fadeCurve = Curves.easeInSine,
    BlurTransform transform = const BlurTransform(),
    BlurColorAdjustment colorAdjustment = const BlurColorAdjustment(),
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
      transform: transform,
      colorAdjustment: colorAdjustment,
    );
  }

  /// Blur with an elliptical fade.
  ///
  /// [radiusX] and [radiusY] define the size of the elliptical blur region
  /// as a fraction of the area.
  ///
  /// Typical values are in the range `[0.0, 1.0]`, although values greater
  /// than `1.0` are also supported. This causes the ellipse to extend beyond
  /// the widget bounds, which can be useful for creating large vignette or
  /// spotlight effects.
  ///
  /// {@template inspire_blur_config.gradient_feather}
  /// [feather] is the width of the blur transition. A value of `0.0` creates
  /// a hard edge, while larger values create a softer and more gradual
  /// transition.
  /// {@endtemplate}
  ///
  /// [center] specifies the center point of the elliptical blur region.
  /// The default is [Alignment.center].
  ///
  /// {@macro inspire_blur_config.gradient_curves}
  factory InspireBlurConfig.ellipse({
    required double radiusX,
    required double radiusY,
    double? sigma,
    double? sigmaX,
    double? sigmaY,
    double feather = 1.0,
    Alignment center = Alignment.center,
    Curve fadeCurve = Curves.easeOutSine,
    BlurTransform transform = const BlurTransform(),
    BlurColorAdjustment colorAdjustment = const BlurColorAdjustment(),
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
        values: points.map((e) => e.$1).toList(),
        stops: points.map((e) => e.$2).toList(),
      ),
      transform: transform,
      colorAdjustment: colorAdjustment,
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
  /// {@macro inspire_blur_config.gradient_feather}
  ///
  /// [horizontalInset], [verticalInset], and [feather] are normalized
  /// to the range `[0.0, 1.0]`.
  ///
  /// {@macro inspire_blur_config.gradient_curves}
  factory InspireBlurConfig.rectangle({
    required double horizontalInset,
    required double verticalInset,
    required double feather,
    double? sigma,
    double? sigmaX,
    double? sigmaY,
    Curve fadeCurve = Curves.easeOutSine,
    BlurTransform transform = const BlurTransform(),
    BlurColorAdjustment colorAdjustment = const BlurColorAdjustment(),
  }) {
    return InspireBlurConfig.roundedRectangle(
      horizontalInset: horizontalInset,
      verticalInset: verticalInset,
      cornerRadius: 0.0,
      feather: feather,
      sigma: sigma,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      fadeCurve: fadeCurve,
      transform: transform,
      colorAdjustment: colorAdjustment,
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
  /// {@macro inspire_blur_config.gradient_feather}
  ///
  /// [horizontalInset], [verticalInset], [cornerRadius], and [feather]
  /// are normalized to the range `[0.0, 1.0]`.
  ///
  /// {@macro inspire_blur_config.gradient_curves}
  factory InspireBlurConfig.roundedRectangle({
    required double horizontalInset,
    required double verticalInset,
    required double cornerRadius,
    required double feather,
    double? sigma,
    double? sigmaX,
    double? sigmaY,
    Curve fadeCurve = Curves.easeOutSine,
    BlurTransform transform = const BlurTransform(),
    BlurColorAdjustment colorAdjustment = const BlurColorAdjustment(),
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
        values: points.map((e) => e.$1).toList(),
        stops: points.map((e) => e.$2).toList(),
      ),
      transform: transform,
      colorAdjustment: colorAdjustment,
    );
  }

  /// Blur with a fade controlled by a custom mask.
  ///
  /// [maskImage] controls the blur intensity over the blur area.
  ///
  /// The intensity of the blur effect is controlled by the red channel,
  /// whereas other channels, including alpha, are ignored.
  ///
  /// ### Recommendations
  ///
  /// * Use an image between 64×64 and 1024×1024 pixels.
  /// * Make image grayscale and fully opaque.
  /// * Match the image aspect ratio to the blurred widget bounds to prevent
  ///   distortion.
  ///
  /// Any image size and aspect ratio is supported. Note that larger images
  /// produce smoother fades but — as a trade-off — consume more GPU memory
  /// and may reduce performance.
  ///
  /// The caller retains ownership of [maskImage] and is responsible for
  /// disposing it after it is no longer used by the blur effect.
  ///
  /// ### Example
  ///
  /// ```dart
  /// ui.Image? maskImage;
  ///
  /// @override
  /// void initState() {
  ///   super.initState();
  ///   loadMaskImage(...).then((image) {
  ///     if (!mounted) {
  ///       image.dispose();
  ///       return;
  ///     }
  ///     setState(() => maskImage = image);
  ///   });
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   final image = maskImage;
  ///   if (image == null) return const SizedBox.shrink(); // Or a placeholder
  ///
  ///   return Inspire.childBlur(
  ///     config: InspireBlurConfig.customMask(maskImage: image),
  ///     child: ...,
  ///   );
  /// }
  ///
  /// @override
  /// void dispose() {
  ///   maskImage?.dispose();
  ///   super.dispose();
  /// }
  /// ```
  factory InspireBlurConfig.customMask({
    required ui.Image maskImage,
    double? sigma,
    double? sigmaX,
    double? sigmaY,
    BlurTransform transform = const BlurTransform(),
    BlurColorAdjustment colorAdjustment = const BlurColorAdjustment(),
  }) {
    assert(
      maskImage.width > 0 && maskImage.height > 0,
      'maskImage must have valid dimensions.',
    );

    return InspireBlurConfig(
      sigma: sigma,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      distribution: ImageMaskDistribution(
        maskImage: maskImage,
      ),
      transform: transform,
      colorAdjustment: colorAdjustment,
    );
  }

  /// Blur with a constant strength across the whole widget area.
  factory InspireBlurConfig.solid({
    double? sigma,
    double? sigmaX,
    double? sigmaY,
    BlurColorAdjustment colorAdjustment = const BlurColorAdjustment(),
  }) {
    return InspireBlurConfig(
      sigma: sigma,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      distribution: const UniformDistribution(),
      transform: BlurTransform.identity,
      colorAdjustment: colorAdjustment,
    );
  }

  /// Returns a copy of this config with the provided properties updated.
  ///
  /// Any parameter left `null` retains its current value.
  InspireBlurConfig copyWith({
    double? sigma,
    double? sigmaX,
    double? sigmaY,
    BlurDistribution? distribution,
    BlurTransform? transform,
    BlurColorAdjustment? colorAdjustment,
  }) {
    return InspireBlurConfig(
      sigma: sigma ?? this.sigma,
      sigmaX: sigmaX ?? this.sigmaX,
      sigmaY: sigmaY ?? this.sigmaY,
      distribution: distribution ?? this.distribution,
      transform: transform ?? this.transform,
      colorAdjustment: colorAdjustment ?? this.colorAdjustment,
    );
  }

  /// Returns a copy with blur applied only horizontally.
  InspireBlurConfig onlyHorizontal(double sigma) {
    return InspireBlurConfig(
      sigmaX: sigma,
      sigmaY: null,
      sigma: null,
      distribution: distribution,
      transform: transform,
      colorAdjustment: colorAdjustment,
    );
  }

  /// Returns a copy with blur applied only vertically.
  InspireBlurConfig onlyVertical(double sigma) {
    return InspireBlurConfig(
      sigmaX: null,
      sigmaY: sigma,
      sigma: null,
      distribution: distribution,
      transform: transform,
      colorAdjustment: colorAdjustment,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InspireBlurConfig &&
        other.sigma == sigma &&
        other.sigmaX == sigmaX &&
        other.sigmaY == sigmaY &&
        other.distribution == distribution &&
        other.transform == transform &&
        other.colorAdjustment == colorAdjustment;
  }

  @override
  int get hashCode => Object.hash(
        sigma,
        sigmaX,
        sigmaY,
        distribution,
        transform,
        colorAdjustment,
      );

  @override
  String toString() => 'InspireBlurConfig('
      'sigma: $sigma, '
      'sigmaX: $sigmaX, '
      'sigmaY: $sigmaY, '
      'distribution: $distribution, '
      'transform: $transform,'
      'colorAdjustment: $colorAdjustment'
      ')';
}
