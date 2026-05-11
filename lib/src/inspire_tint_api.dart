import 'package:flutter/material.dart';
import 'package:inspire_blur/src/inspire_tint.dart';

class InspireTintApi {
  const InspireTintApi();

  Widget directional({
    required Color color,
    required Alignment begin,
    required Alignment end,
    double opacity = 1.0,
    double extent = 1.0,
    Curve curve = Curves.linear,
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

  Widget topToBottom({
    required Color color,
    double opacity = 1.0,
    double extent = 1.0,
    Curve curve = Curves.linear,
    Widget? child,
  }) {
    return InspireTint(
      color: color,
      opacity: opacity,
      extent: extent,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      curve: curve,
      child: child,
    );
  }

  Widget bottomToTop({
    required Color color,
    double opacity = 1.0,
    double extent = 1.0,
    Curve curve = Curves.linear,
    Widget? child,
  }) {
    return InspireTint(
      color: color,
      opacity: opacity,
      extent: extent,
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      curve: curve,
      child: child,
    );
  }

  Widget leftToRight({
    required Color color,
    double opacity = 1.0,
    double extent = 1.0,
    Curve curve = Curves.linear,
    Widget? child,
  }) {
    return InspireTint(
      color: color,
      opacity: opacity,
      extent: extent,
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      curve: curve,
      child: child,
    );
  }

  Widget rightToLeft({
    required Color color,
    double opacity = 1.0,
    double extent = 1.0,
    Curve curve = Curves.linear,
    Widget? child,
  }) {
    return InspireTint(
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
