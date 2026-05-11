import 'package:flutter/material.dart';
import 'package:inspire_blur/inspire_blur.dart';
import 'package:inspire_blur_example/demo_images.dart';
import 'package:inspire_blur_example/utils/tap_clickable_container.dart';

class ChildBlurDemo extends StatefulWidget {
  const ChildBlurDemo({super.key});

  @override
  State<ChildBlurDemo> createState() => _ChildBlurDemoState();
}

class _ChildBlurDemoState extends State<ChildBlurDemo> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final screenPadding = MediaQuery.paddingOf(context);
    final isLandscape = screenSize.width > screenSize.height;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 21,
        mainAxisSpacing: 44,
        childAspectRatio: isLandscape ? 1.5 : 0.65,
      ),
      padding: EdgeInsets.only(
            left: 21,
            right: 21,
            top: isLandscape ? 44 : 112,
          ) +
          EdgeInsets.only(
            left: screenPadding.left,
            right: screenPadding.right,
            bottom: screenSize.height * 0.618,
          ),
      itemCount: demoImages.length,
      itemBuilder: (context, index) {
        final (imagePath, tintColor, title, subtitle) = demoImages[index];

        return _ChildBlurDemoCard(
          key: ValueKey(imagePath),
          imagePath: imagePath,
          tintColor: tintColor,
          title: title,
          subtitle: subtitle,
        );
      },
    );
  }
}

class _ChildBlurDemoCard extends StatelessWidget {
  const _ChildBlurDemoCard({
    super.key,
    required this.imagePath,
    required this.tintColor,
    required this.title,
    required this.subtitle,
  });

  final String imagePath;
  final Color tintColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    const double radius = 21;

    return TapClickableContainer(
      builder: (animationValue) => Transform.scale(
        scale: 1.0 + animationValue * 0.05,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.175),
                blurRadius: 21,
                offset: const Offset(5, 13),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(radius),
            child: Stack(
              children: [
                Positioned.fill(
                  child: _buildBackgroundImage(animationValue: animationValue),
                ),

                // Additional tint making the fade look more pronounced
                Positioned.fill(
                  child: Inspire.tint.bottomToTop(
                    color: tintColor,
                    opacity: 0.5,
                    extent: 0.5,
                    curve: Curves.easeOut,
                  ),
                ),

                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 13,
                  child: _buildTextContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundImage({required double animationValue}) {
    // Child blur effect wrapping the content to be blurred
    return Inspire.childBlur(
      config: InspireBlurConfig.bottomToTop(
        sigma: 55,
        extent: 0.5,
        fadeCurve: Curves.easeInOutQuad,
      ),

      // Image to be blurred (transform as an additional visual effect)
      child: Transform.scale(
        scale: 1.0 + animationValue * 0.35,
        alignment: Alignment.topCenter,
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 55,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
