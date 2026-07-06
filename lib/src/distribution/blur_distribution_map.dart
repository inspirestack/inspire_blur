import 'dart:typed_data' show Uint8List;
import 'dart:ui' as ui;

import 'package:inspire_blur/src/distribution/blur_distribution.dart';
import 'package:inspire_blur/src/distribution/blur_distribution_image.dart';
import 'package:inspire_blur/src/distribution/maps/directional_distribution_map.dart';
import 'package:inspire_blur/src/distribution/maps/ellipse_distribution_map.dart';
import 'package:inspire_blur/src/distribution/maps/image_mask_distribution_map.dart';
import 'package:inspire_blur/src/distribution/maps/rrect_distribution_map.dart';
import 'package:inspire_blur/src/distribution/maps/uniform_distribution_map.dart';

abstract class BlurDistributionMap {
  const BlurDistributionMap({
    required this.width,
    required this.height,
  });

  final int width;
  final int height;

  Future<BlurDistributionImage> getBlurDistributionImage();
}

abstract class IntensityBasedDistributionMap extends BlurDistributionMap {
  const IntensityBasedDistributionMap({
    required super.width,
    required super.height,
  });

  @override
  Future<BlurDistributionImage> getBlurDistributionImage() async {
    final image = await _pixelsToImage(_generatePixels());
    return BlurDistributionImage.owned(image);
  }

  Uint8List _generatePixels() {
    const rgba8888BytesPerPixel = 4;

    final pixels = Uint8List(width * height * rgba8888BytesPerPixel);

    int offset = 0;

    final invWidth = width <= 1 ? 0.0 : 1.0 / (width - 1);
    final invHeight = height <= 1 ? 0.0 : 1.0 / (height - 1);

    for (int y = 0; y < height; y++) {
      final v = y * invHeight;

      for (int x = 0; x < width; x++) {
        final u = x * invWidth;

        final intensity = intensityAt(u, v);
        final color = (intensity.clamp(0.0, 1.0) * 255).round();

        pixels[offset++] = color;
        pixels[offset++] = color;
        pixels[offset++] = color;
        pixels[offset++] = 255;
      }
    }

    return pixels;
  }

  Future<ui.Image> _pixelsToImage(Uint8List pixels) async {
    final buffer = await ui.ImmutableBuffer.fromUint8List(pixels);

    final descriptor = ui.ImageDescriptor.raw(
      buffer,
      width: width,
      height: height,
      pixelFormat: ui.PixelFormat.rgba8888,
    );

    final codec = await descriptor.instantiateCodec();
    final frame = await codec.getNextFrame();

    return frame.image;
  }

  double intensityAt(double u, double v);
}

extension BlurDistributionExtension on BlurDistribution {
  BlurDistributionMap toDistributionMap({required int size}) => switch (this) {
        UniformDistribution _ => UniformDistributionMap(
            width: size,
            height: size,
          ),
        DirectionalDistribution e => DirectionalDistributionMap(
            width: size,
            height: size,
            begin: e.begin,
            end: e.end,
            values: e.values,
            stops: e.stops,
          ),
        EllipseDistribution e => EllipseDistributionMap(
            width: size,
            height: size,
            radiusX: e.radiusX,
            radiusY: e.radiusY,
            center: e.center,
            values: e.values,
            stops: e.stops,
          ),
        RRectDistribution e => RRectDistributionMap(
            width: size,
            height: size,
            horizontalInset: e.horizontalInset,
            verticalInset: e.verticalInset,
            cornerRadius: e.cornerRadius,
            values: e.values,
            stops: e.stops,
          ),
        ImageMaskDistribution e => ImageMaskDistributionMap(
            width: e.maskImage.width,
            height: e.maskImage.height,
            maskImage: e.maskImage,
          ),
      };
}
