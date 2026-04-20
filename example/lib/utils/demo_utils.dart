import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DemoUtils {
  static void initializeUi() {
    _setEdgeToEdge();
    _setLightSystemUi();
  }

  static void _setEdgeToEdge() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  static void _setLightSystemUi() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        // Status bar
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemStatusBarContrastEnforced: false,

        // Nav bar
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarContrastEnforced: false,
      ),
    );
  }
}
