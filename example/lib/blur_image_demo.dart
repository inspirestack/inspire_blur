import 'package:flutter/material.dart';
import 'package:inspire_blur/inspire_blur.dart';

class BlurImageDemo extends StatefulWidget {
  const BlurImageDemo({super.key});

  @override
  State<BlurImageDemo> createState() => _BlurImageDemoState();
}

class _BlurImageDemoState extends State<BlurImageDemo> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final screenPadding = MediaQuery.paddingOf(context);
    final isLandscape = screenSize.width > screenSize.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: _buildImagesList(
              context,
              screenSize: screenSize,
              screenPadding: screenPadding,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: isLandscape ? 150 : 130,
            child: Inspire.backdropBlur(
              config: InspireBlurConfig.topToBottom(sigma: 21),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesList(
    BuildContext context, {
    required Size screenSize,
    required EdgeInsets screenPadding,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
            horizontal: 34,
            vertical: 89,
          ) +
          EdgeInsets.only(
            left: screenPadding.left,
            right: screenPadding.right,
            bottom: screenSize.height * 0.5,
          ),
      child: Column(children: _buildImages()),
    );
  }

  static const List<String> _demoImages = [
    'assets/images/P1070042.jpg',
    'assets/images/P1011704.jpg',
    'assets/images/P1000995.jpg',
    'assets/images/P1001304.jpg',
  ];

  List<Widget> _buildImages() =>
      _demoImages.map((image) => _buildImage(path: image)).toList();

  Widget _buildImage({required String path}) {
    const double radius = 44;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 44),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.125),
              blurRadius: radius,
              offset: const Offset(5, 34),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Image.asset(path),
        ),
      ),
    );
  }
}
