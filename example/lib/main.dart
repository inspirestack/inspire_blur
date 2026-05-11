import 'package:flutter/material.dart';
import 'package:inspire_blur/inspire_blur.dart';
import 'package:inspire_blur_example/demo_app.dart';
import 'package:inspire_blur_example/utils/example_app_utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Inspire.warmUp();
  ExampleAppUtils.initializeUi();

  runApp(const DemoApp());
}
