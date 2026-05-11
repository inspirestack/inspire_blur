import 'package:flutter/material.dart';
import 'package:inspire_blur/inspire_blur.dart';
import 'package:inspire_blur_example/demo_images.dart';

class BackdropBlurDemo extends StatelessWidget {
  const BackdropBlurDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Stack that expands to the whole screen
    return Stack(
      fit: StackFit.expand,
      children: [
        // Content to be blurred
        Positioned.fill(child: _BackdropBlurDemoContent()),

        // Backdrop blur effect on top — it will blur the content behind it
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: 126,
          child: Inspire.backdropBlur(
            config: InspireBlurConfig.topToBottom(sigma: 34),
          ),
        ),
      ],
    );
  }
}

class _BackdropBlurDemoContent extends StatefulWidget {
  @override
  State<_BackdropBlurDemoContent> createState() =>
      _BackdropBlurDemoContentState();
}

class _BackdropBlurDemoContentState extends State<_BackdropBlurDemoContent> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final screenPadding = MediaQuery.paddingOf(context);
    final isLandscape = screenSize.width > screenSize.height;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
            horizontal: 34,
            vertical: isLandscape ? 55 : 89,
          ) +
          EdgeInsets.only(
            left: screenPadding.left,
            right: screenPadding.right,
            bottom: isLandscape ? 0 : screenSize.height * 0.618,
          ),
      child: Column(children: _buildImages()),
    );
  }

  List<Widget> _buildImages() => demoImages
      .map((demoImage) => _buildImage(imagePath: demoImage.$1))
      .toList();

  Widget _buildImage({required String imagePath}) {
    const double radius = 44;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 44),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.125),
              blurRadius: 44,
              offset: const Offset(5, 34),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Image.asset(imagePath),
        ),
      ),
    );
  }
}
