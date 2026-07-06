import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:inspire_blur/src/distribution/blur_distribution_image.dart';
import 'package:inspire_blur/src/distribution/blur_distribution_map.dart';
import 'package:inspire_blur/src/inspire_blur_config.dart';
import 'package:inspire_blur/src/utils/layout/inspire_bounds_observer.dart';

class InspireBlurWrapperData {
  final ui.Image? blurGradientMap;
  final Rect? globalBounds;

  const InspireBlurWrapperData({
    required this.blurGradientMap,
    required this.globalBounds,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InspireBlurWrapperData &&
        other.blurGradientMap == blurGradientMap &&
        other.globalBounds == globalBounds;
  }

  @override
  int get hashCode => Object.hash(blurGradientMap, globalBounds);

  @override
  String toString() => 'InspireBlurWrapperData('
      'blurGradientMap: $blurGradientMap, '
      'globalBounds: $globalBounds'
      ')';
}

typedef InspireBlurWrapperBuilder = Widget Function(
    BuildContext, InspireBlurWrapperData);

class InspireBlurWrapper extends StatefulWidget {
  final InspireBlurConfig config;
  final InspireBlurWrapperBuilder builder;

  const InspireBlurWrapper({
    super.key,
    required this.config,
    required this.builder,
  });

  @override
  State<InspireBlurWrapper> createState() => _InspireBlurWrapperState();
}

class _InspireBlurWrapperState extends State<InspireBlurWrapper> {
  late double _screenLongestSide;
  bool _hasScreenSize = false;

  BlurDistributionImage? _blurDistributionImage;
  int _blurGradientMapGeneration = 0;
  int? _blurGradientMapLastSize;

  bool _disposed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newSize = MediaQuery.of(context).size.longestSide;

    if (!_hasScreenSize || newSize != _screenLongestSide) {
      _screenLongestSide = newSize;
      _hasScreenSize = true;
      _regenerateBlurGradientMapIfNeeded();
    }
  }

  @override
  void didUpdateWidget(covariant InspireBlurWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.config.distribution != widget.config.distribution) {
      _regenerateBlurGradientMapIfNeeded(force: true);
    }
  }

  void _regenerateBlurGradientMapIfNeeded({bool force = false}) {
    final newSize = _getBlurGradientMaskSize();

    if (force || _blurGradientMapLastSize != newSize) {
      _blurGradientMapLastSize = newSize;
      _createNewBlurGradientMap(newSize);
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _blurDistributionImage?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InspireBoundsObserver(
      builder: (globalBounds) => widget.builder(
        context,
        InspireBlurWrapperData(
          blurGradientMap: _blurDistributionImage?.image,
          globalBounds: globalBounds,
        ),
      ),
    );
  }

  Future<void> _createNewBlurGradientMap(int size) async {
    final gen = ++_blurGradientMapGeneration;

    final distributionMap = widget.config.distribution.toDistributionMap(
      size: size,
    );

    final newBlurDistributionImage =
        await distributionMap.getBlurDistributionImage();

    if (_disposed || gen != _blurGradientMapGeneration) {
      newBlurDistributionImage.dispose();
      return;
    }

    _blurDistributionImage?.dispose();

    if (mounted) {
      setState(() => _blurDistributionImage = newBlurDistributionImage);
    } else {
      _blurDistributionImage = newBlurDistributionImage;
    }
  }

  int _getBlurGradientMaskSize() =>
      (_screenLongestSide * 0.75).round().clamp(256, 1024);
}
