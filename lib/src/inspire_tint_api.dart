import 'package:flutter/material.dart';
import 'package:inspire_blur/src/inspire_tint.dart';

/// API for the Inspire color tint widgets.
///
/// Contains convenience factories that cover all typical tint directions
/// as well as the custom [directional] tint builder.
class InspireTintApi {
  const InspireTintApi();

  /// Creates a tint that starts from [begin] and fades toward [end].
  ///
  /// [extent] controls how far the tint fades across the area.
  ///
  /// Typical values are in the range `[0.0, 1.0]`, although larger values
  /// are also supported.
  ///
  /// [curve] defines how the tint intensity transitions across the gradient.
  ///
  /// [Curves.easeOutCubic] is chosen as the default [curve], as in most cases
  /// it produces a visually smoother, more natural-looking fade than
  /// [Curves.linear].
  Widget directional({
    required Color color,
    required Alignment begin,
    required Alignment end,
    double opacity = 1.0,
    double extent = 1.0,
    Curve curve = Curves.easeOutCubic,
    Widget? child,
  }) {
    return InspireTint(
      color: color,
      opacity: opacity,
      extent: extent,
      begin: begin,
      end: end,
      curve: curve,
      child: child,
    );
  }

  /// Creates a tint that starts from the top and fades toward the bottom.
  ///
  /// [extent] controls how far the tint fades across the area.
  ///
  /// Typical values are in the range `[0.0, 1.0]`, although larger values
  /// are also supported.
  ///
  /// [curve] defines how the tint intensity transitions across the gradient.
  ///
  /// [Curves.easeOutCubic] is chosen as the default [curve], as in most cases
  /// it produces a visually smoother, more natural-looking fade than
  /// [Curves.linear].
  Widget topToBottom({
    required Color color,
    double opacity = 1.0,
    double extent = 1.0,
    Curve curve = Curves.easeOutCubic,
    Widget? child,
  }) {
    return directional(
      color: color,
      opacity: opacity,
      extent: extent,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      curve: curve,
      child: child,
    );
  }

  /// Creates a tint that starts from the bottom and fades toward the top.
  ///
  /// [extent] controls how far the tint fades across the area.
  ///
  /// Typical values are in the range `[0.0, 1.0]`, although larger values
  /// are also supported.
  ///
  /// [curve] defines how the tint intensity transitions across the gradient.
  ///
  /// [Curves.easeOutCubic] is chosen as the default [curve], as in most cases
  /// it produces a visually smoother, more natural-looking fade than
  /// [Curves.linear].
  Widget bottomToTop({
    required Color color,
    double opacity = 1.0,
    double extent = 1.0,
    Curve curve = Curves.easeOutCubic,
    Widget? child,
  }) {
    return directional(
      color: color,
      opacity: opacity,
      extent: extent,
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      curve: curve,
      child: child,
    );
  }

  /// Creates a tint that starts from the left and fades toward the right.
  ///
  /// [extent] controls how far the tint fades across the area.
  ///
  /// Typical values are in the range `[0.0, 1.0]`, although larger values
  /// are also supported.
  ///
  /// [curve] defines how the tint intensity transitions across the gradient.
  ///
  /// [Curves.easeOutCubic] is chosen as the default [curve], as in most cases
  /// it produces a visually smoother, more natural-looking fade than
  /// [Curves.linear].
  Widget leftToRight({
    required Color color,
    double opacity = 1.0,
    double extent = 1.0,
    Curve curve = Curves.easeOutCubic,
    Widget? child,
  }) {
    return directional(
      color: color,
      opacity: opacity,
      extent: extent,
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      curve: curve,
      child: child,
    );
  }

  /// Creates a tint that starts from the right and fades toward the left.
  ///
  /// [extent] controls how far the tint fades across the area.
  ///
  /// Typical values are in the range `[0.0, 1.0]`, although larger values
  /// are also supported.
  ///
  /// [curve] defines how the tint intensity transitions across the gradient.
  ///
  /// [Curves.easeOutCubic] is chosen as the default [curve], as in most cases
  /// it produces a visually smoother, more natural-looking fade than
  /// [Curves.linear].
  Widget rightToLeft({
    required Color color,
    double opacity = 1.0,
    double extent = 1.0,
    Curve curve = Curves.easeOutCubic,
    Widget? child,
  }) {
    return directional(
      color: color,
      opacity: opacity,
      extent: extent,
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      curve: curve,
      child: child,
    );
  }
}
