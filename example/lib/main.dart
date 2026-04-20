import 'package:flutter/material.dart';
import 'package:inspire_blur/inspire_blur.dart';
import 'package:inspire_blur_example/blur_image_demo.dart';
import 'package:inspire_blur_example/utils/demo_utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Inspire.warmUp();

  DemoUtils.initializeUi();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Inspire Blur Demo',
      home: BlurImageDemo(),
    );
  }
}
