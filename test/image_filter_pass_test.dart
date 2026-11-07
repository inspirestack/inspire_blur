import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inspire_blur/inspire_blur.dart';
import 'package:inspire_blur/src/child_blur/inspire_child_blur_image_filter_pass.dart';
import 'package:inspire_blur/src/distribution/distribution_image.dart';
import 'package:inspire_blur/src/model/aspect_ratio_correction.dart';

/// Loads the shaders in the real async zone (the widgets wait on the same
/// cached futures from their `initState`), then pumps [widget] until the
/// widgets have rebuilt with their shaders.
Future<void> pumpWithShaders(WidgetTester tester, Widget widget) async {
  await tester.runAsync(() => Inspire.warmUp());
  await tester.pumpWidget(widget);
  // The shader future completed in the real zone, so its callbacks run there.
  await tester.runAsync(() => Future<void>.delayed(Duration.zero));
  await tester.pump();
}

void main() {
  // `ImageFilter.shader` needs Impeller, which the default `flutter test`
  // renderer does not provide. Run with `flutter test --enable-impeller` to
  // exercise these cases.
  final skipWithoutShaderFilters = !ui.ImageFilter.isShaderFilterSupported;

  group('imageFilter pass', () {
    const boxSize = Size(200, 300);

    Future<RenderBox> pumpPass(WidgetTester tester, Clip clipBehavior) async {
      final mapImage = (await tester.runAsync(() {
        final recorder = ui.PictureRecorder();
        Canvas(recorder).drawPaint(Paint()..color = const Color(0xFFFFFFFF));
        return recorder.endRecording().toImage(1, 1);
      }))!;
      addTearDown(mapImage.dispose);

      await pumpWithShaders(
        tester,
        Directionality(
          textDirection: TextDirection.ltr,
          // Offstage lays the pass out without compositing it; its paint
          // calls are inspected with the `paints` matcher.
          child: Offstage(
            child: Center(
              child: SizedBox.fromSize(
                size: boxSize,
                child: InspireChildBlurImageFilterPass(
                  blurDistributionImage: DistributionImage.borrowed(mapImage),
                  opacityDistributionImage:
                      DistributionImage.borrowed(mapImage),
                  transform: BlurTransform.identity,
                  widgetOpacity: const WidgetOpacity.solid(),
                  colorAdjustment: const BlurColorAdjustment(),
                  aspectRatioCorrection: const AspectRatioCorrection(null),
                  direction: Axis.vertical,
                  sigma: 10,
                  clipBehavior: clipBehavior,
                  // A descendant that paints 100 px above the box, like a
                  // parallax background moved with Transform.translate.
                  child: Transform.translate(
                    offset: const Offset(0, -100),
                    child: const ColoredBox(color: Color(0xFF2196F3)),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // The pass's own render object: the first descendant of the pass
      // widget's element that owns one.
      final passElement = tester.element(
        find.byType(InspireChildBlurImageFilterPass, skipOffstage: false),
      );
      final renderBox = passElement.findRenderObject()! as RenderBox;
      expect(renderBox.size, boxSize);
      return renderBox;
    }

    // These check the paint calls, i.e. that the child is clipped to the
    // pass's box before it reaches the image filter. They do not inspect the
    // shader's uniforms or output.
    testWidgets(
      'clips the filtered child to its own box, so a descendant that paints '
      'outside the box cannot enlarge the shader texture',
      (tester) async {
        final pass = await pumpPass(tester, Clip.hardEdge);
        expect(pass, paints..clipRect(rect: Offset.zero & boxSize));
      },
      skip: skipWithoutShaderFilters,
    );

    testWidgets(
      'does not clip the child when clipBehavior is Clip.none',
      (tester) async {
        final pass = await pumpPass(tester, Clip.none);
        expect(pass, isNot(paints..clipRect()));
      },
      skip: skipWithoutShaderFilters,
    );
  });

  group('MediaQuery dependencies', () {
    // The blur only reads the screen size and the device pixel ratio. When
    // only the keyboard inset changes (every frame of a keyboard animation),
    // none of this package's widgets should rebuild.
    const blurRootKey = ValueKey<String>('blur-root');

    Future<int> rebuildsOnInsetChange(WidgetTester tester, Widget blur) async {
      // The same [blur] instance is reused, so anything that rebuilds below
      // it was marked dirty by a dependency, not by its parent.
      Widget app(EdgeInsets insets) => MediaQuery(
            data: MediaQueryData(
              size: const Size(400, 800),
              devicePixelRatio: 3,
              viewInsets: insets,
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: KeyedSubtree(key: blurRootKey, child: blur),
            ),
          );

      await pumpWithShaders(tester, app(EdgeInsets.zero));

      var rebuilds = 0;
      final previous = debugOnRebuildDirtyWidget;
      debugOnRebuildDirtyWidget = (element, builtOnce) {
        var insideBlur = false;
        element.visitAncestorElements((ancestor) {
          insideBlur = ancestor.widget.key == blurRootKey;
          return !insideBlur;
        });
        if (insideBlur) rebuilds++;
      };
      try {
        for (var i = 1; i <= 5; i++) {
          await tester.pumpWidget(app(EdgeInsets.only(bottom: 60.0 * i)));
        }
      } finally {
        debugOnRebuildDirtyWidget = previous;
      }
      // Let shader-load callbacks scheduled in the real zone run while the
      // tree is still mounted.
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      return rebuilds;
    }

    for (final mode in InspireBlurMode.values) {
      testWidgets(
          'child blur ($mode) does not rebuild when only viewInsets change',
          (tester) async {
        final rebuilds = await rebuildsOnInsetChange(
          tester,
          Inspire.childBlur(
            mode: mode,
            config: InspireBlurConfig.topToBottom(sigma: 10),
            child: const SizedBox.expand(),
          ),
        );
        expect(rebuilds, 0);
      });
    }

    // Backdrop blur renders nothing without shader image filters.
    testWidgets(
      'backdrop blur does not rebuild when only viewInsets change',
      (tester) async {
        final rebuilds = await rebuildsOnInsetChange(
          tester,
          Inspire.backdropBlur(
            config: InspireBlurConfig.topToBottom(sigma: 10),
            child: const SizedBox.expand(),
          ),
        );
        expect(rebuilds, 0);
      },
      skip: skipWithoutShaderFilters,
    );
  });
}
