import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:inspire_blur/src/color_adjustment/blur_color_adjustment.dart';
import 'package:inspire_blur/src/inspire_shaders.dart';
import 'package:inspire_blur/src/transform/blur_transform.dart';
import 'package:inspire_blur/src/utils/extensions/inspire_double_extensions.dart';
import 'package:inspire_blur/src/utils/extensions/inspire_geometry_extensions.dart';

class InspireChildBlurImageFilterPass extends StatefulWidget {
  final ui.Image gradientMap;
  final BlurTransform transform;
  final BlurColorAdjustment colorAdjustment;
  final Axis direction;
  final double sigma;
  final Widget child;

  const InspireChildBlurImageFilterPass({
    super.key,
    required this.gradientMap,
    required this.transform,
    required this.colorAdjustment,
    required this.direction,
    required this.sigma,
    required this.child,
  });

  @override
  State<InspireChildBlurImageFilterPass> createState() =>
      _InspireChildBlurImageFilterPassState();
}

class _InspireChildBlurImageFilterPassState
    extends State<InspireChildBlurImageFilterPass> {
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
        setState(() {
          _shader = shader;
        });
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

    return _BlurFiltered(
      shader: shader,
      gradientMap: widget.gradientMap,
      transform: widget.transform,
      colorAdjustment: widget.colorAdjustment,
      direction: widget.direction,
      sigma: widget.sigma,
      child: widget.child,
    );
  }
}

class _BlurFiltered extends SingleChildRenderObjectWidget {
  final ui.FragmentShader shader;
  final ui.Image gradientMap;
  final BlurTransform transform;
  final BlurColorAdjustment colorAdjustment;
  final Axis direction;
  final double sigma;

  const _BlurFiltered({
    super.child,
    required this.shader,
    required this.gradientMap,
    required this.transform,
    required this.colorAdjustment,
    required this.direction,
    required this.sigma,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    final scrollPosition = Scrollable.maybeOf(context)?.position;
    final view = View.of(context);

    return _BlurFilterRenderObject(
      shader,
      gradientMap,
      transform,
      colorAdjustment,
      direction,
      sigma,
      scrollPosition,
      _getScreenSize(view),
      _getDpr(context),
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _BlurFilterRenderObject renderObject,
  ) {
    final scrollPosition = Scrollable.maybeOf(context)?.position;
    final view = View.of(context);

    renderObject
      ..shader = shader
      ..gradientMap = gradientMap
      ..transform = transform
      ..colorAdjustment = colorAdjustment
      ..direction = direction
      ..sigma = sigma
      ..scrollPosition = scrollPosition
      ..screenSize = _getScreenSize(view)
      ..dpr = _getDpr(context);
  }

  Size _getScreenSize(ui.FlutterView view) =>
      view.physicalSize / view.devicePixelRatio;

  double _getDpr(BuildContext context) =>
      MediaQuery.of(context).devicePixelRatio;
}

class _BlurFilterRenderObject extends RenderProxyBox {
  ui.ImageFilter? _imageFilter;

  ui.FragmentShader _shader;
  set shader(ui.FragmentShader value) {
    if (identical(_shader, value)) return;
    _shader = value;
    _updateShader();
  }

  ui.Image _gradientMap;
  set gradientMap(ui.Image value) {
    if (_gradientMap == value) return;
    _gradientMap = value;
    _updateShader();
  }

  BlurTransform _transform;
  set transform(BlurTransform value) {
    if (_transform == value) return;
    _transform = value;
    _updateShader();
  }

  BlurColorAdjustment _colorAdjustment;
  set colorAdjustment(BlurColorAdjustment value) {
    if (_colorAdjustment == value) return;
    _colorAdjustment = value;
    _updateShader();
  }

  Axis _direction;
  set direction(Axis value) {
    if (_direction == value) return;
    _direction = value;
    _updateShader();
  }

  double _sigma;
  set sigma(double value) {
    if (_sigma == value) return;
    _sigma = value;
    _updateShader();
  }

  Size _screenSize;
  set screenSize(Size value) {
    if (_screenSize == value) return;
    _screenSize = value;
    markNeedsPaint();
  }

  double _dpr;
  set dpr(double value) {
    if (_dpr == value) return;
    _dpr = value;
    markNeedsPaint();
  }

  ScrollPosition? _scrollPosition;
  set scrollPosition(ScrollPosition? value) {
    if (_scrollPosition == value) return;
    _detachListener();
    _scrollPosition = value;
    _attachListener();
  }

  _BlurFilterRenderObject(
    this._shader,
    this._gradientMap,
    this._transform,
    this._colorAdjustment,
    this._direction,
    this._sigma,
    this._scrollPosition,
    this._screenSize,
    this._dpr,
  ) {
    _updateShader();
  }

  Rect? _lastPaintedBounds;
  bool? _wasFullyVisible;

  void _attachListener() {
    if (!attached) return;
    _scrollPosition?.addListener(_onPositionChanged);
  }

  void _detachListener() => _scrollPosition?.removeListener(_onPositionChanged);

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _attachListener();
  }

  @override
  void detach() {
    _detachListener();
    super.detach();
  }

  void _onPositionChanged() {
    if (!attached) return;

    final bounds = localToGlobal(Offset.zero) & size;
    final isFullyVisible = _isFullyVisible(bounds, _screenSize);

    if (!_shouldRepaint(bounds, isFullyVisible)) return;

    _wasFullyVisible = isFullyVisible;
    markNeedsPaint();
  }

  bool _isFullyVisible(Rect bounds, Size screenSize) {
    return bounds.top >= 0 &&
        bounds.bottom <= screenSize.height &&
        bounds.left >= 0 &&
        bounds.right <= screenSize.width;
  }

  bool _shouldRepaint(Rect bounds, bool isFullyVisible) {
    // If widget is still fully visible, no repaint is needed.
    // Flutter will simply offset the existing layer (when in RepaintBoundary).
    if (isFullyVisible && _wasFullyVisible == true) {
      return false;
    }

    if (bounds == _lastPaintedBounds) {
      return false;
    }

    return true;
  }

  void _updateShader() {
    final normalizedOrigin = _transform.origin.toNormalizedOffset();

    _shader.setImageSampler(1, _gradientMap);
    _shader.setFloat(2, _sigma);
    _shader.setFloat(3, _direction == Axis.horizontal ? 1.0 : 0.0);
    _shader.setFloat(4, _direction == Axis.vertical ? 1.0 : 0.0);
    _shader.setFloat(9, _transform.scale.scaleX);
    _shader.setFloat(10, _transform.scale.scaleY);
    _shader.setFloat(11, _transform.offset.dx);
    _shader.setFloat(12, _transform.offset.dy);
    _shader.setFloat(13, _transform.rotation);
    _shader.setFloat(14, normalizedOrigin.dx);
    _shader.setFloat(15, normalizedOrigin.dy);
    _shader.setFloat(16, _transform.inversionFactor);
    _shader.setFloat(17, _colorAdjustment.shaderBrightness);
    _shader.setFloat(18, _colorAdjustment.shaderContrast);
    _shader.setFloat(19, _colorAdjustment.shaderExposure);
    _shader.setFloat(20, _colorAdjustment.shaderSaturation);
    _shader.setFloat(21, _colorAdjustment.shaderVibrance);
    _shader.setFloat(22, _colorAdjustment.blurAdjustmentStrength);
    _shader.setFloat(23, _colorAdjustment.nonBlurAdjustmentStrength);

    _recreateImageFilter();
    markNeedsPaint();
  }

  void _recreateImageFilter() {
    _imageFilter = ui.ImageFilter.shader(_shader);
  }

  @override
  void paint(PaintingContext context, ui.Offset offset) {
    final childValue = child;
    if (childValue == null) return;

    final newBounds = localToGlobal(Offset.zero) & size;

    if (_lastPaintedBounds?.isNotClose(newBounds) ?? true) {
      _lastPaintedBounds = newBounds;

      final screenWidth = _screenSize.width;
      final screenHeight = _screenSize.height;

      final deltaLeft = newBounds.left.takeNegativeOrZero().abs();
      final deltaTop = newBounds.top.takeNegativeOrZero().abs();
      final deltaRight = (newBounds.right - screenWidth).takePositiveOrZero();
      final deltaBottom =
          (newBounds.bottom - screenHeight).takePositiveOrZero();

      _shader.setFloat(5, deltaLeft * _dpr);
      _shader.setFloat(6, deltaTop * _dpr);
      _shader.setFloat(7, deltaRight * _dpr);
      _shader.setFloat(8, deltaBottom * _dpr);

      _imageFilter = ui.ImageFilter.shader(_shader);
    }

    final ImageFilterLayer filterLayer = ImageFilterLayer(
      imageFilter: _imageFilter,
    );

    context.pushLayer(filterLayer,
        (PaintingContext childContext, Offset childOffset) {
      childContext.paintChild(childValue, childOffset);
    }, offset);
  }
}
