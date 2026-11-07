import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:inspire_blur/src/color_adjustment/blur_color_adjustment.dart';
import 'package:inspire_blur/src/distribution/distribution_image.dart';
import 'package:inspire_blur/src/inspire_shaders.dart';
import 'package:inspire_blur/src/model/aspect_ratio_correction.dart';
import 'package:inspire_blur/src/opacity/widget_opacity.dart';
import 'package:inspire_blur/src/transform/blur_transform.dart';
import 'package:inspire_blur/src/utils/extensions/inspire_geometry_extensions.dart';
import 'package:inspire_blur/src/utils/inspire_shader_utils.dart';

class InspireChildBlurAnimatedSamplerPass extends StatefulWidget {
  final DistributionImage blurDistributionImage;
  final DistributionImage opacityDistributionImage;
  final BlurTransform transform;
  final WidgetOpacity widgetOpacity;
  final BlurColorAdjustment colorAdjustment;
  final AspectRatioCorrection aspectRatioCorrection;
  final Axis direction;
  final double sigma;
  final Widget child;

  const InspireChildBlurAnimatedSamplerPass({
    super.key,
    required this.blurDistributionImage,
    required this.opacityDistributionImage,
    required this.transform,
    required this.widgetOpacity,
    required this.colorAdjustment,
    required this.aspectRatioCorrection,
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
      final shader = program?.fragmentShader();
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
        final dpr = MediaQuery.devicePixelRatioOf(context);

        final normalizedOrigin = widget.transform.origin.toNormalizedOffset();

        shader
          ..setImageSampler(0, image)
          ..setImageSampler(
            1,
            widget.blurDistributionImage.image,
            filterQuality: kShaderMapSamplingQuality,
          )
          ..setImageSampler(
            2,
            widget.opacityDistributionImage.image,
            filterQuality: kShaderMapSamplingQuality,
          )
          ..setFloat(0, size.width)
          ..setFloat(1, size.height)
          // To ensure 1:1 effective blur strength with ImageFilter.shader
          // when using same sigma values — divide sigma by dpr.
          ..setFloat(2, widget.sigma / dpr)
          ..setFloat(3, widget.direction == Axis.horizontal ? 1.0 : 0.0)
          ..setFloat(4, widget.direction == Axis.vertical ? 1.0 : 0.0)
          ..setFloat(5, 0.0)
          ..setFloat(6, 0.0)
          ..setFloat(7, 0.0)
          ..setFloat(8, 0.0)
          ..setFloat(9, widget.transform.scale.scaleX)
          ..setFloat(10, widget.transform.scale.scaleY)
          ..setFloat(11, widget.transform.offset.dx)
          ..setFloat(12, widget.transform.offset.dy)
          ..setFloat(13, widget.transform.rotation)
          ..setFloat(14, normalizedOrigin.dx)
          ..setFloat(15, normalizedOrigin.dy)
          ..setFloat(16, widget.transform.inversionFactor)
          ..setFloat(17, widget.colorAdjustment.shaderBrightness)
          ..setFloat(18, widget.colorAdjustment.shaderContrast)
          ..setFloat(19, widget.colorAdjustment.shaderExposure)
          ..setFloat(20, widget.colorAdjustment.shaderSaturation)
          ..setFloat(21, widget.colorAdjustment.shaderVibrance)
          ..setFloat(22, widget.colorAdjustment.blurAdjustmentStrength)
          ..setFloat(23, widget.colorAdjustment.nonBlurAdjustmentStrength)
          ..setFloat(24, widget.widgetOpacity.shaderOpacityType)
          ..setFloat(25, widget.widgetOpacity.shaderOpacityValue)
          ..setFloat(26, widget.aspectRatioCorrection.shaderAspectRatio);
        final paint = Paint()..shader = shader;
        canvas.drawRect(Offset.zero & size, paint);
      },
      child: widget.child,
    );
  }
}
