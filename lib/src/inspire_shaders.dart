import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';

class InspireShaders {
  static const String _pkgName = 'inspire_blur';

  static bool _isTest() {
    // kDebugMode is always true during tests.
    if (!kDebugMode) return false;

    // Check if the current executable is the flutter_tester (used by testWidgets)
    // This is safe to call on Android/iOS/Desktop.
    return Platform.executable.contains('flutter_tester');
  }

  static String _resolvePath(String path) {
    if (_isTest()) {
      return path; // Local path for tests
    }
    return 'packages/$_pkgName/$path'; // Package path for app
  }

  @visibleForTesting
  static void reset() {
    _childBlurFuture = null;
    _backdropBlurFuture = null;
  }

  static Future<FragmentProgram>? _childBlurFuture;
  static Future<FragmentProgram> get childBlur =>
      _childBlurFuture ??= FragmentProgram.fromAsset(
        _resolvePath('shaders/inspire_blur_child.frag'),
      );

  static Future<FragmentProgram>? _backdropBlurFuture;
  static Future<FragmentProgram> get backdropBlur =>
      _backdropBlurFuture ??= FragmentProgram.fromAsset(
        _resolvePath('shaders/inspire_blur_backdrop.frag'),
      );
}
