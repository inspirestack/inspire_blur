import 'dart:ui' as ui show Image;

import 'package:inspire_blur/src/distribution/blur_distribution_image.dart';
import 'package:inspire_blur/src/distribution/blur_distribution_map.dart';

class ImageMaskDistributionMap extends BlurDistributionMap {
  final ui.Image maskImage;

  ImageMaskDistributionMap({
    required super.width,
    required super.height,
    required this.maskImage,
  });

  @override
  Future<BlurDistributionImage> getBlurDistributionImage() async =>
      BlurDistributionImage.borrowed(maskImage);
}
