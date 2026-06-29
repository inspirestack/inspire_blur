import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inspire_blur/inspire_blur.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Warm up the GLSL fragment shaders for seamless, stutter-free performance
  Inspire.warmUp();

  // Set edge-to-edge mode for a transparent status bar
  _initializeUi();

  runApp(const _ExampleApp());
}

class _ExampleApp extends StatelessWidget {
  const _ExampleApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Inspire Blur Demo',
      debugShowCheckedModeBanner: false,
      home: _DemoScreen(),
    );
  }
}

class _DemoScreen extends StatefulWidget {
  const _DemoScreen();

  @override
  State<_DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<_DemoScreen> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: _currentPage,
        onDestinationSelected: (index) => setState(() => _currentPage = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.layers_rounded),
            label: 'Backdrop blur',
          ),
          NavigationDestination(
            icon: Icon(Icons.widgets_rounded),
            label: 'Child blur',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentPage,
        children: const [
          _BackdropBlurDemo(key: PageStorageKey('backdrop_blur')),
          _ChildBlurDemo(key: PageStorageKey('child_blur')),
        ],
      ),
    );
  }
}

// ============================================================================
// SCREEN 1: Backdrop Blur
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

class _BackdropBlurDemo extends StatelessWidget {
  const _BackdropBlurDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Stack that expands to the whole screen
    return Stack(
      fit: StackFit.expand,
      children: [
        // Content to be blurred
        const Positioned.fill(child: _BackdropBlurDemoContent()),

        // Backdrop blur effect that will blur the content behind it.
        //
        // To render a top fade, the backdrop blur doesn't have to fill
        // the whole screen.
        //
        // For better performance, the blur effect should only be displayed
        // where it is actually applied. In this example it takes only
        // 132dp from the top of the screen.
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: 132,
          child: Inspire.backdropBlur(
            config: InspireBlurConfig.topToBottom(sigma: 34),
          ),
        ),
      ],
    );
  }
}

/// List with image cards for the backdrop blur example.
class _BackdropBlurDemoContent extends StatelessWidget {
  const _BackdropBlurDemoContent();

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
      child: Column(
        children: _demoImages
            .map((image) => _buildImage(imagePath: image.url))
            .toList(),
      ),
    );
  }

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
          child: AspectRatio(
            aspectRatio: 1.4,
            child: Image.network(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SCREEN 2: Child Blur
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

class _ChildBlurDemo extends StatelessWidget {
  const _ChildBlurDemo({super.key});

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
      itemCount: _demoImages.length,
      itemBuilder: (context, index) {
        final image = _demoImages[index];

        return _ChildBlurDemoCard(
          key: ValueKey(image.url),
          imagePath: image.url,
          tintColor: image.tint,
          title: image.title,
          subtitle: image.subtitle,
        );
      },
    );
  }
}

/// List with image cards for the child blur example.
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

    return _ClickableContainer(
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
            borderRadius: BorderRadius.circular(radius),
            child: Stack(
              children: [
                Positioned.fill(
                  child: _buildBackgroundImage(animationValue: animationValue),
                ),

                // Additional tint making the fade look more distinct
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
    // Child blur effect that wraps inside the content to be blurred
    return Inspire.childBlur(
      config: InspireBlurConfig.bottomToTop(
        sigma: 55,
        extent: 0.5,
        fadeCurve: Curves.easeInOutQuad,
      ),

      // Widget to be blurred (transform applied as an extra visual effect)
      child: Transform.scale(
        scale: 1.0 + animationValue * 0.4,
        alignment: Alignment.topCenter,
        child: Image.network(
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

// ============================================================================
// DEMO IMAGES
//
// Not needed for InspireBlur to work. Intended for demo only.
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

const _demoImages = [
  _DemoImage(
    'https://raw.githubusercontent.com/inspirestack/inspire_blur/main/assets/example/images/watermelon.jpg',
    Color.fromARGB(255, 189, 189, 189),
    'Watermelon',
    'Citrullus lanatus',
  ),
  _DemoImage(
    'https://raw.githubusercontent.com/inspirestack/inspire_blur/main/assets/example/images/cosmos-flowers.jpg',
    Color.fromARGB(255, 202, 244, 134),
    'Cosmos Flowers',
    'Found at allotments · Wrocław, PL',
  ),
  _DemoImage(
    'https://raw.githubusercontent.com/inspirestack/inspire_blur/main/assets/example/images/head-of-david.jpg',
    Color.fromARGB(255, 224, 224, 224),
    'Head of David',
    'Marble sculpture',
  ),
  _DemoImage(
    'https://raw.githubusercontent.com/inspirestack/inspire_blur/main/assets/example/images/london-plane-tree.jpg',
    Color.fromARGB(255, 128, 207, 241),
    'London Plane Tree',
    'Found in Park Grabiszyński · Wrocław, PL',
  ),
  _DemoImage(
    'https://raw.githubusercontent.com/inspirestack/inspire_blur/main/assets/example/images/hibiscus.jpg',
    Color.fromARGB(255, 134, 205, 237),
    'Hibiscus syriacus',
    'Rose of Sharon',
  ),
  _DemoImage(
    'https://raw.githubusercontent.com/inspirestack/inspire_blur/main/assets/example/images/monkey-puzzle-tree.jpg',
    Color.fromARGB(255, 191, 246, 149),
    'Monkey Puzzle Tree',
    'Observed at Kew Gardens · London, UK',
  ),
];

class _DemoImage {
  final String url;
  final Color tint;
  final String title;
  final String subtitle;

  const _DemoImage(this.url, this.tint, this.title, this.subtitle);
}

// ============================================================================
// DEMO UTILITIES
//
// Not needed for InspireBlur to work. Intended for demo only.
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

void _initializeUi() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

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

class _ClickableContainer extends StatefulWidget {
  final Widget Function(double) builder;

  const _ClickableContainer({required this.builder});

  @override
  State<_ClickableContainer> createState() => _ClickableContainerState();
}

class _ClickableContainerState extends State<_ClickableContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutSine,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (_) => _startAnimation(),
      onPanEnd: (_) => _endAnimation(),
      onPanCancel: () => _endAnimation(),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => widget.builder(_animation.value),
      ),
    );
  }

  void _startAnimation() => _controller.forward();
  void _endAnimation() => _controller.reverse();
}
