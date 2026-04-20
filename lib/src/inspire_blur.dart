import 'package:flutter/material.dart';
import 'package:inspire_blur/inspire_blur.dart';
import 'package:inspire_blur/src/inspire_shaders.dart';

class Inspire {
  const Inspire._();

  /// Preloads shaders used by Inspire.
  ///
  /// This can help avoid a minor frame drop the first time a blur is rendered,
  /// especially on lower-end devices.
  ///
  /// Calling this is **optional** — shaders are loaded lazily on first use
  /// anyway, and in most cases this works perfectly fine.
  ///
  /// Consider using this if you want to ensure perfectly smooth first-time
  /// rendering (e.g. for animations or transitions).
  ///
  /// If used, call this early in your app lifecycle, for example:
  /// - in `main()` before `runApp()`
  /// - in a splash screen or initial loading phase
  ///
  /// This is most useful when blur is used in animations or
  /// immediately visible UI.
  static Future<void> warmUp() async {
    try {
      await InspireShaders.backdropBlur;
      await InspireShaders.childBlur;
    } catch (_) {
      // Ignore missing assets in tests / unsupported platforms
    }
  }

  /// Blurs content behind this widget (scene-level blur).
  ///
  /// This is typically used for overlays, glass effects, or backgrounds.
  ///
  /// The [child] is drawn on top of the blurred background.
  ///
  /// It works in a similar way as the [BackdropFilter].
  static Widget backdropBlur({
    required InspireBlurConfig config,
    Clip clipBehavior = Clip.antiAlias,
    bool useRepaintBoundary = true,
    Widget? child,
  }) {
    return InspireBackdropBlur(
      config: config,
      clipBehavior: clipBehavior,
      useRepaintBoundary: useRepaintBoundary,
      child: child,
    );
  }

  /// Blurs only the given [child] (local blur).
  ///
  /// This is useful for blurring specific UI elements such as cards,
  /// images, or components without affecting the background.
  static Widget childBlur({
    required InspireBlurConfig config,
    required Widget child,
    InspireBlurMode mode = InspireBlurMode.auto,
    Clip clipBehavior = Clip.antiAlias,
    bool useRepaintBoundary = true,
  }) {
    return InspireChildBlur(
      config: config,
      mode: mode,
      clipBehavior: clipBehavior,
      useRepaintBoundary: useRepaintBoundary,
      child: child,
    );
  }
}
