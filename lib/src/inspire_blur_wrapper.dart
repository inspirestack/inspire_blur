import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inspire_blur/src/inspire_blur_config.dart';
import 'package:inspire_blur/src/utils/inspire_bounds_observer.dart';

class InspireBlurWrapperData {
  final ui.Image? blurGradientMap;
  final Rect? globalBounds;

  InspireBlurWrapperData({
    required this.blurGradientMap,
    required this.globalBounds,
  });
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

  ui.Image? _blurGradientMap;
  int _blurGradientMapGeneration = 0;
  int? _blurGradientMapLastSize;

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

    final oldConfig = oldWidget.config;
    final config = widget.config;

    if (!listEquals(oldConfig.stops, config.stops) ||
        !listEquals(oldConfig.values, config.values) ||
        oldConfig.start != config.start ||
        oldConfig.end != config.end) {
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
    _blurGradientMap?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: InspireBoundsObserver(
        builder: (globalBounds) => widget.builder(
          context,
          InspireBlurWrapperData(
            blurGradientMap: _blurGradientMap,
            globalBounds: globalBounds,
          ),
        ),
      ),
    );
  }

  Future<void> _createNewBlurGradientMap(int size) async {
    final gen = ++_blurGradientMapGeneration;

    final newMap = await _createBlurGradient(size, size);

    if (gen != _blurGradientMapGeneration) {
      newMap.dispose();
      return;
    }

    _blurGradientMap?.dispose();

    if (mounted) {
      setState(() => _blurGradientMap = newMap);
    } else {
      _blurGradientMap = newMap;
    }
  }

  int _getBlurGradientMaskSize() =>
      (_screenLongestSide ~/ 2).toInt().clamp(64, 768);

  Future<ui.Image> _createBlurGradient(int width, int height) async {
    final config = widget.config;

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    final size = Size(width.toDouble(), height.toDouble());
    final rect = Offset.zero & size;

    final paint = Paint()
      ..shader = LinearGradient(
        colors: config.values
            .map((v) => Color.fromARGB(255, (v * 255).round(), 0, 0))
            .toList(),
        stops: config.stops,
        begin: config.start,
        end: config.end,
      ).createShader(rect);

    canvas.drawRect(rect, paint);

    final picture = recorder.endRecording();
    return picture.toImage(width, height);
  }
}
