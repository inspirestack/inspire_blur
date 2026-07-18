import 'dart:ui';

import 'package:flutter/foundation.dart';

class InspireShaders {
  static const String _pkgName = 'inspire_blur';

  static Future<FragmentProgram?>? _childBlurFuture;

  /// Returns the child blur shader, or `null` if it cannot be loaded.
  static Future<FragmentProgram?> get childBlur =>
      _childBlurFuture ??= _loadShader(
        'shaders/inspire_blur_child.frag',
      );

  static Future<FragmentProgram?>? _backdropBlurFuture;

  /// Returns the backdrop blur shader, or `null` if it cannot be loaded.
  static Future<FragmentProgram?> get backdropBlur =>
      _backdropBlurFuture ??= _loadShader(
        'shaders/inspire_blur_backdrop.frag',
      );

  /// Tries to load asset from two different paths during:
  /// * Normal package use.
  /// * Running tests inside this package.
  static Future<FragmentProgram?> _loadShader(String path) async {
    return await _tryLoad('packages/$_pkgName/$path') ?? await _tryLoad(path);
  }

  static Future<FragmentProgram?> _tryLoad(String path) async {
    try {
      return await FragmentProgram.fromAsset(path);
    } catch (_) {
      return null;
    }
  }

  @visibleForTesting
  static void reset() {
    _childBlurFuture = null;
    _backdropBlurFuture = null;
  }
}
