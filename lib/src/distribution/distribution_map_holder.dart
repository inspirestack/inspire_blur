import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:inspire_blur/src/distribution/distribution.dart';
import 'package:inspire_blur/src/distribution/distribution_image.dart';
import 'package:inspire_blur/src/distribution/distribution_map.dart';
import 'package:inspire_blur/src/image/image_mask_generator.dart';

class DistributionMapHolder {
  final _image = ValueNotifier<DistributionImage?>(null);
  ValueListenable<DistributionImage?> get distributionImage => _image;

  late double _screenLongestSide;
  bool _hasScreenSize = false;

  int _generation = 0;
  int? _lastSize;

  bool _disposed = false;

  void didChangeDependencies({
    required BuildContext context,
    required Distribution? distribution,
  }) {
    final newSize = MediaQuery.sizeOf(context).longestSide;

    if (!_hasScreenSize || newSize != _screenLongestSide) {
      _screenLongestSide = newSize;
      _hasScreenSize = true;
      regenerateIfNeeded(distribution: distribution);
    }
  }

  void regenerateIfNeeded({
    required Distribution? distribution,
    bool invalidate = false,
  }) {
    final newSize = _getImageSize();

    if (invalidate || _lastSize != newSize) {
      _lastSize = newSize;

      _generateNewDistributionImage(
        distribution: distribution,
        size: newSize,
      );
    }
  }

  Future<void> _generateNewDistributionImage({
    required Distribution? distribution,
    required int size,
  }) async {
    final gen = ++_generation;

    final DistributionImage newDistributionImage;
    if (distribution != null) {
      final distributionMap = distribution.toDistributionMap(size: size);
      newDistributionImage = await distributionMap.getDistributionImage();
    } else {
      newDistributionImage = DistributionImage.owned(
        await EmptyImageMaskGenerator().generateImage(),
      );
    }

    if (_disposed || gen != _generation) {
      newDistributionImage.dispose();
      return;
    }

    _image.value?.dispose();
    _image.value = newDistributionImage;
  }

  void dispose() {
    _disposed = true;
    _image.value?.dispose();
  }

  int _getImageSize() => (_screenLongestSide * 0.25).round().clamp(16, 48);
}
