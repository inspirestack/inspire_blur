import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:inspire_blur/src/inspire_shaders.dart';
import 'package:inspire_blur/src/utils/inspire_utils.dart';

class InspireChildBlurImageFilterPass extends StatefulWidget {
  final ui.Image gradientMap;
  final Axis direction;
  final double sigma;
  final Widget child;

  const InspireChildBlurImageFilterPass({
    super.key,
    required this.gradientMap,
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
      final shader = program.fragmentShader();
      if (mounted) {
        setState(() {
          _shader = shader;
          _updateShader();
        });
      } else {
        _shader = shader;
        _updateShader();
      }
    });
  }

  @override
  void didUpdateWidget(covariant InspireChildBlurImageFilterPass oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateShader();
  }

  void _updateShader() {
    _shader?.setImageSampler(1, widget.gradientMap);
    _shader?.setFloat(2, widget.sigma);
    _shader?.setFloat(3, widget.direction == Axis.horizontal ? 1.0 : 0.0);
    _shader?.setFloat(4, widget.direction == Axis.vertical ? 1.0 : 0.0);
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
      child: widget.child,
    );
  }
}

class _BlurFiltered extends SingleChildRenderObjectWidget {
  final ui.FragmentShader shader;

  const _BlurFiltered({
    super.child,
    required this.shader,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    final scrollPosition = Scrollable.maybeOf(context)?.position;
    final view = View.of(context);

    return _BlurFilterRenderObject(
      shader,
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
  final Paint _cachedPaint = Paint();

  ui.FragmentShader _shader;
  set shader(ui.FragmentShader value) {
    if (identical(_shader, value)) return;
    _shader = value;
    markNeedsPaint();
  }

  Size _screenSize;
  set screenSize(Size value) {
    if (_screenSize == value) return;
    _screenSize = value;
  }

  double _dpr;
  set dpr(double value) {
    if (_dpr == value) return;
    _dpr = value;
  }

  Rect? _lastPaintedBounds;
  bool? _wasFullyVisible;

  ScrollPosition? _scrollPosition;
  set scrollPosition(ScrollPosition? value) {
    if (_scrollPosition == value) return;
    _detachListener();
    _scrollPosition = value;
    _attachListener();
  }

  _BlurFilterRenderObject(
    this._shader,
    this._scrollPosition,
    this._screenSize,
    this._dpr,
  );

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

      _cachedPaint.imageFilter = ui.ImageFilter.shader(_shader);
    }

    final canvas = context.canvas;

    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    canvas.saveLayer(Offset.zero & size, _cachedPaint);
    context.paintChild(childValue, Offset.zero);

    canvas.restore();
    canvas.restore();
  }
}
