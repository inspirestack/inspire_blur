import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:inspire_blur/src/inspire_shaders.dart';

class InspireChildBlurAnimatedSamplerPass extends StatefulWidget {
  final ui.Image gradientMap;
  final Axis direction;
  final double sigma;
  final Widget child;

  const InspireChildBlurAnimatedSamplerPass({
    super.key,
    required this.gradientMap,
    required this.direction,
    required this.sigma,
    required this.child,
  });

  @override
  State<InspireChildBlurAnimatedSamplerPass> createState() =>
      _InspireChildBlurAnimatedSamplerPassState();
}

class _InspireChildBlurAnimatedSamplerPassState
    extends State<InspireChildBlurAnimatedSamplerPass> {
  ui.FragmentShader? _shader;

  @override
  void initState() {
    super.initState();
    _loadShader();
  }

  void _loadShader() {
    InspireShaders.childBlur.then((program) {
      final shader = program.fragmentShader();
      if (mounted) {
        setState(() => _shader = shader);
      } else {
        _shader = shader;
      }
    });
  }

  @override
  void dispose() {
    _shader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shader = _shader;
    if (shader == null) return widget.child;

    return AnimatedSampler(
      (image, size, canvas) {
        final dpr = MediaQuery.of(context).devicePixelRatio;

        shader
          ..setImageSampler(0, image)
          ..setImageSampler(1, widget.gradientMap)
          ..setFloat(0, size.width)
          ..setFloat(1, size.height)
          // Ensure 1:1 effective blur strength with ImageFilter.shader variant
          // when using same sigma values — divide sigma by dpr.
          ..setFloat(2, widget.sigma / dpr)
          ..setFloat(3, widget.direction == Axis.horizontal ? 1.0 : 0.0)
          ..setFloat(4, widget.direction == Axis.vertical ? 1.0 : 0.0)
          ..setFloat(5, 0.0)
          ..setFloat(6, 0.0)
          ..setFloat(7, 0.0)
          ..setFloat(8, 0.0);
        final paint = Paint()..shader = shader;
        canvas.drawRect(Offset.zero & size, paint);
      },
      child: widget.child,
    );
  }
}
