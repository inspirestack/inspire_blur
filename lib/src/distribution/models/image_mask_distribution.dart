part of 'package:inspire_blur/src/distribution/blur_distribution.dart';

/// An image mask blur distribution.
///
/// Blur intensity on each point of the area is controlled by the
/// corresponding point on the [maskImage].
class ImageMaskDistribution extends BlurDistribution {
  /// Mask image that controls the blur intensity over the blur area.
  ///
  /// The intensity of the blur effect is controlled by the red channel,
  /// whereas other channels, including alpha, are ignored.
  /// Using a fully opaque, grayscale image is thus recommended.
  ///
  /// The image is sampled in UV space, i.e. normalized to 2D space of
  /// `(0.0, 0.0) - (1.0, 1.0)`.
  ///
  /// Each point of the blur area is transformed to uv coordinates,
  /// and corresponding uv coordinate is used to sample the intensity from
  /// the image.
  final ui.Image maskImage;

  /// Creates a blur distribution with an image mask.
  ///
  /// The blur intensity is distributed according to the intensity
  /// of the pixels of the [maskImage].
  ///
  /// The image is not cloned internally.
  ///
  /// The caller retains ownership of [maskImage] and is responsible for
  /// disposing it after it is no longer used by the blur effect.
  ImageMaskDistribution({required this.maskImage});

  /// Returns a copy of this distribution with the new image.
  ///
  /// Any parameter left `null` retains its current value.
  @override
  ImageMaskDistribution copyWith({ui.Image? maskImage}) {
    return ImageMaskDistribution(maskImage: maskImage ?? this.maskImage);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ImageMaskDistribution && other.maskImage == maskImage;
  }

  @override
  int get hashCode => maskImage.hashCode;

  @override
  String toString() => 'ImageMaskDistribution(maskImage: $maskImage)';
}
